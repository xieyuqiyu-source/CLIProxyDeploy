param(
  [string]$WorkspaceRoot = "$HOME\Documents\Work\CLIProxy"
)

$ErrorActionPreference = "Stop"

$appDir = Join-Path $WorkspaceRoot "CLIProxyApp"
$apiDir = Join-Path $WorkspaceRoot "CLIProxyApi"
$mgmtDir = Join-Path $WorkspaceRoot "CLIProxyManagement"
$devCmd = "C:\BuildTools\Common7\Tools\LaunchDevCmd.bat"

if (!(Test-Path $appDir)) { throw "CLIProxyApp not found: $appDir" }
if (!(Test-Path $apiDir)) { throw "CLIProxyApi not found: $apiDir" }
if (!(Test-Path $mgmtDir)) { throw "CLIProxyManagement not found: $mgmtDir" }
if (!(Test-Path $devCmd)) { throw "LaunchDevCmd.bat not found: $devCmd" }

Write-Host "WorkspaceRoot: $WorkspaceRoot"

Push-Location $mgmtDir
npm install
Pop-Location

Push-Location $appDir
npm install

$cmd = @"
call "$devCmd" -arch=x64
cd /d "$appDir"
npm run tauri build
"@

cmd /c $cmd

$bundleDir = Join-Path $appDir "src-tauri\target\release\bundle"
Write-Host ""
Write-Host "Build finished. Output directory:"
Write-Host $bundleDir
Pop-Location

