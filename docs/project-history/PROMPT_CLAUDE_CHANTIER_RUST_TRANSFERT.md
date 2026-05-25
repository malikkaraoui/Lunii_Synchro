# Prompt Claude — chantier Rust transfert boîte à histoires

Le transfert actuel est en cours de validation côté produit.
Une fois cette validation confirmée, nous lançons le **chantier Rust** pour la couche de transfert / device management.

## Positionnement

Oui, ici **Rust est le meilleur candidat** pour le long terme, pour plusieurs raisons :

- contexte **desktop / Tauri**
- besoin de **fiabilité forte**
- opérations **USB / filesystem / device I/O** sensibles
- besoin de **progression déterministe**
- besoin d’une couche moins fragile que la logique Python actuelle sur les points critiques
- besoin d’une base maintenable, explicable, testable, portable

Mais attention :

- on ne fait pas une réécriture aveugle
- on ne refait pas tout d’un bloc
- on extrait d’abord **la couche critique transfert/device**
- on garde des frontières simples et auditables

## Périmètre de cette phase Rust

Le chantier Rust vise d’abord la partie **boîte boîte à histoires / transfert / suppression / inventaire / détection**, pas toute l’app.

### À inclure en priorité

1. **détection du device**
   - trouver la boîte connectée
   - identifier son mount / état / capacité
   - distinguer absence device / device invalide / device lisible

2. **inventaire des stories présentes sur la boîte**
   - lire les UUID / dossiers
   - remonter un état structuré
   - exposer les métadonnées utiles
   - éviter les scans coûteux non nécessaires

3. **push unitaire d’une histoire**
   - transférer exactement une histoire
   - zéro effet de bord hors cible
   - idempotence autant que possible
   - éviter les doublons inutiles

4. **suppression unitaire**
   - suppression explicite
   - résultat clair
   - erreurs compréhensibles
   - aucune logique destructive implicite

5. **statuts / progression / erreurs structurées**
   - états normalisés
   - progression fiable
   - erreurs lisibles et exploitables côté UI
   - événements compatibles frontend/Tauri

6. **identité / sidecar / déduplication**
   - hash / story_id / sidecar / source
   - savoir si une story est déjà présente
   - savoir si elle est à jour / obsolète / inconnue

## Hors périmètre initial

Pour cette première phase Rust, ne pas essayer de tout absorber :

- pas de réécriture complète du backend
- pas de réécriture de la génération TTS
- pas de migration frontend massive
- pas de refonte totale de la DB
- pas encore d’adaptation directe du repo `../Synchro_boite_a_histoires`

## Objectif architectural

Je veux une architecture simple :

- **frontend / Tauri**
- **backend/orchestrateur**
- **core Rust transfert/device**

avec une frontière nette.

### Ce que je veux éviter

- logique du device disséminée partout
- appels shell fragiles si évitables
- logique métier cachée dans l’UI
- formats de retour flous
- comportements implicites
- opérations silencieuses sans statut

## Ce que je veux de Claude

### 1. Proposer la meilleure forme d’intégration Rust

Comparer explicitement les options et recommander une seule voie claire :

- crate Rust appelée par Tauri directement
- binaire Rust dédié appelé comme sous-processus
- petite couche Rust avec JSON stdout/stderr
- autre option si meilleure

Je veux une recommandation argumentée selon :

- fiabilité
- simplicité d’intégration
- testabilité
- débogage
- maintenance
- packaging macOS / Windows

### 2. Définir les frontières d’interface

Je veux des contrats clairs pour les opérations principales, par exemple :

- `detect_device`
- `list_device_stories`
- `push_story`
- `delete_story`
- `get_transfer_status`
- `cancel_transfer`

Chaque commande doit avoir :

- entrée claire
- sortie claire
- erreurs structurées
- états explicités

### 3. Concevoir les types de données propres

Je veux des structs / enums explicites pour :

- device status
- device story
- managed story metadata
- push result
- delete result
- duplicate status
- transfer progress
- transfer error

Je veux éviter les blobs vagues.

### 4. Construire un plan d’implémentation incrémental

Je veux un ordre réaliste, par étapes sûres :

#### lot 1
- socle crate Rust
- détection device
- inventaire minimal

#### lot 2
- lecture sidecar / identité story
- comparaison / déduplication

#### lot 3
- push unitaire robuste
- résultat structuré
- tests ciblés

#### lot 4
- suppression unitaire robuste
- validation post-opération

#### lot 5
- progression / cancellation / events
- intégration Tauri/backend

#### lot 6
- packaging / distribution / validation macOS + Windows

### 5. Implémenter seulement ce qui est mûr

Je préfère :

- des petites briques Rust correctes
- bien testées
- bien intégrées

plutôt qu’un énorme chantier théorique non finissable.

## Exigences qualité

Le chantier Rust doit viser :

- comportement déterministe
- erreurs explicites
- opérations auditables
- zéro surprise destructive
- bonnes perfs sur l’inventaire device
- intégration propre avec l’UI existante
- possibilité de rollback / fallback temporaire si besoin

## Exigences produit

À terme, l’utilisateur doit sentir :

- détection immédiate de la boîte
- lecture fiable du contenu
- transfert plus solide
- suppression plus sûre
- progression plus crédible
- moins de bugs “fantômes”

## Contraintes pratiques

- rester compatible avec la distribution desktop
- ne pas casser le parcours actuel de l’utilisateur
- pouvoir coexister temporairement avec la couche Python existante
- si un fallback Python subsiste pendant la transition, il doit être explicite

## Livrables attendus

### Livrable A — recommandation d’architecture Rust

Une recommandation claire sur la forme du composant Rust et son intégration.

### Livrable B — design des contrats

Types, commandes, erreurs, états.

### Livrable C — plan incrémental d’implémentation

Avec l’ordre exact des lots et le risque principal de chaque lot.

### Livrable D — premiers changements concrets

Seulement si la base est suffisamment claire et sûre.

## Suite produit

Important :

- ce chantier Rust se fait d’abord sur le chantier principal
- **ensuite seulement**, après validation, nous ferons le nécessaire dans `../Synchro_boite_a_histoires`

## Format de réponse attendu

Réponse en 4 blocs maximum :

1. architecture recommandée
2. frontières et types
3. plan d’implémentation incrémental
4. premiers changements concrets

Sois concret, orienté exécution, sans roman inutile.
