param(
  [string]$WorkspaceRoot = "$HOME\Documents\Work\CLIProxy"
)

$ErrorActionPreference = "Stop"

$appDir = Join-Path $WorkspaceRoot "CLIProxyApp"
$apiDir = Join-Path $WorkspaceRoot "CLIProxyApi"
$mgmtDir = Join-Path $WorkspaceRoot "CLIProxyManagement"

function Find-DevCmd {
  $candidates = @(
    "C:\BuildTools\Common7\Tools\LaunchDevCmd.bat",
    "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\VsDevCmd.bat",
    "C:\Program Files\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\VsDevCmd.bat"
  )

  foreach ($candidate in $candidates) {
    if (Test-Path $candidate) {
      return $candidate
    }
  }

  $vswhere = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"
  if (Test-Path $vswhere) {
    $installPath = & $vswhere -products * -requires Microsoft.VisualStudio.Workload.VCTools -property installationPath
    if ($installPath) {
      $candidate = Join-Path $installPath "Common7\Tools\VsDevCmd.bat"
      if (Test-Path $candidate) {
        return $candidate
      }
    }
  }

  throw "Visual Studio developer command prompt not found. Please install Visual Studio 2022 Build Tools with C++ workload."
}

function Add-PathIfExists {
  param([string]$PathToAdd)

  if ((Test-Path $PathToAdd) -and ($env:Path -notlike "*$PathToAdd*")) {
    $env:Path = "$PathToAdd;$env:Path"
  }
}

$devCmd = Find-DevCmd

if (!(Test-Path $appDir)) { throw "CLIProxyApp not found: $appDir" }
if (!(Test-Path $apiDir)) { throw "CLIProxyApi not found: $apiDir" }
if (!(Test-Path $mgmtDir)) { throw "CLIProxyManagement not found: $mgmtDir" }

Add-PathIfExists "$HOME\.cargo\bin"
Add-PathIfExists "C:\Program Files\Go\bin"
Add-PathIfExists "C:\Program Files\nodejs"
Add-PathIfExists "L:\Git\cmd"

Write-Host "WorkspaceRoot: $WorkspaceRoot"
Write-Host "DevCmd: $devCmd"

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

$cmdFile = Join-Path $env:TEMP "cliproxyapp-build.cmd"
Set-Content -Path $cmdFile -Value $cmd -Encoding ASCII
cmd /d /c $cmdFile
if ($LASTEXITCODE -ne 0) {
  throw "Windows build failed with exit code $LASTEXITCODE"
}

$bundleDir = Join-Path $appDir "src-tauri\target\release\bundle"
Write-Host ""
Write-Host "Build finished. Output directory:"
Write-Host $bundleDir
Pop-Location
