"""Observe one pinned TOG Tools parser offline; does not install or launch WoW.

Requires an existing Lupa Lua 5.1 runtime and the official, separately downloaded
TOG Tools file 9095461. Only the hash-pinned ErrorInterpreter.lua member is read.
This is a narrow research observation, not a client or product comparison test.
"""
import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import sys
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[1]
ZIP_SHA256 = "04530bbcd39a53b97419ac22414c9e27a72e0b057dd4bdb78cca94f2bdc70dd0"
SOURCE_SHA256 = "4164bcca8cb99973316def948edbfe7de62c329daf6fff2c1d3899bf692f18df"
MEMBER = "TOGTools/Modules/Diagnostics/ErrorInterpreter.lua"


def main():
    args = argparse.ArgumentParser(description=__doc__)
    args.add_argument("--zip", type=Path, required=True)
    args.add_argument("--output", type=Path, required=True)
    options = args.parse_args()
    if options.output.exists():
        args.error("Output already exists; choose a new observation path.")
    if options.zip.stat().st_size > 3_000_000:
        args.error("Unexpected package size.")
    if hashlib.sha256(options.zip.read_bytes()).hexdigest() != ZIP_SHA256:
        args.error("Not the inspected official package; no code executed.")
    with ZipFile(options.zip) as archive:
        if archive.getinfo(MEMBER).file_size != 23724:
            args.error("Unexpected parser size.")
        source = archive.read(MEMBER)
    if hashlib.sha256(source).hexdigest() != SOURCE_SHA256:
        args.error("Parser hash differs from the inspected source.")

    inputs = json.loads((ROOT / "data/togtools-parser-inputs-20261011.json").read_text("utf-8"))
    sys.path.insert(0, str(ROOT / ".tools/python"))
    import lupa
    from lupa.lua51 import LuaRuntime

    # Source reviewed before execution. It receives no WoW APIs, Python objects,
    # filesystem/network functions, loader, or metadata callback in its environment.
    lua = LuaRuntime(register_eval=False, register_builtins=False, max_memory=4 * 1024 * 1024)
    load_parser = lua.eval("""function(source)
        local env = {type=type, tostring=tostring, tonumber=tonumber,
                     ipairs=ipairs, pairs=pairs, string=string,
                     table={concat=table.concat}}
        local chunk = assert(loadstring(source, '@TOGTools/ErrorInterpreter.lua'))
        setfenv(chunk, env)
        local namespace = {}
        chunk('TOGTools', namespace)
        return namespace.ErrorInterpreter
    end""")
    parser = load_parser(source.decode("utf-8"))
    observe = lua.eval("""function(parser, text)
        local budget = 100
        debug.sethook(function()
            budget = budget - 1
            if budget <= 0 then error('Instruction limit exceeded') end
        end, '', 10000)
        local ok, result, explanation, wants = pcall(function()
            local r = parser.Interpret(text)
            return r, parser.Explain(r, nil), parser.WantsAddonLoad(r, nil)
        end)
        debug.sethook()
        if not ok then error(result) end
        return result, explanation, wants
    end""")
    observations = []
    for case in inputs["cases"]:
        assert len(case["text"].encode("utf-8")) < 4096
        result, explanation, wants = observe(parser, case["text"])
        fields = {key: result[key] for key in (
            "message", "reason", "path", "file", "line", "folder", "library",
            "libraryAddon", "blizzard", "truncated", "taintedBy", "culprit", "culpritWhy"
        )}
        fields["ruleKey"] = result["rule"]["key"]
        fields["ruleTitle"] = result["rule"]["title"]
        fields["stack"] = [result["stack"][i] for i in range(1, len(result["stack"]) + 1)]
        observations.append({"inputId": case["id"], "interpret": fields,
                             "explainRaw": explanation, "wantsAddonLoad": wants})
    output = {
        "schemaVersion": 1,
        "observedAt": datetime.now(timezone.utc).isoformat(),
        "kind": "Offline parser observation; no WoW client, players or comparison scores",
        "packageUrl": "https://www.curseforge.com/wow/addons/togtools/files/9095461",
        "packageVersion": "TOGTools-v0.10.2", "packageSha256": ZIP_SHA256,
        "sourceMember": MEMBER, "sourceSha256": SOURCE_SHA256,
        "runtime": {"python": sys.version.split()[0], "lupa": lupa.__version__, "lua": "5.1"},
        "metadataLookup": None,
        "environment": "Allowlisted standard Lua functions; no WoW APIs; no client API mocks",
        "inputs": "data/togtools-parser-inputs-20261011.json",
        "license": "data/TOGTools-LICENSE.txt",
        "observations": observations,
    }
    with options.output.open("x", encoding="utf-8", newline="\n") as handle:
        json.dump(output, handle, ensure_ascii=False, indent=2)
        handle.write("\n")
    print(f"Recorded {len(observations)} offline observations in {options.output}")


if __name__ == "__main__":
    main()
