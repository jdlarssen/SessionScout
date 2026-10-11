# Local build and install tools

`python tools/build.py --flavor forever` creates
`dist/SessionScout-<version>-forever.zip` and its SHA256 file. Forever is the only
configured flavor and the default. Its TOC must specify Interface `16001` alone;
the build does not modify the TOC or claim support for another client. The flavor
suffix keeps this artifact distinct from earlier Retail development packages.

The PowerShell installer requires an explicit client directory:

```powershell
pwsh -File tools/install.ps1 -WoWPath 'C:\Program Files (x86)\World of Warcraft\_classic_beta_' -WhatIf
pwsh -File tools/install.ps1 -WoWPath 'C:\Program Files (x86)\World of Warcraft\_classic_beta_'
```

`-WhatIf` validates local evidence and previews the destination without writing.
Remove it only when installation is intended. The currently observed target is
the `wow_classic_beta` product with `WowB.exe` version `1.60.1`. Executable version,
`.flavor.info` and one active parent `.build.info` row must agree. Other products
and versions are refused rather than being treated as compatible automatically.

Only TOC-listed Lua, the TOC and the optional license are installed. The installer
rejects junctions and symbolic links. Before replacing an existing `SessionScout`
directory, it copies and hash-checks the whole directory under the workspace's
`backups/<UTC timestamp>-<unique id>/previous/SessionScout`. The staged files and
installation record remain alongside that backup. Replacement failure triggers
restoration; the preserved backup is retained even if restoration fails. Other
addons and SavedVariables are not targeted. The script does not start or reload
the game.

Python tests exercise release allowlisting, reproducibility, exact flavor/TOC
matching and refusal of unconfigured flavors. On 11 October 2026 the installer
passed `-WhatIf`, then installed the alpha into the verified local Forever
1.60.1.70338 client and checked file hashes. Existing-installation rollback has
not been exercised against the game folder. Installation does not establish
in-game compatibility; game execution remains pending.
