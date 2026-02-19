Write-Host "Starting Workstation Setup..." -ForegroundColor Cyan

# ---------------------------
# Resolve script paths (so it works no matter where you run it from)
# ---------------------------
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot  = Resolve-Path (Join-Path $ScriptDir "..")

# ---------------------------
# Verify VS Code CLI
# ---------------------------
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "VS Code CLI (code) not found in PATH." -ForegroundColor Red
    Write-Host "In VS Code: Ctrl+Shift+P -> 'Shell Command: Install ''code'' command in PATH'." -ForegroundColor Yellow
    exit 1
}

# ---------------------------
# Install VS Code Extensions
# ---------------------------
Write-Host "Installing VS Code extensions..." -ForegroundColor Cyan

$ExtensionsFile = Join-Path $ScriptDir "extensions.txt"

if (Test-Path $ExtensionsFile) {
    Get-Content $ExtensionsFile | Where-Object { $_ -and $_.Trim() -ne "" -and -not $_.Trim().StartsWith("#") } | ForEach-Object {
        $ext = $_.Trim()
        Write-Host "Installing $ext"
        code --install-extension $ext --force | Out-Null
    }
    Write-Host "VS Code extensions complete." -ForegroundColor Green
}
else {
    Write-Host "extensions.txt not found at: $ExtensionsFile" -ForegroundColor Yellow
}

# ---------------------------
# Apply VS Code Global Settings
# ---------------------------
Write-Host "Applying VS Code settings..." -ForegroundColor Cyan

$SourceSettings = Join-Path $RepoRoot "config\vscode\settings.json"
$TargetSettings = Join-Path $env:APPDATA "Code\User\settings.json"

if (Test-Path $SourceSettings) {
    $TargetDir = Split-Path -Parent $TargetSettings
    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir | Out-Null
    }

    Copy-Item $SourceSettings $TargetSettings -Force
    Write-Host "VS Code settings applied to: $TargetSettings" -ForegroundColor Green
}
else {
    Write-Host "VS Code settings file not found in repo at: $SourceSettings" -ForegroundColor Yellow
}

# ---------------------------
# Configure Git (Global)
# ---------------------------
Write-Host "Configuring Git..." -ForegroundColor Cyan

git config --global user.name "Jesse Brandon"
git config --global user.email "jessebrandon052@gmail.com"
git config --global core.editor "code --wait"
git config --global core.autocrlf true
git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global push.default simple
git config --global credential.helper manager

Write-Host "Git configuration complete." -ForegroundColor Green

# ---------------------------
# Install Python Tooling
# ---------------------------
Write-Host "Installing global Python tools..." -ForegroundColor Cyan

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "python not found in PATH. Skipping Python tooling install." -ForegroundColor Yellow
}
else {
    python -m pip install --upgrade pip
    python -m pip install black flake8 isort pre-commit
    Write-Host "Python tooling install complete." -ForegroundColor Green
}

Write-Host "Workstation setup complete." -ForegroundColor Green
