# Brief projet

> ⛔ **RÈGLE 1 — ANTI-HALLUCINATION ABSOLUE**
> Interdiction totale d'inventer, de mentir, d'halluciner.
> Si incertain → « Je ne peux pas l'affirmer » + 2-3 hypothèses + comment vérifier.

> Géré automatiquement par Claude. Markdown vivant, pas document gravé.

## État court

- **Projet** : LuniiHACK (repo legacy/orchestration) + lunii-studio (repo actif, sibling `../lunii-studio`)
- **Phase** : Transitionnelle — LuniiSync stable & vendu ; SFX système scoped, phase C (intégration) à démarrer
- **Stack** : Python 3.12 + PySide6 (desktop GUI) ; FastAPI + SQLAlchemy + React/Vite (studio, sibling repo) ; FFmpeg + xxtea + pycryptodome (audio/device) ; bun (orchestration) ; pytest (307 tests CI)
- **Objectif courant** : Stabiliser `../lunii-studio` sur quatre fronts : pipeline SFX MVP, contrat audio pédagogique (titre énoncé + pauses respectées) validé en run réel, séparation UX claire entre `/studio`, `/histoires` et `/bibliothèque`, et curation manuelle de la bibliothèque de bruitages via l'UI
- **Dernière validation** : l'onglet `Bruitages` de `../lunii-studio` affiche maintenant une vraie piste audio visuelle par bruitage avec lecture locale intégrée + poignées de trim directement sur la waveform (sans dépendre du player global pour les SFX) ; `bun run typecheck` OK
- **Prochaine action utile** : tester sur un lot réel 20–50 sons, ajuster au besoin la précision ergonomique des poignées, puis envisager une waveform repliable multi-cartes ou un mode plein écran pour curation massive

## À lire en priorité

- `CHANTIER_BRUITAGES_AUTOMATIQUES_2026-05-20.md` — spec SFX MVP (531 lignes, architecturalement complet)
- `vault/40-roadmap.md` — phases livré/en cours/planifié
- `AUDIT_STRATEGIQUE_LUNII_STUDIO_2026-05-17.md` — positionnement produit et décisions marché

## Décisions actives

- LuniiHACK = repo d'orchestration/legacy ; développement actif dans `../lunii-studio`
- LuniiSync (9,99€) : produit stable, ne pas casser les paths de build
- SFX MVP : histoires uniquement (pas leçons/podcasts), 100 sons max, backend valide les cues
- Architecture cloud : Hybride préféré pour MVP (LLM cloud, audio local, desktop-first)
- Pas de réécriture Go/Rust : Python/FastAPI + Tauri suffisant pour la phase actuelle

## Risques / angles morts

- Migration physique code LuniiHACK → LaForge_a_histoires/ différée (casse potentielle builds)
- Qualité bibliothèque SFX locale : userpack actuel rejeté (mauvaise qualité) ; Kenney/Freesound CC0 non encore curé
- LLM sound_cues : `anchor_segment_id` peut être invalidé par reformulation LLM (risque de désynchronisation)
- Détection device : variabilité mount point selon OS (macOS/Linux/Windows)
- Décision cloud non finalisée : Full Cloud vs Hybrid bloque l'architecture réseau
