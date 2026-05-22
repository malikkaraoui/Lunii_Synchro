#!/usr/bin/env bash
# build-macos.sh — V2 : compile LuniiSync.app via Tauri (Rust + frontend statique)
# Usage : ./build-macos.sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo ""
echo "=== LuniiSync V2 — Build macOS ==="
echo ""

# ── 1. Outils système ─────────────────────────────────────────────────────────
echo "=== 1. Outils système ==="
command -v brew    >/dev/null || { echo "❌ Homebrew requis : https://brew.sh"; exit 1; }
command -v rustup  >/dev/null || { echo "⬇  Installation de Rust…"; curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; source "$HOME/.cargo/env"; }
command -v cargo   >/dev/null || { source "$HOME/.cargo/env"; }
brew install ffmpeg 2>/dev/null || true

# ── 2. Tauri CLI ──────────────────────────────────────────────────────────────
echo ""
echo "=== 2. Tauri CLI ==="
if ! cargo tauri --version >/dev/null 2>&1; then
    echo "   Installation de tauri-cli…"
    cargo install tauri-cli --version "^2" --locked
fi
echo "   $(cargo tauri --version)"

# ── 3. Dépendances Python (sidecar) ──────────────────────────────────────────
echo ""
echo "=== 3. Dépendances Python (lunii-bridge) ==="
pip3 install --quiet --upgrade \
    PySide6-Essentials \
    xxtea \
    pycryptodome \
    requests \
    Pillow \
    mutagen \
    ffmpeg-python \
    unidecode \
    py7zr

# ── 4. Lunii.QT ───────────────────────────────────────────────────────────────
echo ""
echo "=== 4. Lunii.QT ==="
if [ ! -d "Lunii.QT" ]; then
    git clone --quiet https://github.com/o-daneel/Lunii.QT.git
    echo "   Cloné."
else
    echo "   Déjà présent."
fi

# ── 5. Build Tauri ────────────────────────────────────────────────────────────
echo ""
echo "=== 5. Build Tauri (.app) ==="
cargo tauri build

# ── 6. Vérification ───────────────────────────────────────────────────────────
echo ""
APP_PATH="src-tauri/target/release/bundle/macos/LuniiSync.app"
if [ -d "$APP_PATH" ]; then
    APP_SIZE=$(du -sh "$APP_PATH" | cut -f1)
    echo "✅  $APP_PATH créé ($APP_SIZE)"
    echo ""
    echo "Pour tester :"
    echo "   open $APP_PATH"
    echo ""
    echo "Pour distribuer, copier lunii-bridge.py à côté du .app :"
    echo "   cp lunii-bridge.py dist/"
else
    echo "❌  Build Tauri échoué — consultez les logs ci-dessus."
    exit 1
fi
