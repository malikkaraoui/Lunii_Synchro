# build-windows.ps1 — Compile LuniiSync.exe pour Windows (x86_64)
# Usage : powershell -ExecutionPolicy Bypass -File build-windows.ps1
$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $ScriptDir

$SPG_VERSION = "0.5.14"
$SPG_URL = "https://github.com/jersou/studio-pack-generator/releases/download/v$SPG_VERSION/studio-pack-generator-$SPG_VERSION-x86_64-windows.zip"

Write-Host ""
Write-Host "=== Lunii Sync — Build Windows ===" -ForegroundColor Cyan
Write-Host ""

# ── 1. FFmpeg ─────────────────────────────────────────────────────────────────
Write-Host "=== 1. FFmpeg ===" -ForegroundColor Cyan
if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id Gyan.FFmpeg -e --silent
    } elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        choco install ffmpeg -y
    } else {
        Write-Host "   ⚠️  Installez ffmpeg manuellement : https://ffmpeg.org/download.html"
    }
} else {
    Write-Host "   Déjà présent."
}

# ── 2. Python deps ────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "=== 2. Dépendances Python ===" -ForegroundColor Cyan
pip install --quiet --upgrade `
    pyinstaller `
    PySide6-Essentials `
    psutil `
    xxtea `
    requests `
    pycryptodome `
    Pillow `
    mutagen `
    ffmpeg-python `
    unidecode `
    py7zr

# ── 3. Lunii.QT ───────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "=== 3. Lunii.QT ===" -ForegroundColor Cyan
if (-not (Test-Path "Lunii.QT")) {
    git clone --quiet https://github.com/o-daneel/Lunii.QT.git
    Write-Host "   Cloné."
} else {
    Write-Host "   Déjà présent."
}

# ── 4. studio-pack-generator ──────────────────────────────────────────────────
Write-Host ""
Write-Host "=== 4. studio-pack-generator ===" -ForegroundColor Cyan
if (-not (Test-Path "studio-pack-generator.exe")) {
    Write-Host "   Téléchargement..."
    Invoke-WebRequest -Uri $SPG_URL -OutFile "spg.zip"
    Expand-Archive -Path spg.zip -DestinationPath spg-extracted -Force
    Move-Item "spg-extracted\Studio-Pack-Generator\studio-pack-generator-x86_64-windows.exe" "studio-pack-generator.exe"
    if (-not (Test-Path "tools")) {
        Move-Item "spg-extracted\Studio-Pack-Generator\tools" "tools"
    }
    Remove-Item spg.zip, spg-extracted -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "   Téléchargé."
} else {
    Write-Host "   Déjà présent."
}

# ── 5. Générer une icône .ico depuis l'icône Lunii.QT ────────────────────────
Write-Host ""
Write-Host "=== 5. Icône ===" -ForegroundColor Cyan
$IcoPath = "lunii-sync.ico"
if (-not (Test-Path $IcoPath)) {
    python -c @"
from PIL import Image
import io, struct

# Charge n'importe quel PNG disponible, sinon génère une icône simple
try:
    from PIL import Image, ImageDraw
    img = Image.new('RGBA', (256, 256), (20, 50, 120, 255))
    draw = ImageDraw.Draw(img)
    draw.ellipse([20,20,236,236], fill=(40,100,200,255))
    draw.text((128, 128), 'L', fill=(255,255,255,255), anchor='mm')
    sizes = [16, 32, 48, 64, 128, 256]
    images = [img.resize((s,s), Image.LANCZOS) for s in sizes]
    images[0].save('$IcoPath', format='ICO', sizes=[(s,s) for s in sizes],
                   append_images=images[1:])
    print('Icône créée.')
except Exception as e:
    print(f'Icône ignorée : {e}')
"@
} else {
    Write-Host "   Déjà présente."
}

# ── 6. Build PyInstaller ──────────────────────────────────────────────────────
Write-Host ""
Write-Host "=== 6. Build .exe ===" -ForegroundColor Cyan
Remove-Item -Recurse -Force build, dist -ErrorAction SilentlyContinue

# Patch temporaire du spec pour utiliser l'icône .ico sur Windows
$SpecContent = Get-Content lunii-app.spec -Raw
$SpecPatched = $SpecContent -replace "icon=.*?if _sys\.platform != 'win32' else None", "icon='$IcoPath'"
$SpecPatched | Set-Content lunii-app-win.spec -Encoding UTF8

pyinstaller lunii-app-win.spec --noconfirm
Remove-Item lunii-app-win.spec -ErrorAction SilentlyContinue

# ── 7. Vérification ───────────────────────────────────────────────────────────
Write-Host ""
if (Test-Path "dist\LuniiSync\LuniiSync.exe") {
    $Size = [math]::Round((Get-ChildItem -Recurse "dist\LuniiSync" | Measure-Object -Property Length -Sum).Sum / 1MB, 1)
    Write-Host "✅  dist\LuniiSync\LuniiSync.exe créé (${Size} MB)" -ForegroundColor Green
    Write-Host ""
    Write-Host "Pour distribuer : compressez le dossier dist\LuniiSync\ en ZIP."
    Write-Host "L'utilisateur extrait le ZIP et double-clique sur LuniiSync.exe."
} else {
    Write-Host "❌  Build échoué — consultez les logs ci-dessus." -ForegroundColor Red
    exit 1
}
