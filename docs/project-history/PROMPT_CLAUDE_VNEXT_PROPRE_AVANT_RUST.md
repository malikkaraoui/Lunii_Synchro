# Prompt Claude — vNext plus propre avant couche Rust

Tu travailles sur le chantier principal autour de Projet_transition_forge_sync / `../La Forge a histoires`.

## Intention générale

Avant toute couche Rust, je veux une **version encore plus propre, plus stable, plus lisible et plus déterministe** de la stack actuelle Python / FastAPI / frontend desktop.

La logique est la suivante :

1. **d’abord** solidifier et nettoyer l’architecture actuelle
2. **ensuite seulement**, préparer la future couche Rust long terme
3. **et seulement après validation de ce chantier**, nous reporterons ce qu’il faut dans `../Synchro_boite_a_histoires`

## Règle absolue de périmètre

Pour cette phase :

- **tu ne touches pas au dossier `../Synchro_boite_a_histoires`**
- tu travailles d’abord sur le chantier principal et ses dépendances directes
- si tu dois préparer la suite pour le repo commercial, tu le fais **uniquement sous forme de notes / plan / checklist**, pas sous forme de modifications dans ce repo-là

## Cap stratégique

Je veux une base :

- plus stable
- plus prévisible
- moins magique
- plus observable
- plus facile à maintenir
- plus facile à migrer ensuite vers Rust

Je ne veux pas d’effet “boîte noire”.
Je veux pouvoir comprendre :

- ce que fait le backend
- ce que fait la couche transfert
- pourquoi une opération est lente
- pourquoi elle échoue
- où en est une opération longue
- ce qui a été réellement poussé / supprimé / ignoré

## Priorité produit

Le produit doit être excellent sur ces points :

- détection boîte à histoires fiable
- inventaire du contenu de la boîte clair
- transfert d’une seule histoire, exactement une
- suppression fiable, explicite, sans comportement destructeur caché
- progression visible
- erreurs lisibles
- comportement idempotent autant que possible
- protection contre doublons / réinjections inutiles
- aucune opération surprise

## Ce que j’attends de toi dans cette phase

### 1. Faire un audit technique ciblé du chantier actuel

Tu identifies précisément :

- les zones encore trop couplées
- les flux trop implicites
- les responsabilités mélangées
- les opérations longues encore mal isolées
- les API ou structures de données qui méritent d’être stabilisées
- les points qui compliqueront une future extraction vers Rust

Je veux du concret, pas du blabla abstrait.

### 2. Proposer puis appliquer une version plus propre de l’architecture actuelle

Objectif : rendre la version Python actuelle propre avant toute réécriture.

Tu dois prioriser :

- séparation plus nette entre UI / orchestration / service de transfert / accès device
- contrats de données plus explicites
- noms de fonctions / modules plus clairs
- limitation des effets de bord
- meilleure gestion des états en cours / terminé / erreur / annulé / déjà présent
- réduction des comportements implicites hérités
- tests ciblés sur les zones critiques

### 3. Nettoyer avec une logique “Rust-ready” sans faire Rust tout de suite

Je ne veux **pas** que tu partes directement dans une réécriture Rust.

Je veux d’abord que tu rendes la version actuelle facilement migrable, par exemple en isolant mieux :

- la découverte device
- l’inventaire contenu boîte
- le push unitaire
- la suppression unitaire
- le calcul des doublons / hash / identité histoire
- la remontée de progression
- la remontée d’erreurs structurées

En clair :

- phase 1 = architecture Python propre
- phase 2 = frontière claire pour une future implémentation Rust

### 4. Préparer la couche Rust long terme, mais seulement en design / points d’extraction

Une fois la phase “version propre” clarifiée, tu pourras préparer le terrain Rust **sans implémenter massivement tout de suite**, sauf si explicitement demandé ensuite.

Je veux que tu identifies :

- quels modules doivent devenir une couche Rust plus tard
- quels contrats JSON / IPC / commande CLI / FFI seraient les plus sains
- quels points doivent rester côté frontend / backend Python
- quelle granularité est la plus propre pour une intégration Tauri / desktop

Important :

- ici, **Rust est bien le meilleur candidat long terme** vu le contexte Tauri / desktop / USB / transferts
- mais **ce n’est pas la première étape de ce prompt**

## Livrables attendus

Je veux que tu produises, dans cet ordre :

### Livrable A — état des lieux court et exploitable

Un résumé concret de :

- ce qui est déjà propre
- ce qui ne l’est pas encore
- ce qui est dangereux / flou / couplé
- ce qui doit être traité avant toute couche Rust

### Livrable B — plan de nettoyage priorisé

Avec des lots clairs, par exemple :

- lot 1 : stabilisation des services de transfert
- lot 2 : normalisation des états / erreurs / progression
- lot 3 : clarification des API internes et structures de données
- lot 4 : tests critiques et validation
- lot 5 : points d’extraction Rust-ready

### Livrable C — implémentation des améliorations prioritaires

Tu fais les changements réellement utiles et vérifiables.

Je préfère :

- des changements ciblés
- des contrats clairs
- des tests ciblés
- une progression fiable

plutôt qu’une grosse refonte théorique risquée.

### Livrable D — note de transition vers Rust

Quand la base Python sera propre, tu rédiges une note concise :

- ce qui devra passer en Rust plus tard
- pourquoi
- dans quel ordre
- avec quelle frontière d’interface

## Contraintes importantes

- pas de grande réécriture aveugle
- pas de complexité gratuite
- pas de daemon opaque lancé en douce
- pas de logique cachée difficile à auditer
- pas de mélange flou entre “génération”, “transfert”, “inventaire”, “synchronisation” et “suppression”
- si une opération peut être destructrice, elle doit être explicite et traçable
- toute amélioration doit aider la maintenabilité et la future migration Rust

## Critères d’acceptation

Avant de considérer cette phase comme validée, il faut pouvoir dire oui à tout ça :

- le comportement de transfert est déterministe
- la suppression est sûre et compréhensible
- les états backend sont visibles et cohérents
- les erreurs sont exploitables côté UI
- les opérations longues ne bloquent pas inutilement le reste
- les zones de responsabilité sont plus nettes
- on voit clairement où brancher une future couche Rust
- on n’a pas encore besoin de toucher `../Synchro_boite_a_histoires`

## Références de contexte

Tu peux t’appuyer sur :

- `../La Forge a histoires` pour le chantier technique actif
- `./AUDIT_STRATEGIQUE_FORGE_2026-05-17.md`
- `./rapport_bug.md`
- les correctifs récents liés au pipeline de fond, aux timeouts front, aux états d’erreur visibles, et à la stabilisation du transfert boîte à histoires

## Important sur la suite

Après validation de ce chantier principal seulement :

- nous préparerons l’adaptation nécessaire dans `../Synchro_boite_a_histoires`
- puis nous lancerons la vraie réflexion / implémentation de la couche Rust long terme

## Format de réponse attendu de ta part

Je veux que tu répondes en 4 blocs maximum :

1. diagnostic concret
2. plan priorisé
3. changements proposés / appliqués
4. préparation de la future frontière Rust

Sois direct, concret, orienté exécution.
Pas de roman.
