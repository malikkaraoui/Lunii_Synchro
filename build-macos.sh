#!/usr/bin/env bash
# build-macos.sh — Compile LuniiSync.app pour macOS (ARM + Intel)
# Usage : ./build-macos.sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

SPG_VERSION="0.5.14"
ARCH="$(uname -m)"

echo ""
echo "=== Lunii Sync — Build macOS ($ARCH) ==="
echo ""

# ── 1. Homebrew deps ──────────────────────────────────────────────────────────
echo "=== 1. Dépendances système ==="
command -v brew >/dev/null || { echo "❌ Homebrew requis : https://brew.sh"; exit 1; }
brew install ffmpeg 2>/dev/null || true

# ── 2. Python deps ────────────────────────────────────────────────────────────
echo ""
echo "=== 2. Dépendances Python ==="
pip3 install --quiet --upgrade \
    pyinstaller \
    PySide6-Essentials \
    psutil \
    xxtea \
    requests \
    pycryptodome \
    Pillow \
    mutagen \
    ffmpeg-python \
    unidecode \
    py7zr

# ── 3. Lunii.QT ───────────────────────────────────────────────────────────────
echo ""
echo "=== 3. Lunii.QT ==="
if [ ! -d "Lunii.QT" ]; then
    git clone --quiet https://github.com/o-daneel/Lunii.QT.git
    echo "   Cloné."
else
    echo "   Déjà présent."
fi

# ── 4. studio-pack-generator ──────────────────────────────────────────────────
echo ""
echo "=== 4. studio-pack-generator ==="
if [ ! -f "studio-pack-generator" ]; then
    case "$ARCH" in
        arm64)  BINARY="studio-pack-generator-v${SPG_VERSION}-aarch64-apple-darwin" ;;
        x86_64) BINARY="studio-pack-generator-v${SPG_VERSION}-x86_64-apple-darwin"  ;;
        *) echo "❌ Architecture non supportée : $ARCH"; exit 1 ;;
    esac
    echo "   Téléchargement de $BINARY…"
    curl -fsSL \
        "https://github.com/jersou/studio-pack-generator/releases/download/v${SPG_VERSION}/${BINARY}" \
        -o studio-pack-generator
    chmod +x studio-pack-generator
    echo "   Téléchargé."
else
    echo "   Déjà présent."
fi

# ── 5. Build PyInstaller ──────────────────────────────────────────────────────
echo ""
echo "=== 5. Build .app ==="
rm -rf build dist

pyinstaller lunii-app.spec --noconfirm

# ── 6. Vérification ───────────────────────────────────────────────────────────
echo ""
if [ -d "dist/LuniiSync.app" ]; then
    APP_SIZE=$(du -sh "dist/LuniiSync.app" | cut -f1)
    echo "✅  dist/LuniiSync.app créé ($APP_SIZE)"
    echo ""
    echo "Pour tester :"
    echo "   open dist/LuniiSync.app"
    echo ""
    echo "Pour installer dans Applications :"
    echo "   cp -r dist/LuniiSync.app /Applications/"
else
    echo "❌  Build échoué — consultez les logs ci-dessus."
    exit 1
fi
