# -*- mode: python ; coding: utf-8 -*-
"""
PyInstaller spec pour LuniiSync.app (macOS)
Généré par build-macos.sh — ne pas modifier à la main.
"""

from pathlib import Path
import platform

import sys as _sys
ROOT = Path(SPECPATH)
LUNII_QT = ROOT / "Lunii.QT"
SPG_NAME = "studio-pack-generator.exe" if _sys.platform == "win32" else "studio-pack-generator"

block_cipher = None

_datas = [
    (str(LUNII_QT / "pkg"),     "Lunii.QT/pkg"),
    (str(LUNII_QT / "locales"), "Lunii.QT/locales"),
    (str(LUNII_QT / "res"),     "Lunii.QT/res"),
]
if _sys.platform == "win32" and (ROOT / "tools").exists():
    _datas.append((str(ROOT / "tools"), "tools"))

a = Analysis(
    [str(ROOT / "lunii-app.py")],
    pathex=[str(ROOT), str(LUNII_QT)],
    binaries=[
        (str(ROOT / SPG_NAME), "."),
    ],
    datas=_datas,
    hiddenimports=[
        # Lunii.QT
        "pkg.api.device_lunii",
        "pkg.api.device_flam",
        "pkg.api.devices",
        "pkg.api.stories",
        "pkg.api.constants",
        "pkg.api.convert_image",
        "pkg.api.convert_audio",
        "pkg.api.aes_keys",
        "pkg.api.firmware",
        # Chiffrement
        "xxtea",
        "Crypto",
        "Crypto.Cipher",
        "Crypto.Cipher.AES",
        # Autres
        "psutil",
        "requests",
        "mutagen",
        "mutagen.mp3",
        "mutagen.id3",
        "ffmpeg",
        "py7zr",
        "unidecode",
        "PIL",
        "PIL.Image",
        "PIL.ImageDraw",
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=["tkinter", "unittest", "xmlrpc", "pydoc"],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name="LuniiSync",
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    # Icône Windows
    icon=str(LUNII_QT / "res" / "dmg_icon.icns") if _sys.platform != "win32" else None,
)

coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=False,
    upx_exclude=[],
    name="LuniiSync",
)

app = BUNDLE(
    coll,
    name="LuniiSync.app",
    icon=str(LUNII_QT / "res" / "dmg_icon.icns"),
    bundle_identifier="com.malik.luniisync",
    version="1.0.0",
    info_plist={
        "NSPrincipalClass": "NSApplication",
        "NSAppleScriptEnabled": False,
        "NSHighResolutionCapable": True,
        "CFBundleDisplayName": "Lunii Sync",
        "CFBundleShortVersionString": "1.0.0",
        "NSHumanReadableCopyright": "Malik Karaoui",
        # Accès disque amovible (Lunii USB)
        "com.apple.security.device.usb": True,
        "NSRemovableVolumesUsageDescription":
            "Lunii Sync a besoin d'accéder à la Lunii branchée en USB.",
    },
)
