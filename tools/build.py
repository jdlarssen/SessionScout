#!/usr/bin/env python3
"""Build a deterministic, local SessionScout ZIP. This never uploads a release."""

import argparse
import hashlib
import re
from pathlib import Path
import sys
import zipfile


ADDON = "SessionScout"
FLAVOR_INTERFACES = {"forever": "16001"}
FIXED_TIME = (1980, 1, 1, 0, 0, 0)
PLACEHOLDER = re.compile(
    r"(?:@[^@\s]+@|\$\{[^}]+\}|\{\{[^}]+\}\}|<[^>]+>|"
    r"\b(?:TODO|TBD|FIXME|PLACEHOLDER|CHANGEME|YOUR[_ ](?:NAME|AUTHOR|VERSION)|REPLACE[_ -]?ME)\b)",
    re.I,
)


def collect_files(root, flavor="forever"):
    """Use the TOC as the allowlist; refuse unsafe or missing references."""
    root = Path(root).resolve()
    if flavor not in FLAVOR_INTERFACES:
        raise ValueError("Unsupported release flavor: " + flavor)
    addon = root / ADDON
    if addon.is_symlink():
        raise ValueError("Addon directory must not be a symbolic link")
    toc = addon / (ADDON + ".toc")
    if not toc.is_file() or toc.is_symlink():
        raise ValueError("Missing regular file: " + str(toc))
    metadata = {}
    files = [(ADDON + "/" + toc.name, toc.read_bytes())]
    seen = {toc.name.casefold()}
    for line in files[0][1].decode("utf-8-sig").splitlines():
        line = line.strip()
        if line.startswith("##"):
            key, separator, value = line[2:].partition(":")
            if separator:
                key, value = key.strip(), value.strip()
                if not value or PLACEHOLDER.search(value):
                    raise ValueError("Unresolved TOC metadata: " + key)
                if key in metadata:
                    raise ValueError("Duplicate TOC metadata: " + key)
                metadata[key] = value
        elif line and not line.startswith("#"):
            relative = line.replace("\\", "/")
            if not re.fullmatch(r"[A-Za-z0-9_./-]+\.lua", relative):
                raise ValueError("Only explicit .lua references are allowed: " + line)
            path = addon / relative
            if relative.startswith("/") or any(part in ("", ".", "..") for part in relative.split("/")):
                raise ValueError("Unsafe TOC path: " + line)
            if path.resolve().parent != addon.resolve() and addon.resolve() not in path.resolve().parents:
                raise ValueError("TOC reference escapes addon directory: " + line)
            if path.is_symlink() or any(parent.is_symlink() for parent in path.parents if parent != root.parent):
                raise ValueError("Symbolic links are not release files: " + line)
            if not path.is_file():
                raise ValueError("Missing TOC file: " + line)
            if relative.casefold() in seen:
                raise ValueError("Duplicate TOC file: " + line)
            seen.add(relative.casefold())
            files.append((ADDON + "/" + relative, path.read_bytes()))
    for key in ("Interface", "Title", "Author", "Version"):
        if key not in metadata:
            raise ValueError("Missing TOC metadata: " + key)
    if not re.fullmatch(r"\d{5,6}(?:\s*,\s*\d{5,6})*", metadata["Interface"]):
        raise ValueError("Interface must contain explicit numeric client versions")
    if any(int(interface.strip()) == 0 for interface in metadata["Interface"].split(",")):
        raise ValueError("Interface must not use a zero placeholder")
    if metadata["Interface"] != FLAVOR_INTERFACES[flavor]:
        raise ValueError("Flavor %s requires Interface exactly %s" % (flavor, FLAVOR_INTERFACES[flavor]))
    version = metadata["Version"]
    if not re.fullmatch(r"\d+\.\d+\.\d+(?:-[A-Za-z0-9.-]+)?", version):
        raise ValueError("Version must be a concrete semantic version")
    if len(files) < 2:
        raise ValueError("TOC contains no Lua files")
    license_path = root / "LICENSE"
    if license_path.exists():
        if not license_path.is_file() or license_path.is_symlink():
            raise ValueError("LICENSE must be a regular file")
        files.append((ADDON + "/LICENSE", license_path.read_bytes()))
    return version, sorted(files)


def build(root, output_dir=None, flavor="forever"):
    root = Path(root).resolve()
    version, files = collect_files(root, flavor)
    output_dir = Path(output_dir) if output_dir else root / "dist"
    output_dir.mkdir(parents=True, exist_ok=True)
    destination = output_dir / (ADDON + "-" + version + "-" + flavor + ".zip")
    temporary = destination.with_suffix(".zip.tmp")
    try:
        # Stored entries avoid compressor-version differences across machines.
        with zipfile.ZipFile(temporary, "w", compression=zipfile.ZIP_STORED) as archive:
            for name, content in files:
                info = zipfile.ZipInfo(name, date_time=FIXED_TIME)
                info.create_system = 3
                info.external_attr = 0o100644 << 16
                info.compress_type = zipfile.ZIP_STORED
                archive.writestr(info, content)
        digest = hashlib.sha256(temporary.read_bytes()).hexdigest()
        temporary.replace(destination)
        destination.with_suffix(".zip.sha256").write_text(
            digest + "  " + destination.name + "\n", encoding="utf-8", newline="\n"
        )
    finally:
        if temporary.exists():
            temporary.unlink()
    return destination, digest


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--output-dir", type=Path)
    parser.add_argument("--flavor", choices=sorted(FLAVOR_INTERFACES), default="forever",
                        help="Release target; only the explicitly configured Forever target is supported")
    args = parser.parse_args(argv)
    try:
        destination, digest = build(args.root, args.output_dir, args.flavor)
    except (ValueError, OSError, UnicodeError) as error:
        parser.exit(1, "Build refused: " + str(error) + "\n")
    print(str(destination))
    print("SHA256 " + digest)
    return 0


if __name__ == "__main__":
    sys.exit(main())
