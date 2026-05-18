# Synchro_boite_a_histoires

Repo propre pour le **soft léger de transfert audio** vers une boîte à histoires Lunii.

## Important

Le dossier du repo s'appelle `Synchro_boite_a_histoires`, mais l'application conserve volontairement le nom produit **LuniiSync** dans l'UI, les builds et la distribution, pour ne rien casser côté vente actuelle.

Références commerciales conservées :

- page produit : `https://malikkaraoui.com/projects/luniisync`
- achat macOS : `https://buy.stripe.com/dRm8wPcNd1Ob6o7byN6wE01`
- achat Windows : `https://buy.stripe.com/14A14n3cDgJ5cMv7ix6wE02`

## Contenu extrait

- `lunii-app.py` — interface graphique PySide6
- `lunii-push.py` — CLI de synchronisation
- `build-macos.sh` — packaging macOS
- `build-windows.ps1` — packaging Windows
- `lunii-app.spec` — spec PyInstaller
- `lunii-app.entitlements` — entitlements macOS
- `setup.sh` / `setup.ps1` — bootstrap local

## Dépendances volontairement non copiées

Ces éléments sont téléchargés/générés automatiquement pour éviter un repo lourd ou cassant :

- `Lunii.QT/`
- `studio-pack-generator` / `studio-pack-generator.exe`
- artefacts `build/` et `dist/`
- manifests device réels

## Démarrage en dev

### GUI

- `python3 lunii-app.py`

### CLI

- `python3 lunii-push.py /chemin/vers/dossier/audio`

## Build

### macOS

- `bash ./build-macos.sh`

### Windows

- `powershell -ExecutionPolicy Bypass -File .\\build-windows.ps1`

## Données locales

Les manifests device ne sont pas versionnés. Le dossier `manifests/` est gardé vide dans Git par `manifests/.gitkeep`.
