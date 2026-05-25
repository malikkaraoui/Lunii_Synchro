#!/usr/bin/env bash
# setup.sh — Installation de boite-push sur macOS / Linux
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

SPG_VERSION="0.5.14"
SPG_BASE="https://github.com/jersou/studio-pack-generator/releases/download/v${SPG_VERSION}"

# ── Détection plateforme ──────────────────────────────────────────────────────
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Darwin)
    case "$ARCH" in
      arm64)  SPG_BINARY="studio-pack-generator-v${SPG_VERSION}-aarch64-apple-darwin" ;;
      x86_64) SPG_BINARY="studio-pack-generator-v${SPG_VERSION}-x86_64-apple-darwin"  ;;
      *) echo "❌ Architecture macOS non supportée : $ARCH"; exit 1 ;;
    esac
    echo "=== macOS $ARCH détecté ==="
    echo ""
    echo "=== 1. Homebrew dependencies ==="
    command -v brew >/dev/null || { echo "❌ Homebrew requis : https://brew.sh"; exit 1; }
    brew install ffmpeg imagemagick 2>/dev/null || true
    ;;
  Linux)
    case "$ARCH" in
      x86_64)  SPG_BINARY="studio-pack-generator-v${SPG_VERSION}-x86_64-unknown-linux-musl"  ;;
      aarch64) SPG_BINARY="studio-pack-generator-v${SPG_VERSION}-aarch64-unknown-linux-musl" ;;
      *) echo "❌ Architecture Linux non supportée : $ARCH"; exit 1 ;;
    esac
    echo "=== Linux $ARCH détecté ==="
    echo ""
    echo "=== 1. Système dependencies ==="
    if command -v apt-get >/dev/null; then
      sudo apt-get install -y ffmpeg imagemagick python3-pip
    elif command -v dnf >/dev/null; then
      sudo dnf install -y ffmpeg imagemagick python3-pip
    elif command -v pacman >/dev/null; then
      sudo pacman -Sy --noconfirm ffmpeg imagemagick python-pip
    else
      echo "⚠️  Installez manuellement : ffmpeg, imagemagick"
    fi
    ;;
  *)
    echo "❌ OS non supporté par ce script. Utilisez setup.ps1 sous Windows."
    exit 1
    ;;
esac

echo ""
echo "=== 2. Python dependencies ==="
pip3 install PySide6 Pillow requests --quiet

echo ""
echo "=== 3. StoryBox.QT ==="
if [ ! -d "StoryBox.QT" ]; then
  git clone https://github.com/o-daneel/StoryBox.QT.git
else
  echo "   Déjà présent."
fi

echo ""
echo "=== 4. studio-pack-generator ==="
if [ ! -f "studio-pack-generator" ]; then
  echo "   Téléchargement : $SPG_BINARY"
  curl -L "$SPG_BASE/$SPG_BINARY" -o studio-pack-generator
  chmod +x studio-pack-generator
else
  echo "   Déjà présent."
fi

echo ""
echo "✅ Installation terminée."
echo ""
echo "Usage :"
echo "  python3 boite-push.py /chemin/vers/dossier/audio"
