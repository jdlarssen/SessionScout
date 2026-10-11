"""Offline standard-library tests. Fixtures model supported markup, not a live claim."""

import hashlib
from contextlib import redirect_stderr, redirect_stdout
from datetime import datetime, timezone
import io
import json
import os
from pathlib import Path
import sys
import tempfile
import unittest
from unittest import mock
import zipfile

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from tools import build, observe_rank as rank


URL = rank.DEFAULT_URL


def projects(count=20):
    return [{"slug": "addon-%d" % index, "projectName": "Addon %d" % index} for index in range(1, count + 1)]


def card_fixture(entries=None):
    entries = entries if entries is not None else projects()
    cards = [('<div class="project-card"><a href="/wow/addons/{slug}"><img src="x"></a>'
              '<a class="name" href="/wow/addons/{slug}"><span>{projectName}</span></a>'
              '<a href="/wow/addons/{slug}/download">Download</a></div>').format(**project) for project in entries]
    return '<html><h1>Browse Addons for World of Warcraft</h1><main>' + "".join(cards) + '</main></html>'


def json_fixture(entries=None, url=URL):
    entries = entries if entries is not None else projects()
    listing = {"@context": "https://schema.org", "@type": "ItemList", "url": url,
               "itemListElement": [{"@type": "ListItem", "position": index,
                                    "item": {"name": project["projectName"], "url": "https://www.curseforge.com/wow/addons/" + project["slug"]}}
                                   for index, project in enumerate(entries, 1)]}
    return '<script type="application/ld+json">' + json.dumps(listing) + '</script>'


class RankingTests(unittest.TestCase):
    def test_cards_preserve_display_order_and_ignore_download_links(self):
        self.assertEqual(rank.parse_listing(card_fixture(), URL), projects())

    def test_json_ld_requires_explicit_positions_and_matching_source(self):
        self.assertEqual(rank.parse_listing(json_fixture(), URL), projects())
        with self.assertRaises(ValueError):
            rank.parse_listing(json_fixture().replace('"position": 2', '"position": 1'), URL)
        with self.assertRaises(ValueError):
            rank.parse_listing(json_fixture(url="https://example.com"), URL)

    def test_challenge_cannot_report_rank_even_with_cards(self):
        for challenge in ("CAPTCHA", "cf-chl-", "Verify you are human", "Access Denied"):
            with self.subTest(challenge=challenge), self.assertRaises(ValueError):
                rank.parse_listing(card_fixture() + challenge, URL)

    def test_unsupported_incomplete_and_duplicate_lists_fail_closed(self):
        cases = ["<a href='/wow/addons/addon-1'>Addon 1</a>", card_fixture(projects(19)),
                 card_fixture(projects(19) + [projects()[0]]), card_fixture().replace("Browse Addons for World of Warcraft", "Recommendations"),
                 json_fixture().replace('"itemListElement": [', '"itemListElement": [null,'),
                 '<script type="application/ld+json">{"@graph":5}</script>',
                 '<script type="application/ld+json">{bad json}</script>']
        for html in cases:
            with self.subTest(html=html[:60]), self.assertRaises(ValueError):
                rank.parse_listing(html, URL)

    def test_url_rejects_filters_downloads_other_hosts_or_sorting(self):
        cases = [URL.replace("popularity", "totalDownloads"), URL + "&category=tools", URL + "&page=2",
                 URL.replace("www.curseforge.com", "example.com"), URL.replace("page=1", "page=0"),
                 URL.replace("pageSize=20", "pageSize=500"), URL.replace("/wow/search", "/wow/addons/dbm/download"),
                 URL.replace("https:", "http:")]
        for url in cases:
            with self.subTest(url=url), self.assertRaises(ValueError):
                rank.listing_parameters(url)

    def test_unknown_for_unpublished_or_incomplete_absent_project(self):
        observation = rank.snapshot(URL, "SessionScout", None, projects())
        self.assertEqual(observation["status"], "unknown")
        self.assertIsNone(observation["observedRank"])
        self.assertTrue(observation["observedAt"].endswith("Z"))
        incomplete = rank.snapshot(URL, "SessionScout", "session-scout", projects(2))
        self.assertEqual(incomplete["status"], "unknown")

    def test_absence_is_only_not_on_observed_complete_page(self):
        observation = rank.snapshot(URL, "SessionScout", "session-scout", projects())
        self.assertEqual(observation["status"], "not-on-page")
        self.assertIsNone(observation["observedRank"])
        self.assertTrue(observation["pageComplete"])

    def test_rank_uses_slug_and_page_offset(self):
        observation = rank.snapshot(URL.replace("page=1", "page=2"), "Any display name", "addon-3", projects())
        self.assertEqual(observation["status"], "ranked")
        self.assertEqual(observation["observedRank"], 23)
        failed = rank.snapshot(URL, "A", "addon-3", projects(), error="Failed validation")
        self.assertEqual(failed["status"], "unknown")
        self.assertIsNone(failed["observedRank"])

    def test_network_failure_is_one_attempt_and_saves_unknown_snapshot(self):
        with tempfile.TemporaryDirectory() as directory, mock.patch.object(rank, "fetch_once", side_effect=OSError("HTTP 403")) as fetch, redirect_stdout(io.StringIO()):
            self.assertEqual(rank.main(["--output-dir", directory, "--own-slug", "addon-1"]), 1)
            fetch.assert_called_once_with(URL)
            observation = json.loads(next(Path(directory).glob("*.json")).read_text(encoding="utf-8"))
            self.assertEqual(observation["status"], "unknown")
            self.assertIsNone(observation["observedRank"])
            self.assertEqual(observation["projects"], [])

    def test_redirects_are_refused_instead_of_sending_another_request(self):
        self.assertIsNone(rank.NoRedirect().redirect_request(None, None, 302, "Found", {}, "https://example.com"))

    def test_saved_html_and_manual_modes_never_request_network(self):
        with tempfile.TemporaryDirectory() as directory, mock.patch.object(rank, "fetch_once", side_effect=AssertionError("Unexpected network")), redirect_stdout(io.StringIO()):
            fixture = Path(directory) / "fixture.html"
            fixture.write_text(card_fixture(), encoding="utf-8")
            output = Path(directory) / "observations"
            self.assertEqual(rank.main(["--from-file", str(fixture), "--output-dir", str(output)]), 0)
            arguments = ["--output-dir", str(output), "--evidence-source", "saved screenshot of requested listing"]
            for project in projects():
                arguments.extend(["--record", project["slug"] + "=" + project["projectName"]])
            self.assertEqual(rank.main(arguments), 0)
            observations = [json.loads(path.read_text(encoding="utf-8")) for path in output.glob("*.json")]
            self.assertEqual({item["method"] for item in observations}, {"manual", "saved-html"})
            self.assertTrue(all(item["status"] == "unknown" for item in observations))

    def test_manual_mode_requires_evidence(self):
        with self.assertRaises(SystemExit) as raised, redirect_stderr(io.StringIO()):
            rank.main(["--record", "example=Example"])
        self.assertEqual(raised.exception.code, 2)

    def test_identical_timestamps_preserve_both_observations(self):
        fixed_time = datetime(2026, 10, 11, 10, 11, 12, 123456, tzinfo=timezone.utc)
        with tempfile.TemporaryDirectory() as directory, mock.patch.object(rank, "datetime") as clock, redirect_stdout(io.StringIO()):
            clock.now.return_value = fixed_time
            fixture = Path(directory) / "fixture.html"
            fixture.write_text(card_fixture(), encoding="utf-8")
            output = Path(directory) / "observations"
            arguments = ["--from-file", str(fixture), "--output-dir", str(output)]
            self.assertEqual(rank.main(arguments + ["--project-name", "First observation"]), 0)
            first_path = next(output.glob("*.json"))
            first_bytes = first_path.read_bytes()
            self.assertEqual(rank.main(arguments + ["--project-name", "Second observation"]), 0)
            paths = list(output.glob("*.json"))
            self.assertEqual(len(paths), 2)
            self.assertEqual(first_path.read_bytes(), first_bytes)
            observations = [json.loads(path.read_text(encoding="utf-8")) for path in paths]
            self.assertEqual({item["projectName"] for item in observations}, {"First observation", "Second observation"})
            self.assertEqual({item["observedAt"] for item in observations}, {"2026-10-11T10:11:12Z"})
            self.assertTrue(all(path.name.startswith("popularity-20261011T101112123456Z-") for path in paths))


class BuildTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        self.addon = self.root / "SessionScout"
        self.addon.mkdir()
        self.toc = self.addon / "SessionScout.toc"
        self.toc.write_text("## Interface: 16001\n## Title: SessionScout\n## Author: SessionScout contributors\n## Version: 0.1.0-alpha.1\nCore.lua\n", encoding="utf-8")
        (self.addon / "Core.lua").write_text("local example = true\n", encoding="utf-8")
        (self.root / "LICENSE").write_text("Example license for test fixture\n", encoding="utf-8")

    def tearDown(self):
        self.temporary.cleanup()

    def test_archive_is_reproducible_and_only_contains_allowlisted_files(self):
        (self.addon / "secrets.txt").write_text("do not ship", encoding="utf-8")
        (self.addon / "Unreferenced.lua").write_text("do not ship", encoding="utf-8")
        first, digest = build.build(self.root)
        self.assertEqual(first.name, "SessionScout-0.1.0-alpha.1-forever.zip")
        contents = first.read_bytes()
        os.utime(self.addon / "Core.lua", (1000000000, 1000000000))
        second, second_digest = build.build(self.root)
        self.assertEqual(contents, second.read_bytes())
        self.assertEqual(digest, second_digest)
        self.assertEqual(digest, hashlib.sha256(contents).hexdigest())
        self.assertIn(digest, first.with_suffix(".zip.sha256").read_text(encoding="utf-8"))
        with zipfile.ZipFile(first) as archive:
            self.assertEqual(archive.namelist(), ["SessionScout/Core.lua", "SessionScout/LICENSE", "SessionScout/SessionScout.toc"])
            self.assertTrue(all(entry.date_time == build.FIXED_TIME for entry in archive.infolist()))

    def test_missing_file_or_metadata_refuses_release(self):
        original = self.toc.read_text(encoding="utf-8")
        for text in (original.replace("Core.lua", "Missing.lua"), original.replace("## Author: SessionScout contributors\n", "")):
            self.toc.write_text(text, encoding="utf-8")
            with self.assertRaises(ValueError):
                build.build(self.root)
        self.assertFalse((self.root / "dist").exists())

    def test_forever_build_refuses_other_or_multiple_client_interfaces(self):
        original = self.toc.read_text(encoding="utf-8")
        for interface in ("120100", "16000", "16001, 120100"):
            self.toc.write_text(original.replace("16001", interface), encoding="utf-8")
            with self.subTest(interface=interface), self.assertRaisesRegex(ValueError, "requires Interface exactly 16001"):
                build.build(self.root, flavor="forever")
        self.assertFalse((self.root / "dist").exists())

    def test_no_unconfigured_release_flavors_are_claimed(self):
        with self.assertRaisesRegex(ValueError, "Unsupported release flavor"):
            build.build(self.root, flavor="retail")
        self.assertFalse((self.root / "dist").exists())

    def test_placeholder_versions_or_metadata_refuse_release(self):
        original = self.toc.read_text(encoding="utf-8")
        for replacement in ("@project-version@", "TODO", "<version>", "../bad", "${VERSION}", "{{version}}"):
            self.toc.write_text(original.replace("0.1.0-alpha.1", replacement), encoding="utf-8")
            with self.subTest(replacement=replacement), self.assertRaises(ValueError):
                build.build(self.root)

    def test_unsafe_duplicate_and_non_lua_references_refuse_release(self):
        original = self.toc.read_text(encoding="utf-8")
        for reference in ("../Core.lua", "./Core.lua", "Core.lua\nCore.lua", "Core.xml", "/Core.lua"):
            self.toc.write_text(original.replace("Core.lua", reference), encoding="utf-8")
            with self.subTest(reference=reference), self.assertRaises(ValueError):
                build.build(self.root)


if __name__ == "__main__":
    unittest.main()
