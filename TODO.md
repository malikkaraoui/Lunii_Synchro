# Synchro Boîte à histoires — TODO

## Images des histoires
Afficher la pochette de chaque histoire dans les deux colonnes.

**Contexte** : les images sur la boîte à histoires sont chiffrées XXTEA → illisibles.
**Solution** : lire l'image depuis les fichiers locaux :
1. Artwork embarqué dans les métadonnées MP3 (tag APIC) → dépendance crate `id3`
2. Fichier image du même nom dans le dossier (ex: `mon_histoire.jpg` à côté de `mon_histoire.mp3`)
3. Sauvegarder en cache local (app_data_dir) keyed par story_id → affichage dans colonne gauche après sync
