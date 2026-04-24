param(
  [string]$WorkspaceRoot = "L:\号池"
)

$ErrorActionPreference = "Stop"

$repos = @(
  @{ Name = "CLIProxyApi"; Url = "https://github.com/router-for-me/CLIProxyAPI.git" },
  @{ Name = "CLIProxyManagement"; Url = "https://github.com/router-for-me/Cli-Proxy-API-Management-Center.git" },
  @{ Name = "CLIProxyApp"; Url = "https://github.com/xieyuqiyu-source/CLIProxyApp.git" },
  @{ Name = "CLIProxyCloud"; Url = "https://github.com/xieyuqiyu-source/CLIProxyCloud.git" }
)

function Test-Command {
  param([string]$Name)
  return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

if (!(Test-Command "git")) {
  throw "git command not found. Please install Git for Windows first."
}

New-Item -ItemType Directory -Force -Path $WorkspaceRoot | Out-Null
Write-Host "WorkspaceRoot: $WorkspaceRoot"
Write-Host ""

foreach ($repo in $repos) {
  $target = Join-Path $WorkspaceRoot $repo.Name
  $gitDir = Join-Path $target ".git"

  Write-Host "=== $($repo.Name) ==="

  if (Test-Path $gitDir) {
    Write-Host "[update] $target"
    & git -C $target fetch --all --tags --prune
    if ($LASTEXITCODE -ne 0) { throw "git fetch failed: $($repo.Name)" }

    & git -C $target pull --ff-only
    if ($LASTEXITCODE -ne 0) { throw "git pull --ff-only failed: $($repo.Name)" }
  } elseif (Test-Path $target) {
    $items = Get-ChildItem -Force -Path $target -ErrorAction SilentlyContinue
    if ($items.Count -gt 0) {
      throw "Target exists but is not a git repository and is not empty: $target"
    }

    Write-Host "[clone] $($repo.Url)"
    & git clone $repo.Url $target
    if ($LASTEXITCODE -ne 0) { throw "git clone failed: $($repo.Name)" }
  } else {
    Write-Host "[clone] $($repo.Url)"
    & git clone $repo.Url $target
    if ($LASTEXITCODE -ne 0) { throw "git clone failed: $($repo.Name)" }
  }

  & git -C $target status --short --branch
  & git -C $target rev-parse --short HEAD
  Write-Host ""
}

Write-Host "Workspace sync completed."
