# setup.ps1 — Installation de boite-push sur Windows
# Exécuter avec : powershell -ExecutionPolicy Bypass -File setup.ps1

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $ScriptDir

$SPG_VERSION = "0.5.14"
$SPG_URL = "https://github.com/jersou/studio-pack-generator/releases/download/v$SPG_VERSION/studio-pack-generator-v$SPG_VERSION-x86_64-pc-windows-msvc.exe"

Write-Host "=== Windows x86_64 ===" -ForegroundColor Cyan

# ── 1. Winget/Chocolatey pour ffmpeg ─────────────────────────────────────────
Write-Host ""
Write-Host "=== 1. FFmpeg ===" -ForegroundColor Cyan
if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id Gyan.FFmpeg -e --silent
    } elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        choco install ffmpeg -y
    } else {
        Write-Host "⚠️  Installez ffmpeg manuellement : https://ffmpeg.org/download.html"
    }
} else {
    Write-Host "   Déjà présent."
}

# ── 2. Python dependencies ────────────────────────────────────────────────────
Write-Host ""
Write-Host "=== 2. Python dependencies ===" -ForegroundColor Cyan
pip install PySide6 Pillow requests

# ── 3. StoryBox.QT ───────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "=== 3. StoryBox.QT ===" -ForegroundColor Cyan
if (-not (Test-Path "StoryBox.QT")) {
    git clone https://github.com/o-daneel/StoryBox.QT.git
} else {
    Write-Host "   Déjà présent."
}

# ── 4. studio-pack-generator ──────────────────────────────────────────────────
Write-Host ""
Write-Host "=== 4. studio-pack-generator ===" -ForegroundColor Cyan
if (-not (Test-Path "studio-pack-generator.exe")) {
    Write-Host "   Téléchargement..."
    Invoke-WebRequest -Uri $SPG_URL -OutFile "studio-pack-generator.exe"
} else {
    Write-Host "   Déjà présent."
}

Write-Host ""
Write-Host "✅ Installation terminée." -ForegroundColor Green
Write-Host ""
Write-Host "Usage :"
Write-Host "  python boite-push.py C:\chemin\vers\dossier\audio"
