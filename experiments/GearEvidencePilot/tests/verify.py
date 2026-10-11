"""Run only the experimental pilot's Lua 5.1 checks, without touching WoW.

Usage: python experiments/GearEvidencePilot/tests/verify.py
Uses lua5.1/luac5.1 if present, otherwise the local .tools/python Lupa runtime.
No dependency is downloaded by this script.
"""
from pathlib import Path
import os
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[3]
PILOT = ROOT / "experiments" / "GearEvidencePilot"
os.chdir(ROOT)
sources = sorted(PILOT.rglob("*.lua"))
tests = sorted((PILOT / "tests").glob("test_*.lua"))
if not sources or not tests:
    raise SystemExit("Pilot source/tests have not been written yet.")

lua, luac = shutil.which("lua5.1"), shutil.which("luac5.1")
if lua and luac:
    for source in sources:
        subprocess.run([luac, "-p", str(source)], check=True)
    for test in tests:
        subprocess.run([lua, str(test)], check=True)
else:
    runtime = ROOT / ".tools" / "python"
    if runtime.is_dir():
        sys.path.insert(0, str(runtime))
    try:
        from lupa.lua51 import LuaRuntime
    except ImportError:
        raise SystemExit("Install Lua 5.1, or provide the existing local Lupa Lua 5.1 runtime.")
    check = LuaRuntime().eval("function(source, name) local f,e=loadstring(source,name); assert(f,e) end")
    for source in sources:
        check(source.read_text(encoding="utf-8"), str(source))
    for test in tests:
        LuaRuntime().execute(test.read_text(encoding="utf-8"))
print(f"Pilot Lua 5.1 syntax: {len(sources)} files; completed {len(tests)} test suites.")
