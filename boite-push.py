#!/usr/bin/env python3
"""
boite-push.py — Synchronise un dossier audio avec la boîte à histoires
Usage : python boite-push.py /chemin/vers/dossier/audio
- Nouveaux fichiers → importés
- Fichiers supprimés → retirés de la boîte à histoires
- Fichiers déjà présents → ignorés
"""

import sys
import os
import shutil
import subprocess
import tempfile
import json
import zipfile
import hashlib
import io
from pathlib import Path

import platform

SCRIPT_DIR = Path(__file__).parent
STORYBOX_QT_PATH = SCRIPT_DIR / "StoryBox.QT"
_spg_name = "studio-pack-generator.exe" if platform.system() == "Windows" else "studio-pack-generator"
SPG_BINARY = SCRIPT_DIR / _spg_name
MANIFESTS_DIR = SCRIPT_DIR / "manifests"

sys.path.insert(0, str(STORYBOX_QT_PATH))

# QCoreApplication doit être créée AVANT tout import de modules Qt
from PySide6.QtCore import QCoreApplication
_app = QCoreApplication(sys.argv)

import logging
from pkg.api.device_storybox import StoryBoxDevice, STORYBOX_LOGGER

logging.basicConfig(level=logging.WARNING, format="[%(levelname)s] %(message)s")


def manifest_path(device_snu: str) -> Path:
    MANIFESTS_DIR.mkdir(exist_ok=True)
    return MANIFESTS_DIR / f"{device_snu}.json"


def load_manifest(device_snu: str) -> dict:
    p = manifest_path(device_snu)
    if p.exists():
        return json.loads(p.read_text())
    # Migration depuis l'ancien fichier non nommé par SNU
    legacy = SCRIPT_DIR / "storybox-manifest.json"
    if legacy.exists():
        data = json.loads(legacy.read_text())
        p.write_text(json.dumps(data, indent=2))
        legacy.unlink()
        print(f"   Manifest migré → manifests/{device_snu}.json")
        return data
    return {}


def save_manifest(device_snu: str, manifest: dict):
    manifest_path(device_snu).write_text(json.dumps(manifest, indent=2))


def find_storybox():
    system = platform.system()
    if system == "Darwin":
        candidates = Path("/Volumes").iterdir()
    elif system == "Linux":
        import getpass
        roots = [Path("/media") / getpass.getuser(), Path("/media"), Path("/mnt")]
        candidates = (p for root in roots if root.exists() for p in root.iterdir())
    elif system == "Windows":
        import string
        candidates = (Path(f"{d}:\\") for d in string.ascii_uppercase
                      if Path(f"{d}:\\").exists())
    else:
        return None
    for vol in candidates:
        if (vol / ".md").exists():
            return str(vol)
    return None


def generate_story_zip(audio_file: Path, output_dir: Path) -> str:
    """Génère un ZIP STUdio pour un seul fichier audio via studio-pack-generator."""
    # Dossier source : nom = titre de l'histoire, contient uniquement ce fichier
    story_dir = output_dir / audio_file.stem[:50]
    story_dir.mkdir()
    shutil.copy2(audio_file, story_dir / audio_file.name)

    env = os.environ.copy()
    env["PATH"] = "/opt/homebrew/bin:" + env.get("PATH", "")

    result = subprocess.run(
        [
            str(SPG_BINARY),
            "--skip-extract-image-from-mp-3",
            "--output-folder", str(output_dir),
            str(story_dir),
        ],
        env=env,
        capture_output=True,
    )

    if result.returncode != 0:
        raise RuntimeError(
            f"studio-pack-generator a échoué pour {audio_file.name} "
            f"(code {result.returncode})"
        )

    zips = sorted(output_dir.glob("*.zip"))
    if not zips:
        raise RuntimeError(f"Aucun ZIP généré pour {audio_file.name}")

    zip_path = str(zips[-1])
    _inject_cover_image(zip_path, audio_file.stem)
    _patch_direct_play(zip_path)
    return zip_path


def _patch_direct_play(zip_path):
    """Supprime le nœud titre TTS : le podcast joue directement à la sélection."""
    with zipfile.ZipFile(zip_path) as z:
        story_json = json.loads(z.read("story.json"))
        files = {name: z.read(name) for name in z.namelist()}

    nodes = story_json.get("stageNodes", [])
    square_one = next((n for n in nodes if n.get("squareOne")), None)
    podcast_node = next((n for n in nodes if not n.get("squareOne")), None)

    if not square_one or not podcast_node:
        return

    square_one["audio"] = podcast_node.get("audio", "")
    square_one["controlSettings"] = {
        "autoplay": False,
        "home": True,
        "ok": False,
        "pause": True,
        "wheel": False,
    }
    square_one["okTransition"] = None
    square_one["homeTransition"] = None

    story_json["stageNodes"] = [square_one]
    story_json["actionNodes"] = []
    story_json["listNodes"] = []

    files["story.json"] = json.dumps(story_json).encode()

    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as z:
        for name, data in files.items():
            z.writestr(name, data)


def _inject_cover_image(zip_path, title):
    """Ajoute une image de couverture dans le ZIP STUdio si elle est absente.
    Sans image, ri_data est vide → bt vide → histoire invisible sur la boîte à histoires."""
    from PIL import Image, ImageDraw

    with zipfile.ZipFile(zip_path) as z:
        names = z.namelist()
        story_json = json.loads(z.read("story.json"))
        has_images = any(snode.get("image") for snode in story_json.get("stageNodes", []))
        if has_images:
            return
        files = {name: z.read(name) for name in names}

    img = Image.new("RGB", (320, 240), color=(20, 50, 120))
    draw = ImageDraw.Draw(img)
    label = title[:28]
    draw.text((160, 120), label, fill=(255, 255, 255), anchor="mm")

    buf = io.BytesIO()
    img.save(buf, format="PNG")
    cover_bytes = buf.getvalue()
    cover_name = hashlib.sha1(cover_bytes).hexdigest() + ".png"

    for snode in story_json.get("stageNodes", []):
        snode["image"] = cover_name

    files["story.json"] = json.dumps(story_json).encode()
    files[f"assets/{cover_name}"] = cover_bytes

    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as z:
        for name, data in files.items():
            z.writestr(name, data)


def main():
    if len(sys.argv) < 2:
        print("Usage : python boite-push.py /chemin/vers/dossier/audio")
        print("Exemple : python boite-push.py /Users/malik/Downloads/Audio")
        sys.exit(1)

    audio_dir = Path(sys.argv[1])
    if not audio_dir.exists() or not audio_dir.is_dir():
        print(f"❌ Dossier introuvable : {audio_dir}")
        sys.exit(1)

    audio_files = sorted(
        f for f in audio_dir.iterdir()
        if f.suffix.lower() in (".m4a", ".mp3", ".wav", ".ogg", ".flac")
    )
    if not audio_files:
        print(f"❌ Aucun fichier audio trouvé dans : {audio_dir}")
        sys.exit(1)

    # ── 1. Détecter la boîte à histoires ──────────────────────────────────────────────
    print("🔍 Détection de la boîte à histoires USB...")
    storybox_path = find_storybox()
    if not storybox_path:
        print("❌ boîte à histoires non trouvée. Branchez-la en USB puis réessayez.")
        sys.exit(1)
    print(f"✅ boîte à histoires détectée : {storybox_path}")

    # ── 2. Charger le device boîte à histoires ────────────────────────────────────────
    device = StoryBoxDevice(storybox_path)
    if device.device_version == 0:
        print("❌ Impossible de lire les infos du device. Vérifiez la connexion USB.")
        sys.exit(1)
    device_snu = device.snu_str
    print(f"   Firmware : {device.fw_vers_major}.{device.fw_vers_minor} | SNU : {device_snu}")

    # ── 3. Synchroniser ───────────────────────────────────────────────────
    manifest = load_manifest(device_snu)
    current_names = {f.name for f in audio_files}

    # Supprimer les histoires dont le fichier a disparu
    removed = 0
    for filename, short_uuid in list(manifest.items()):
        if filename not in current_names:
            story = next((s for s in device.stories if s.short_uuid == short_uuid), None)
            if story:
                story_dir = Path(storybox_path) / ".content" / short_uuid
                if story_dir.exists():
                    shutil.rmtree(story_dir)
                device.stories.remove(story)
                print(f"🗑  Retiré : {filename}")
            del manifest[filename]
            removed += 1

    # Importer les nouveaux fichiers
    to_import = [f for f in audio_files if f.name not in manifest]
    already = len(audio_files) - len(to_import)

    if already:
        print(f"⏭  {already} fichier(s) déjà présent(s), ignoré(s).")
    if to_import:
        print(f"\n📦 {len(to_import)} nouveau(x) fichier(s) à importer...\n")

    imported = 0
    errors = []

    for i, audio_file in enumerate(to_import, 1):
        print(f"[{i}/{len(to_import)}] {audio_file.name}")
        with tempfile.TemporaryDirectory() as tmp:
            try:
                print(f"  → Génération du pack...")
                zip_path = generate_story_zip(audio_file, Path(tmp))
                print(f"  → Import sur la boîte à histoires...")
                result = device.import_story(zip_path)
                if result is False:
                    raise RuntimeError("import_story a retourné False (espace insuffisant ?)")
                # Récupérer le short_uuid de la nouvelle histoire
                new_story = device.stories[-1]
                manifest[audio_file.name] = new_story.short_uuid
                imported += 1
                print(f"  ✅ Importé ({new_story.short_uuid})\n")
            except Exception as e:
                errors.append((audio_file.name, str(e)))
                print(f"  ❌ Échec : {e}\n")

    device.update_pack_index()
    save_manifest(device_snu, manifest)

    total = imported + already
    print(f"🎉 boîte à histoires synchronisée : {total} histoire(s) active(s)"
          f"{f', {removed} retirée(s)' if removed else ''}"
          f"{f', {imported} ajoutée(s)' if imported else ''}.")
    if errors:
        print("\n⚠️  Erreurs :")
        for name, err in errors:
            print(f"   {name} : {err}")


if __name__ == "__main__":
    main()
