# Brief projet

> ⛔ **RÈGLE 1 — ANTI-HALLUCINATION ABSOLUE**
> Interdiction totale d'inventer, de mentir, d'halluciner.
> Si incertain → « Je ne peux pas l'affirmer » + 2-3 hypothèses + comment vérifier.

> Géré automatiquement par Claude. Markdown vivant, pas document gravé.

## État court

- Projet : **Synchro Boîte à histoires** (repo : `malikkaraoui/Synchro_boite_a_histoires`)
- Phase : **Production — maintenance active** (dernière release : v2.1.12 le 2026-05-22)
- Stack : **Tauri 2.0 (Rust) + Vanilla JS/HTML/CSS + Python sidecar (boite-bridge.py)**
- Objectif courant : améliorer la fiabilité et l'UX du transfert audio vers la boîte à histoires
- Prochaine action utile : implémenter l'affichage des pochettes d'histoires (TODO.md)

## À lire en priorité

- .claude/CLAUDE.md §0 — contexte session courant
- vault/40-roadmap.md — prochaines phases
- TODO.md — fonctionnalités planifiées

## Décisions actives

- Architecture hybride Rust+Python maintenue (Rust pour la détection/inventaire, Python pour la crypto boîte à histoires)
- Identification device par `serial-*` (plus stable que UUID FAT32)
- Signature macOS ad-hoc (`-`) par défaut pour les builds directs
- Distribution via GitHub Releases avec updater intégré

## Risques / angles morts

- Dépendance `StoryBox.QT` (bibliothèque tierce) — si l'API boîte à histoires change, le pack generator est cassé
- Builds Windows non testés en production (workflow GitHub ajouté en v2.1.11 mais non validé)
- Signature macOS ad-hoc : Apple peut encore bloquer sur certaines configurations
- Dépendances Python téléchargées au premier transfert depuis Internet (point de fragilité)
