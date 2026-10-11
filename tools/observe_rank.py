#!/usr/bin/env python3
"""Record one CurseForge popularity page, without retries or download requests.

An observation is a page position, not a claim about CurseForge's private ranking
formula. Unsupported markup, CAPTCHA, or network failures produce unknown status.
Manual records must be a complete page, in its visible order, with evidence cited.
"""

import argparse
from datetime import datetime, timezone
import hashlib
from http.client import HTTPException
from html.parser import HTMLParser
import json
from pathlib import Path
import re
import sys
from urllib.parse import parse_qs, urlparse
from urllib.request import build_opener, HTTPRedirectHandler, Request
from uuid import uuid4


DEFAULT_URL = "https://www.curseforge.com/wow/search?class=addons&page=1&pageSize=20&sortBy=popularity"
MAX_BYTES = 5 * 1024 * 1024
SLUG = re.compile(r"[a-z0-9]+(?:-[a-z0-9]+)*")


def listing_parameters(url):
    parsed = urlparse(url)
    if (parsed.scheme != "https" or parsed.netloc not in ("www.curseforge.com", "curseforge.com")
            or parsed.path != "/wow/search" or parsed.fragment):
        raise ValueError("Source must be an HTTPS CurseForge WoW search URL")
    query = parse_qs(parsed.query, keep_blank_values=True)
    if set(query) != {"class", "page", "pageSize", "sortBy"}:
        raise ValueError("Use an unfiltered listing with class, page, pageSize, and sortBy only")
    if any(len(value) != 1 for value in query.values()):
        raise ValueError("Duplicate URL parameters are unsupported")
    if query["class"] != ["addons"] or query["sortBy"] != ["popularity"]:
        raise ValueError("Source must explicitly sort WoW addons by popularity")
    try:
        page, page_size = int(query["page"][0]), int(query["pageSize"][0])
    except ValueError as error:
        raise ValueError("Invalid page number or size") from error
    if page < 1 or page_size not in (10, 20, 50):
        raise ValueError("Page must be positive and pageSize must be 10, 20, or 50")
    return page, page_size


def project_slug(url):
    if not isinstance(url, str):
        return None
    parsed = urlparse(url)
    if parsed.netloc and parsed.netloc not in ("www.curseforge.com", "curseforge.com"):
        return None
    if parsed.scheme and parsed.scheme != "https":
        return None
    if parsed.query or parsed.fragment:
        return None
    match = re.fullmatch(r"/wow/addons/([a-z0-9]+(?:-[a-z0-9]+)*)/?", parsed.path)
    return match.group(1) if match else None


class ListingHTML(HTMLParser):
    """Conservative support for project-card blocks and explicit JSON-LD lists."""
    VOID = {"area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "param", "source", "track", "wbr"}

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.stack = []
        self.card = None
        self.anchor = None
        self.cards = []
        self.json_blocks = []
        self.script = None
        self.h1 = []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag in self.VOID:
            return
        self.stack.append(tag)
        depth = len(self.stack)
        if tag == "script" and attrs.get("type") == "application/ld+json":
            self.script = {"depth": depth, "text": []}
        if "project-card" in attrs.get("class", "").split():
            if self.card:
                raise ValueError("Nested project cards are unsupported")
            self.card = {"depth": depth, "anchors": []}
        if self.card and tag == "a":
            slug = project_slug(attrs.get("href", ""))
            if slug:
                self.anchor = {"depth": depth, "slug": slug, "text": []}

    def handle_endtag(self, tag):
        if tag not in self.stack:
            return
        depth = len(self.stack) - self.stack[::-1].index(tag)
        if self.anchor and self.anchor["depth"] >= depth:
            self.card["anchors"].append(self.anchor)
            self.anchor = None
        if self.card and self.card["depth"] >= depth:
            anchors = self.card["anchors"]
            slugs = {anchor["slug"] for anchor in anchors}
            names = [" ".join("".join(anchor["text"]).split()) for anchor in anchors]
            names = [name for name in names if name and name.lower() not in ("download", "install")]
            if len(slugs) != 1 or len(set(names)) != 1:
                raise ValueError("Project card does not have one unambiguous name and slug")
            self.cards.append({"slug": slugs.pop(), "projectName": names[0]})
            self.card = None
        if self.script and self.script["depth"] >= depth:
            self.json_blocks.append("".join(self.script["text"]))
            self.script = None
        del self.stack[depth - 1:]

    def handle_data(self, data):
        if self.script:
            self.script["text"].append(data)
        if self.anchor:
            self.anchor["text"].append(data)
        if "h1" in self.stack:
            self.h1.append(data)


def validate_projects(projects, page_size):
    if len(projects) != page_size:
        raise ValueError("Expected a complete page of %d projects; observed %d" % (page_size, len(projects)))
    if len({project["slug"] for project in projects}) != len(projects):
        raise ValueError("Duplicate project slugs make listing order ambiguous")
    for project in projects:
        if not SLUG.fullmatch(project["slug"]) or not project["projectName"].strip():
            raise ValueError("Every project needs a valid slug and nonempty name")
    return projects


def parse_listing(html, url):
    _, page_size = listing_parameters(url)
    lowered = html.lower()
    if any(marker in lowered for marker in ("captcha", "cf-chl-", "verify you are human", "just a moment", "challenge-form", "access denied")):
        raise ValueError("CAPTCHA or access challenge: no rank can be observed")
    parser = ListingHTML()
    parser.feed(html)
    parser.close()
    if parser.card or parser.script:
        raise ValueError("Incomplete HTML document")
    if parser.cards:
        heading = " ".join("".join(parser.h1).split())
        if heading != "Browse Addons for World of Warcraft":
            raise ValueError("Project cards are not in the expected WoW listing")
        return validate_projects(parser.cards, page_size)
    lists = []
    for block in parser.json_blocks:
        try:
            value = json.loads(block)
        except json.JSONDecodeError as error:
            raise ValueError("Malformed JSON-LD") from error
        candidates = value if isinstance(value, list) else [value]
        for candidate in candidates:
            if not isinstance(candidate, dict):
                continue
            if "@graph" in candidate:
                if not isinstance(candidate["@graph"], list):
                    raise ValueError("Unsupported JSON-LD graph")
                candidates.extend(candidate["@graph"])
            if candidate.get("@type") == "ItemList" and candidate.get("url") == url:
                lists.append(candidate)
    if len(lists) != 1:
        raise ValueError("Unsupported markup: no unambiguous listing order found")
    items = lists[0].get("itemListElement", [])
    if not isinstance(items, list):
        raise ValueError("JSON-LD listing items must be an array")
    projects = []
    for expected, entry in enumerate(items, 1):
        if not isinstance(entry, dict) or type(entry.get("position")) is not int or entry["position"] != expected:
            raise ValueError("JSON-LD positions must be consecutive in visible order")
        item = entry.get("item", entry)
        if not isinstance(item, dict):
            raise ValueError("JSON-LD project details are missing")
        slug = project_slug(item.get("url", item.get("@id", "")))
        name = item.get("name")
        if not slug or not isinstance(name, str) or not name.strip():
            raise ValueError("JSON-LD project name or slug is missing")
        projects.append({"slug": slug, "projectName": name.strip()})
    return validate_projects(projects, page_size)


class NoRedirect(HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


def fetch_once(url):
    listing_parameters(url)
    request = Request(url, headers={"User-Agent": "SessionScout-rank-observer/0.1 (single-page observation)", "Accept": "text/html"})
    with build_opener(NoRedirect).open(request, timeout=30) as response:
        if response.headers.get_content_type() != "text/html":
            raise ValueError("Response is not HTML")
        raw = response.read(MAX_BYTES + 1)
        if len(raw) > MAX_BYTES:
            raise ValueError("Response exceeded the single-page size limit")
        return raw.decode(response.headers.get_content_charset() or "utf-8")


def snapshot(url, project_name, own_slug, projects=None, error=None, method="html", evidence=None, content_hash=None):
    page, page_size = listing_parameters(url)
    if own_slug and not SLUG.fullmatch(own_slug):
        raise ValueError("Own slug must be an exact registered project slug")
    ordered = [dict(project, positionOnPage=index, observedRank=(page - 1) * page_size + index)
               for index, project in enumerate(projects or [], 1)]
    complete = bool(projects) and len(projects) == page_size and not error
    matched = next((project for project in ordered if project["slug"] == own_slug), None)
    status = "unknown" if error or not own_slug else "ranked" if matched else "not-on-page" if complete else "unknown"
    return {
        "schemaVersion": 1,
        "observedAt": datetime.now(timezone.utc).isoformat(timespec="seconds").replace("+00:00", "Z"),
        "source": url,
        "method": method,
        "evidenceSource": evidence,
        "sourceSha256": content_hash,
        "projectName": project_name,
        "ownSlug": own_slug,
        "status": status,
        "observedRank": matched["observedRank"] if matched and not error else None,
        "page": page,
        "pageSize": page_size,
        "pageComplete": complete,
        "projects": ordered,
        "reason": error or ("No registered project slug supplied; publication and rank are unknown." if not own_slug else None),
    }


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--url", default=DEFAULT_URL)
    parser.add_argument("--project-name", default="SessionScout")
    parser.add_argument("--own-slug", help="Only supply a verified, registered project slug")
    sources = parser.add_mutually_exclusive_group()
    sources.add_argument("--from-file", type=Path, help="Read saved HTML instead of making a request")
    sources.add_argument("--record", action="append", metavar="SLUG=NAME", help="Manually record each visible project in order; repeat for the entire page")
    parser.add_argument("--evidence-source", help="Required for --record; identify the page capture or observed source")
    parser.add_argument("--output-dir", type=Path, default=Path(__file__).resolve().parents[1] / "data")
    args = parser.parse_args(argv)
    try:
        _, page_size = listing_parameters(args.url)
        if args.own_slug and not SLUG.fullmatch(args.own_slug):
            raise ValueError("Own slug is invalid")
        if args.record and not args.evidence_source:
            raise ValueError("Manual observations require --evidence-source")
    except ValueError as error:
        parser.error(str(error))
    projects, error, content_hash = None, None, None
    method = "manual" if args.record else "saved-html" if args.from_file else "http"
    try:
        if args.record:
            projects = []
            for record in args.record:
                slug, separator, name = record.partition("=")
                if not separator:
                    raise ValueError("Manual entries must use SLUG=NAME")
                projects.append({"slug": slug, "projectName": name.strip()})
            projects = validate_projects(projects, page_size)
        else:
            html = args.from_file.read_text(encoding="utf-8-sig") if args.from_file else fetch_once(args.url)
            content_hash = hashlib.sha256(html.encode("utf-8")).hexdigest()
            projects = parse_listing(html, args.url)
    except (ValueError, OSError, UnicodeError, HTTPException) as exception:
        error, projects = str(exception), None
    result = snapshot(args.url, args.project_name, args.own_slug, projects, error, method,
                      args.evidence_source or (str(args.from_file.resolve()) if args.from_file else args.url), content_hash)
    args.output_dir.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
    destination = args.output_dir / ("popularity-" + stamp + "-" + uuid4().hex + ".json")
    with destination.open("x", encoding="utf-8", newline="\n") as output:
        json.dump(result, output, ensure_ascii=False, indent=2)
        output.write("\n")
    print(str(destination))
    print(result["status"] + (": " + error if error else ""))
    return 1 if error else 0


if __name__ == "__main__":
    sys.exit(main())
