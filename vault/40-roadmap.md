# Roadmap vivante

> Géré automatiquement par Claude. Markdown vivant, pas document gravé.

## Livré

- ✅ 2026-05-15 · **307 tests production** — story_writer, lunii_push, device_routes, edge cases — commit `0d218ca`
- ✅ 2026-05-15 · **Archive formelle LuniiHACK → lunii-studio** — commit `01144b9`
- ✅ 2026-05-11 · **Signature Developer ID + notarisation + DMG macOS** — commit `a9a56ac` (build.yml)
- ✅ 2026-05-11 · **Fix crash Qt QueuedConnection + progress bar + popup sync** — commit `a9a56ac`
- ✅ 2026-05-10 · **Fix URLs studio-pack-generator v0.5.14** — commit `a5a8853`
- ✅ **LuniiSync GUI** (`lunii-app.py`, 556 lignes) — détection device, sync USB, manifeste par device, ZIP auto, cover art auto, multi-plateforme
- ✅ **Pipeline SFX MVP** (dans `../lunii-studio`) — deux passes : tts → resolve_mix → render → completed ; pause/resume/stop ; snapshot integrity tracking
- ✅ **SFX Resolver** (BT-08A) — mix_plan déterministe depuis sound_cues + timeline voix
- ✅ **SFX Renderer FFmpeg** (BT-09A) — multi-track, volume, fades, looping, positionnement temporel
- ✅ **SFX Snapshot Integrity** (BT-10A) — source_file + source_hash, warnings non-bloquants sur divergence
- ✅ **Documentation API SFX + MCP** (BT-11) — `docs/sfx-api-mcp.md` + MCP README mis à jour
- ✅ **Tests intégration SFX E2E** (BT-12) — `test_sfx_pipeline_integration.py`, 5 tests, propagation snapshots confirmée
- ✅ **BT-00 validation hardware** — audio 44100 Hz mono pushé sur device Lunii, lu correctement
- ✅ **Script audio de démonstration** — `le_jardin_secret.pipeline-script.json` (11 segments, 3 personnages, 5 sound_cues)
- ✅ **Builds CI/CD** — GitHub Actions build.yml (macOS DMG + Windows ZIP) + test.yml (pytest Ubuntu)
- ✅ **Packaging PyInstaller** — macOS notarisé, Windows standalone
- ✅ **Validation MP3 leçon Henri IV** — titre annoncé + pauses respectées + MP3 final servi localement (`/Users/malik/Lunii/histoires/Henri_IV_entre_dans_Paris_le_22_mars_1594_54829491.mp3`)
- ✅ **Split UX Studio / Histoires / Bibliothèque** (dans `../lunii-studio`) — `/` redirige vers `/studio`, `/studio` montre les essais one-shot, `/histoires` reste dédié aux stories complètes, `/bibliothèque` affiche stories + essais
- ✅ **Onglet Bibliothèque → Bruitages** (dans `../lunii-studio`) — import massif de sons, titres français auto, préécoute, validation/invalidation persistée, tests backend ciblés + typecheck frontend OK
- ✅ **Découpe directe des bruitages dans l'UI** (dans `../lunii-studio`) — coupe début/fin du fichier source depuis la carte bruitage, durée/hash recalculés, statut remis à `pending`, 51 tests SFX ciblés verts
- ✅ **Waveform visuelle par carte SFX** (dans `../lunii-studio`) — ouverture de la piste audio dans la carte, lecture locale intégrée, poignées de trim directement sur la waveform, synchronisation avec les champs de découpe

## Sur le feu

- 🔄 **Phase B SFX — curation bibliothèque locale** : sélectionner/importer 80–150 sons CC0 (Kenney.nl, Freesound CC0, Pixabay), les découper si nécessaire, puis les valider/invalider dans l'onglet `Bruitages`
- 🔄 **Phase C SFX — intégration pipeline** : connecter sound_cues → resolver → renderer dans lunii-studio, tester sur stories réelles
- 🔄 **Tests manuels complet flow** `bun run forge` : parcours utilisateur de bout en bout (sujet → ambiance → durée → script → audio → preview → export → device)
- 🔄 **Verrouillage non-régression audio pédagogique** : protéger dans `../lunii-studio` les invariants validés en run réel (titre énoncé, silence avant/après titre, temps de pose après questions)
- 🔄 **UX pipeline StoryWriter** : rendre les étapes backend (`tts` → `resolve_mix` → `render`) plus lisibles et rassurantes côté front
- 🔄 **Validation manuelle du split UX** : vérifier en run réel que les essais n'apparaissent plus dans `/studio` comme histoires, que les contenus du wizard sont bien visibles dans `/histoires`, et que la bibliothèque montre les deux familles sans doublon perçu

## Ensuite

- 📋 **Phase D SFX — UI retouching** : outils d'édition manuelle des sound_cues dans StoryTrackEditor (ajustement timing, volume, swap de son)
- 📋 **Phase E SFX — validation écoute réelle** : test sur device Lunii avec histoires + bruitages, validation subjective qualité audio
- 📋 **Décision finale architecture cloud** : confirmer Option B Hybride ou préparer migration Option A Full Cloud (impact: mobile, billing Stripe)
- 📋 **Intégration Stripe credits** : modèle 200–340 crédits/histoire défini mais non implémenté

## Parking

- 💡 SFX leçons/podcasts — grammaire sonore pédagogique différente (chimes éducatifs vs ambiances narratives) — V2 post-histoires stables
- 💡 Ducking/sidechain audio — volume normalization prudente suffit pour MVP ; sidechain si nécessaire en V2
- 💡 Migration physique fichiers root LuniiHACK → `LaForge_a_histoires/` — différée pour ne pas casser CI/CD
- 💡 Subsetting intelligent du manifeste SFX pour le LLM — actuellement manifeste complet envoyé (coûteux) ; genre/type/analyse = subsetting futur
- 💡 Option A Full Cloud (Modal.com TTS + Stripe pay-as-you-go) — non recommandé avant stabilisation MVP local
- 💡 Réécriture Go/Rust — explicitement non recommandée (cf. AUDIT_STRATEGIQUE) ; à ne pas relancer sans raison bloquante
