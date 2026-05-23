# Mailbox projet

> Géré automatiquement par Claude. Markdown vivant, pas document gravé.

## Courrier entrant

### 2026-05-24 — Waveform visuelle SFX + lecture locale [auto]

- Source : session patch frontend `../lunii-studio`
- Statut : archivé
- Résumé : la curation SFX n'utilise plus le lecteur global pour la préécoute dans `Bruitages`. Chaque carte peut ouvrir une vraie piste audio visuelle locale avec lecture directe de la zone conservée, poignées de trim sur la waveform, et synchronisation avec les champs `début` / `fin`.
- Prochaine action : faire une passe UX sur le ressenti des poignées et ajouter au besoin un zoom horizontal si les trims très courts sont fréquents

### 2026-05-24 — Découpe directe des bruitages depuis la page [auto]

- Source : session patch backend + frontend `../lunii-studio`
- Statut : archivé
- Résumé : chaque carte de l'onglet `/bibliothèque` → `Bruitages` permet maintenant de couper directement le début et/ou la fin d'un son (ex. `0,3 s` en entrée), avec sauvegarde du fichier source, recalcul durée/hash, et remise automatique en validation `pending`. Les catégories d'import ont aussi été élargies (`animaux`, `combat`, `transitions`, `magie`) pour accueillir plus de types de bruitages.
- Prochaine action : importer un plus gros pack CC0, faire les coupes rapides dans l'UI, puis valider/invalider à l'oreille

### 2026-05-23 — Onglet Bruitages livré dans la Bibliothèque [auto]

- Source : session patch backend + frontend `../lunii-studio`
- Statut : archivé
- Résumé : la page `/bibliothèque` expose maintenant un onglet `Bruitages` dédié à la curation SFX : import massif fichiers/dossier, titres français automatiques à partir des noms de fichiers, préécoute audio, filtres, et validation/invalidation persistée dans le manifest SFX backend.
- Prochaine action : importer un premier lot large de sons CC0, faire la validation humaine dans l'UI, puis réutiliser uniquement les sons validés pour le pipeline d'histoires sonorisées

### 2026-05-23 — Validation MP3 Henri IV + invariants audio [auto]

- Source : session de génération et validation utilisateur
- Statut : archivé
- Résumé : la leçon `Henri IV entre dans Paris — le 22 mars 1594` a été générée jusqu'au MP3 final dans `../lunii-studio`. Le MP3 a été servi correctement par le backend local et l'utilisateur a validé deux points sensibles : temps de pose après les questions respecté, et énoncé du titre respecté.
- Prochaine action : verrouiller ces invariants en non-régression côté `../lunii-studio`, puis reprendre l'amélioration UX/pipeline (phases plus lisibles côté front)

### 2026-05-23 — Split Studio / Histoires / Bibliothèque implémenté [auto]

- Source : session patch frontend `../lunii-studio`
- Statut : archivé
- Résumé : le studio web sépare désormais les essais one-shot des histoires complètes sans migration backend lourde : `/` redirige vers `/studio`, `/studio` liste les générations `history`, `/histoires` reste la vue story détaillée, et `/bibliothèque` affiche à la fois stories complètes et essais audio.
- Prochaine action : valider à la main le parcours utilisateur complet et ajuster si un doublon UX persiste côté bibliothèque ou player

### 2026-05-22 — Session initialisation vault [auto]

- Source : Claude Code (session manuelle d'exploration complète)
- Statut : archivé
- Résumé : Exploration complète du projet réalisée. LuniiHACK est un repo de transition/orchestration : LuniiSync (GUI USB sync, stable, vendu 9,99€) est le produit principal ; La Forge à histoires (studio IA) délègue au repo sibling `../lunii-studio`. Le chantier SFX (bruitages automatiques) est scoped et en phase C (intégration pipeline), avec une spec architecturale solide dans `CHANTIER_BRUITAGES_AUTOMATIQUES_2026-05-20.md`. 307 tests production passent en CI. Vault alimenté pour la première fois avec les vraies données projet.
- Prochaine action : Phase B SFX (curation bibliothèque locale 80–150 sons CC0) + Phase C (intégration sound_cues dans lunii-studio)

### 2026-05-22 — Vault initialisé [auto]

- Source : setup-project-vaults.py
- Statut : archivé
- Résumé : Vault créé pour le projet LuniiHACK. Les sessions futures doivent alimenter ce fichier à chaque clôture significative.
- Prochaine action : première session → compléter vault/00-brief.md + vault/40-roadmap.md
