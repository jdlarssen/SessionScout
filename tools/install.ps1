<#
.SYNOPSIS
Install this checkout's SessionScout files into one explicitly selected client.
.DESCRIPTION
Currently accepts only the observed Classic/Forever beta product wow_classic_beta,
client version 1.60.1, and Interface 16001. It does not certify in-game compatibility.
Requires matching executable, .flavor.info and parent .build.info evidence.
Only SessionScout is replaced. An existing installation is copied and hash-verified
under this workspace's backups directory before replacement, with rollback on error.
Use -WhatIf to validate and preview without writing. Does not launch or reload WoW.
.EXAMPLE
pwsh -File tools/install.ps1 -WoWPath 'C:\Program Files (x86)\World of Warcraft\_classic_beta_' -WhatIf
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $WoWPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-Within {
    param([string] $Path, [string] $Root)
    $absolute = [IO.Path]::GetFullPath($Path).TrimEnd([IO.Path]::DirectorySeparatorChar)
    $allowed = [IO.Path]::GetFullPath($Root).TrimEnd([IO.Path]::DirectorySeparatorChar)
    if (-not $absolute.StartsWith($allowed + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Path escapes the intended directory: $absolute"
    }
}

function Assert-NoReparsePath {
    param([string] $Path)
    $cursor = [IO.Path]::GetFullPath($Path)
    while ($cursor) {
        if (Test-Path -LiteralPath $cursor) {
            $item = Get-Item -Force -LiteralPath $cursor
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw "Symbolic links and junctions are unsupported: $cursor"
            }
        }
        $parent = [IO.Path]::GetDirectoryName($cursor)
        if ($parent -eq $cursor) { break }
        $cursor = $parent
    }
}

function Assert-RegularTree {
    param([string] $Path)
    Assert-NoReparsePath $Path
    if (Test-Path -LiteralPath $Path) {
        if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
            throw "Expected a directory: $Path"
        }
        foreach ($entry in Get-ChildItem -LiteralPath $Path -Recurse -Force) {
            if (($entry.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw "Symbolic links and junctions are unsupported: $($entry.FullName)"
            }
        }
    }
}

function Get-TreeManifest {
    param([string] $Path)
    Assert-RegularTree $Path
    $prefix = [IO.Path]::GetFullPath($Path).TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    @(Get-ChildItem -LiteralPath $Path -Recurse -Force | Sort-Object FullName | ForEach-Object {
        $relative = $_.FullName.Substring($prefix.Length)
        if ($_.PSIsContainer) { 'directory:' + $relative }
        else { 'file:' + $relative + ':' + (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash }
    })
}

function Assert-SameTree {
    param([string] $Source, [string] $Copy)
    $original = @(Get-TreeManifest $Source)
    $copied = @(Get-TreeManifest $Copy)
    if ($original.Count -ne $copied.Count -or ($original -join "`n") -cne ($copied -join "`n")) {
        throw "Copied directory failed file/hash verification: $Copy"
    }
}

function Remove-SessionScoutDirectory {
    param([string] $Path, [string] $AddOnsRoot)
    # Recheck absolute boundaries immediately before every recursive removal.
    Assert-Within $Path $AddOnsRoot
    if ([IO.Path]::GetFileName($Path) -cne 'SessionScout') {
        throw "Refusing to remove an addon other than SessionScout: $Path"
    }
    Assert-RegularTree $Path
    if (Test-Path -LiteralPath $Path) {
        Remove-Item -LiteralPath $Path -Recurse -Force
    }
}

$workspace = [IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
$client = [IO.Path]::GetFullPath($WoWPath)
Assert-NoReparsePath $workspace
Assert-NoReparsePath $client
if (-not (Test-Path -LiteralPath $client -PathType Container)) {
    throw 'WoWPath must name the existing client folder that directly contains WowB.exe.'
}
$executable = Join-Path $client 'WowB.exe'
if (-not (Test-Path -LiteralPath $executable -PathType Leaf)) {
    throw 'This installer requires the observed Classic beta client executable WowB.exe.'
}
Assert-NoReparsePath $executable
$clientVersion = (Get-Item -LiteralPath $executable).VersionInfo.FileVersion
if ($clientVersion -notmatch '^1\.60\.1\.\d+$') {
    throw "Unsupported client version: $clientVersion. Expected the 1.60.1 Forever development target."
}
$flavorFile = Join-Path $client '.flavor.info'
Assert-NoReparsePath $flavorFile
$flavorLines = @(Get-Content -LiteralPath $flavorFile | Where-Object { $_.Trim() })
if ($flavorLines.Count -ne 2 -or $flavorLines[0].Trim() -ne 'Product Flavor!STRING:0' -or $flavorLines[1].Trim() -ne 'wow_classic_beta') {
    throw 'The client .flavor.info must identify the observed wow_classic_beta product.'
}
$buildInfo = Join-Path (Split-Path -Parent $client) '.build.info'
Assert-NoReparsePath $buildInfo
$buildLines = @(Get-Content -LiteralPath $buildInfo | Where-Object { $_.Trim() })
if ($buildLines.Count -lt 2) { throw 'The parent .build.info is missing a client record.' }
$headers = @($buildLines[0] -split '\|' | ForEach-Object { ($_ -split '!', 2)[0] })
$versionIndex = [Array]::IndexOf($headers, 'Version')
$productIndex = [Array]::IndexOf($headers, 'Product')
$activeIndex = [Array]::IndexOf($headers, 'Active')
if ($versionIndex -lt 0 -or $productIndex -lt 0 -or $activeIndex -lt 0) { throw 'Unsupported .build.info columns.' }
$matchingBuilds = @($buildLines | Select-Object -Skip 1 | Where-Object {
    $fields = $_ -split '\|'
    $fields.Count -eq $headers.Count -and $fields[$productIndex] -eq 'wow_classic_beta' -and
        $fields[$activeIndex] -eq '1' -and $fields[$versionIndex] -eq $clientVersion
})
if ($matchingBuilds.Count -ne 1) { throw 'The executable, flavor and one active .build.info row must agree.' }

$source = Join-Path $workspace 'SessionScout'
Assert-RegularTree $source
$toc = Join-Path $source 'SessionScout.toc'
$tocLines = @(Get-Content -LiteralPath $toc)
if (@($tocLines | Where-Object { $_ -match '^##\s*Interface\s*:' }).Count -ne 1 -or
    @($tocLines | Where-Object { $_ -match '^##\s*Interface\s*:\s*16001\s*$' }).Count -ne 1) {
    throw 'The source TOC must target only Interface 16001.'
}
$versionLines = @($tocLines | Where-Object { $_ -match '^##\s*Version\s*:' })
if ($versionLines.Count -ne 1 -or $versionLines[0] -notmatch '^##\s*Version\s*:\s*(\d+\.\d+\.\d+(?:-[A-Za-z0-9.-]+)?)\s*$') {
    throw 'The source TOC must have one concrete semantic version.'
}
$addonVersion = $Matches[1]
$files = [Collections.Generic.List[object]]::new()
$files.Add([PSCustomObject]@{ Source = $toc; Relative = 'SessionScout.toc' })
$names = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
[void] $names.Add('SessionScout.toc')
foreach ($line in $tocLines) {
    $relative = $line.Trim().Replace('\', '/')
    if (-not $relative -or $relative.StartsWith('#')) { continue }
    if ($relative -notmatch '^[A-Za-z0-9_./-]+\.lua$' -or @($relative -split '/' | Where-Object { $_ -in @('', '.', '..') }).Count) {
        throw "Unsupported TOC file reference: $relative"
    }
    if (-not $names.Add($relative)) { throw "Duplicate TOC file reference: $relative" }
    $file = [IO.Path]::GetFullPath((Join-Path $source $relative))
    Assert-Within $file $source
    Assert-NoReparsePath $file
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { throw "Missing TOC file: $relative" }
    $files.Add([PSCustomObject]@{ Source = $file; Relative = $relative })
}
if ($files.Count -lt 2) { throw 'The source TOC contains no Lua files.' }
$license = Join-Path $workspace 'LICENSE'
if (Test-Path -LiteralPath $license) {
    Assert-NoReparsePath $license
    if (-not (Test-Path -LiteralPath $license -PathType Leaf)) { throw 'LICENSE must be a regular file.' }
    $files.Add([PSCustomObject]@{ Source = $license; Relative = 'LICENSE' })
}

$addons = Join-Path $client 'Interface\AddOns'
$destination = Join-Path $addons 'SessionScout'
Assert-Within $destination $addons
Assert-RegularTree $destination
$backupRoot = Join-Path $workspace 'backups'
$runName = [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffffffZ') + '-' + [Guid]::NewGuid().ToString('N')
$runDirectory = Join-Path $backupRoot $runName
$staging = Join-Path $runDirectory 'staged\SessionScout'
$previous = Join-Path $runDirectory 'previous\SessionScout'
Assert-Within $runDirectory $backupRoot
Assert-Within $staging $runDirectory
Assert-Within $previous $runDirectory
Assert-NoReparsePath $runDirectory

if (-not $PSCmdlet.ShouldProcess($destination, "Install SessionScout $addonVersion for Classic beta $clientVersion; preserve existing files under $runDirectory")) {
    return
}

New-Item -ItemType Directory -Path $staging | Out-Null
foreach ($file in $files) {
    $stagedFile = [IO.Path]::GetFullPath((Join-Path $staging $file.Relative))
    Assert-Within $stagedFile $staging
    New-Item -ItemType Directory -Path (Split-Path -Parent $stagedFile) -Force | Out-Null
    $before = (Get-FileHash -LiteralPath $file.Source -Algorithm SHA256).Hash
    Copy-Item -LiteralPath $file.Source -Destination $stagedFile
    if ((Get-FileHash -LiteralPath $stagedFile -Algorithm SHA256).Hash -ne $before -or
        (Get-FileHash -LiteralPath $file.Source -Algorithm SHA256).Hash -ne $before) {
        throw "Source changed or staging verification failed: $($file.Relative)"
    }
}
$hadExisting = Test-Path -LiteralPath $destination -PathType Container
if ($hadExisting) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $previous) | Out-Null
    Copy-Item -LiteralPath $destination -Destination $previous -Recurse
    Assert-SameTree $destination $previous
}
try {
    Remove-SessionScoutDirectory $destination $addons
    Assert-NoReparsePath $addons
    New-Item -ItemType Directory -Path $addons -Force | Out-Null
    Copy-Item -LiteralPath $staging -Destination $destination -Recurse
    Assert-SameTree $staging $destination
} catch {
    $installationError = $_.Exception.Message
    try {
        Remove-SessionScoutDirectory $destination $addons
        if ($hadExisting) {
            Copy-Item -LiteralPath $previous -Destination $destination -Recurse
            Assert-SameTree $previous $destination
        }
    } catch {
        throw "Installation failed: $installationError. Rollback also failed: $($_.Exception.Message). Preserved backup: $previous"
    }
    throw "Installation failed and the previous state was restored: $installationError"
}
$record = [ordered]@{
    installedAt = [DateTime]::UtcNow.ToString('o')
    addonVersion = $addonVersion
    interface = 16001
    flavor = 'forever'
    clientProduct = 'wow_classic_beta'
    clientVersion = $clientVersion
    destination = $destination
    previousInstallation = $(if ($hadExisting) { $previous } else { $null })
    files = @(Get-TreeManifest $destination)
}
$record | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $runDirectory 'installation.json') -Encoding utf8
Write-Output "Installed SessionScout $addonVersion into $destination"
Write-Output "Installation record and preserved files: $runDirectory"
