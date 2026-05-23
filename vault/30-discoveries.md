# Découvertes projet

> ⛔ **RÈGLE 1 — ANTI-HALLUCINATION ABSOLUE**
> Une découverte non vérifiée n'est pas une découverte. Pas d'entrée sans source factuelle.

> Géré automatiquement par Claude. Markdown vivant, pas document gravé.

## Découvertes

### 2026-05-22 · Architecture 3-zones du repo

- **Découverte** : LuniiHACK est organisé en 3 zones distinctes : `Transfertboiteàhistoire/` (LuniiSync stable), `LaForge_a_histoires/` (studio, délègue à sibling), `Archives/` (prototypes gelés)
- **Impact** : toute modification root impacte les builds packaging ; ne pas mélanger avec la logique studio
- **Source** : `README.md` + structure répertoire

### 2026-05-22 · Repo actif est un sibling, pas un sous-dossier

- **Découverte** : le développement actif (FastAPI, TTS, React) est dans `../lunii-studio` (chemin relatif), pas dans ce repo. `bun run forge` lance `../lunii-studio`
- **Impact** : pour travailler sur le studio IA, il faut ouvrir `../lunii-studio`, pas ce repo
- **Source** : `package.json` + `LaForge_a_histoires/lancer-la-forge.sh`

### 2026-05-22 · Protocole Lunii : XXTEA + AES

- **Découverte** : les devices Lunii utilisent un protocole propriétaire basé sur XXTEA pour l'encryption des stories et AES pour certaines métadonnées. Implémenté via `xxtea` et `pycryptodome`
- **Impact** : tout changement de la couche device protocol nécessite tests hardware réels
- **Source** : `lunii-app.py` imports + `Lunii.QT/` (git-cloned submodule)

### 2026-05-22 · SFX sound_cues : `anchor_segment_id` + position enum, pas timestamp

- **Découverte** : les sound_cues du LLM ne doivent PAS contenir de timestamps absolus. L'ancrage se fait via `anchor_segment_id` (ID du segment vocal) + `position` (before/under/after/ambient). Le backend calcule les vrais offsets
- **Impact** : évite la désynchronisation quand le script est reformulé ; backend = source de vérité temporelle
- **Source** : `CHANTIER_BRUITAGES_AUTOMATIQUES_2026-05-20.md` §schema + critique du modèle précédent

### 2026-05-22 · Bibliothèque SFX locale actuelle rejetée

- **Découverte** : le premier userpack SFX testé (`BIBLIOTHEQUE_BRUITAGES_ACTIFS.md`) a été rejeté pour qualité insuffisante. 5 sons ont été importés manuellement (`BIBLIOTHEQUE_BRUITAGES_USERPACK_2026-05-21.md`) pour tests
- **Impact** : la curation d'une vraie bibliothèque CC0 (Kenney, Freesound) est une tâche bloquante pour le MVP SFX
- **Source** : `histoire/BIBLIOTHEQUE_BRUITAGES_ACTIFS.md` + `histoire/BIBLIOTHEQUE_BRUITAGES_USERPACK_2026-05-21.md`

### 2026-05-22 · PyInstaller spec avec Lunii.QT cloné à la volée

- **Découverte** : `lunii-app.spec` et le workflow `build.yml` clonent `Lunii.QT` (repo externe o-daneel) au moment du build, pas stocké dans ce repo
- **Impact** : changement de version Lunii.QT = modifier le workflow ; breaking changes upstream non détectables sans CI verte
- **Source** : `.github/workflows/build.yml` + `lunii-app.spec`

### 2026-05-22 · studio-pack-generator v0.5.14 — URLs fixes dans CI

- **Découverte** : le binaire `studio-pack-generator` v0.5.14 est téléchargé depuis des URLs hardcodées dans `build.yml`. La correction des URLs (commit `a5a8853`) était un fix de crash critique
- **Impact** : toute mise à jour de SPG nécessite MAJ des URLs dans build.yml + test de la chaîne complète
- **Source** : commit `a5a8853` + `.github/workflows/build.yml`

### 2026-05-22 · 307 tests production — structure et couverture

- **Découverte** : 2 854 lignes de tests dans `tests/`, 7 modules couvrant : story_writer (LLM JSON), lunii_push_service (device comm), histoire_to_story (format conversion), device_routes (API endpoints), story_parsing (validation), device_api (protocole encryption), conftest (fixtures/mocks)
- **Impact** : toute régression sur ces domaines sera détectée en CI (Ubuntu, pytest automatisé)
- **Source** : commit `0d218ca` + `tests/` directory

### 2026-05-22 · LuniiSync vendu 9,99€ — produit commercial stable

- **Découverte** : LuniiSync est explicitement décrit comme un produit vendu (9,99€), ce qui implique des contraintes de stabilité et de rétrocompatibilité plus fortes que pour un outil interne
- **Impact** : ne pas casser les builds macOS/Windows ; pas de breaking changes sur les formats de manifeste sans migration
- **Source** : `README.md` + `AUDIT_STRATEGIQUE_LUNII_STUDIO_2026-05-17.md`

### 2026-05-22 · Crash Qt QueuedConnection — fix appliqué

- **Découverte** : un crash lié à `QueuedConnection` dans le thread Qt a été corrigé (commit `a9a56ac`). La progress bar et le popup résultat de sync étaient aussi affectés
- **Impact** : la GUI est stable post-fix ; éviter les connexions signal/slot non-queued entre threads dans PySide6
- **Source** : commit `a9a56ac`

### 2026-05-22 · Vault exposé via symlink Obsidian

- **Découverte** : le dossier `vault/` est exposé dans Obsidian via symlink. Les fichiers vault doivent donc être du Markdown propre (pas de syntaxe non-standard) et les titres H2/H3 sont utilisés comme nœuds de graphe dans Obsidian
- **Impact** : garder les vault files lisibles sans plugins spéciaux ; éviter les blocs de code excessifs dans 00-brief.md
- **Source** : `CLAUDE.md` §vault

### 2026-05-23 · Contrat audio pédagogique validé en run réel

- **Découverte** : la leçon générée `Henri IV entre dans Paris — le 22 mars 1594` respecte bien le contrat audio attendu en sortie réelle : énoncé du titre présent, silence avant titre conservé, pause après titre conservée, et temps de pose après les questions respecté avant correction.
- **Impact** : ces points deviennent des critères de non-régression explicites pour `../lunii-studio` sur les leçons audio ; toute évolution pipeline/story_writer doit les préserver.
- **Source** : pipeline `54829491-8d31-4405-9f80-201e7b60efc5` terminé (`mp3_path=/Users/malik/Lunii/histoires/Henri_IV_entre_dans_Paris_le_22_mars_1594_54829491.mp3`) + validation utilisateur session du `2026-05-23`

### 2026-05-23 · Validation manuelle SFX branchée dans l'UI produit

- **Découverte** : `../lunii-studio` possède désormais dans `/bibliothèque` un onglet `Bruitages` dédié à la curation SFX, branché au backend `backend/routes/sfx.py` via de nouvelles routes d'import massif, préécoute audio et mise à jour persistée des labels/statuts dans le manifest local.
- **Impact** : la phase B SFX n'est plus bloquée par une doc ou un tri externe ; l'utilisateur peut importer 100–300 sons, les écouter un par un et constituer une bibliothèque validée exploitable par le pipeline.
- **Source** : patch session du `2026-05-23` dans `../lunii-studio` (`app/src/components/ExportTab/SfxLibraryPanel.tsx`, `app/src/components/ExportTab/ExportTab.tsx`, `backend/routes/sfx.py`, `backend/services/sfx_index.py`) + validations `bun run typecheck` et `backend/venv/bin/python -m pytest backend/tests/test_sfx_library.py backend/tests/test_sfx_routes.py -q`

### 2026-05-24 · Édition destructive SFX disponible depuis la carte bruitage

- **Découverte** : `../lunii-studio` permet maintenant de couper directement le début et/ou la fin d'un bruitage depuis l'onglet `Bruitages` avec saisie en secondes (ex. `0,3`), sauvegarde en place du fichier source, recalcul de durée/hash, et retour automatique du statut à `pending`.
- **Impact** : la curation SFX n'exige plus un éditeur audio externe pour les trims simples ; l'utilisateur peut nettoyer un lot massif avant validation finale, directement dans l'UI produit.
- **Source** : patch session du `2026-05-24` dans `../lunii-studio` (`backend/services/sfx_edit.py`, `backend/routes/sfx.py`, `app/src/components/ExportTab/SfxLibraryPanel.tsx`) + validations `bun run typecheck` et `backend/venv/bin/python -m pytest backend/tests/test_sfx_library.py backend/tests/test_sfx_routes.py -q`

### 2026-05-24 · Préécoute SFX réintégrée directement dans la waveform de carte

- **Découverte** : dans `../lunii-studio`, la lecture des bruitages est maintenant embarquée directement dans le composant visuel de trim de chaque carte SFX, au lieu de dépendre du lecteur global bas de page. La waveform locale sait lire uniquement la zone conservée et les poignées mettent à jour les trims en direct.
- **Impact** : la panne de préécoute SFX ne bloque plus la curation ; lecture et découpe se font au même endroit, ce qui réduit fortement la friction pour valider un gros lot de bruitages.
- **Source** : patch session du `2026-05-24` dans `../lunii-studio` (`app/src/components/ExportTab/SfxWaveformTrimEditor.tsx`, `app/src/components/ExportTab/SfxLibraryPanel.tsx`) + validation `bun run typecheck`

### 2026-05-23 · Séparation produit viable sans migration backend lourde

- **Découverte** : dans `../lunii-studio`, la séparation métier voulue par l'utilisateur peut s'appuyer sur les structures déjà présentes : `history` = essais one-shot manuels, `stories` = histoires complètes consultées dans `/histoires`. Le vrai bug UX venait surtout du routage (`/` sans `/studio`) et des vues qui mélangeaient les deux familles.
- **Impact** : pas besoin immédiat d'ajouter un champ DB `essai|histoire` pour obtenir la séparation UX demandée ; il suffit de router `/` → `/studio`, de réserver `/studio` aux générations `history`, et de faire afficher `/bibliothèque` les deux familles sans mélanger la synchro Lunii.
- **Source** : lecture + patchs session du `2026-05-23` dans `../lunii-studio` (`router.tsx`, `StoryRunsPanel.tsx`, `ExportTab.tsx`, `FloatingGenerateBox.tsx`, `AppFrame.tsx`)
