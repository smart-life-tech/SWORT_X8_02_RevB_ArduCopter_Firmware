param(
    [string]$RepoDir = "ardupilot"
)
$ErrorActionPreference = "Stop"
if (Test-Path $RepoDir) { throw "Refusing to overwrite existing path: $RepoDir" }
git clone https://github.com/ArduPilot/ardupilot.git $RepoDir
if ($LASTEXITCODE -ne 0) { throw "git clone failed" }
git -C $RepoDir checkout Copter-4.7.2
if ($LASTEXITCODE -ne 0) { throw "git checkout failed" }
$hash = (git -C $RepoDir rev-parse --short HEAD).Trim()
Write-Host "Checked out Copter-4.7.2 at $hash"
if ($hash -ne "fb77356") { Write-Warning "Expected release short hash fb77356; verify official tag before proceeding." }
