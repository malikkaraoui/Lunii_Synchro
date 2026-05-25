# Prompt Claude — chantier Rust transfert boîte à histoires — exécution maximale

Tu travailles sur le dépôt actif **`../La Forge a histoires`**.

Tu n’es pas là pour faire un exposé théorique.
Tu es là pour **prendre le chantier Rust de transfert boîte à histoires et l’emmener au plus haut niveau de qualité possible**, de manière concrète, progressive, testée, et exploitable dans le vrai produit.

Je veux **le meilleur du meilleur**.
Pas une maquette intellectuelle.
Pas une pseudo-refonte abstraite.
Pas un roman.
Je veux une avancée réelle, propre, robuste, ambitieuse, et défendable techniquement.

---

## 1. Contexte réel à respecter

Le dépôt hub `Projet_transition_forge_sync` n’est **pas** le dépôt technique principal.
Le vrai chantier se fait dans :

- `../La Forge a histoires`

Le produit visé est un **desktop app** avec :

- frontend app
- backend Python/FastAPI
- shell Tauri
- maintenant une **première brique Rust déjà introduite**

### État actuel déjà en place

Le chantier n’est plus au point zéro.
Il existe déjà une première base Rust/Tauri côté détection.

Fichiers importants à examiner en priorité :

- `../La Forge a histoires/backend/routes/device.py`
- `../La Forge a histoires/backend/services/sync_status.py`
- `../La Forge a histoires/backend/services/storybox_push.py`
- `../La Forge a histoires/app/src/components/ExportTab/ExportTab.tsx`
- `../La Forge a histoires/app/src/components/ExportTab/DeviceCard.tsx`
- `../La Forge a histoires/app/src/lib/native/storyBoxDevice.ts`
- `../La Forge a histoires/tauri/src-tauri/src/main.rs`
- `../La Forge a histoires/tauri/src-tauri/src/storybox_device.rs`
- `../La Forge a histoires/tauri/src-tauri/build.rs`
- `../La Forge a histoires/tauri/src-tauri/Cargo.toml`

### Réalité produit déjà constatée

Le système a déjà souffert de plusieurs problèmes réels :

- détection front faussement négative alors que la boîte était bien montée
- endpoint backend `/device/storybox` trop lent
- scans coûteux inutiles
- risque de comportements implicites ou opaques sur le transfert
- besoin fort de clarté produit : état, progression, feedback, erreurs compréhensibles

Le cap est donc clair :

- **Rust pour la couche critique transfert/device**
- **sans réécriture aveugle du reste**
- **avec cohabitation propre pendant la transition**

---

## 2. Ce que tu dois viser

Je veux une couche transfert/device qui soit :

- **déterministe**
- **lisible**
- **testable**
- **auditable**
- **sobre en effets de bord**
- **compatible produit desktop réel**
- **plus fiable que la logique Python actuelle sur les points critiques**

En langage direct :

je veux qu’à terme la partie boîte à histoires/transfert soit **solide comme un outil système**, pas fragile comme un assemblage opportuniste.

---

## 3. Ce que tu ne dois pas faire

Interdictions claires :

- ne pas lancer une réécriture totale du backend
- ne pas déplacer tout le produit d’un coup vers Rust
- ne pas casser le front actuel pour “préparer plus tard”
- ne pas faire de grandes abstractions creuses sans livrable concret
- ne pas introduire de logique destructive implicite
- ne pas masquer les erreurs derrière des retours flous
- ne pas te contenter de pseudo-planification si le code peut avancer réellement
- ne pas toucher pour l’instant à `../Synchro_boite_a_histoires`

Et surtout :

- **pas de magie noire**
- **pas de comportement silencieux**
- **pas de “ça devrait marcher” sans preuve**

---

## 4. Ta mission immédiate

Tu dois **prendre la suite du chantier Rust déjà amorcé** et aller aussi loin que possible **sans brûler la sécurité du produit**.

### Priorité absolue

Construire la vraie suite logique après la sonde native existante.

L’ordre attendu est :

#### Étape A — audit rapide de l’existant réel
Tu examines le code actuel et tu confirmes :

- comment la sonde Rust existante est branchée
- où le backend garde encore le contrôle de l’inventaire
- où sont les zones de couplage à réduire
- quelle forme d’intégration Rust est la meilleure **dans ce dépôt précis**, pas dans l’abstrait

#### Étape B — recommander une architecture unique
Tu compares rapidement les options puis tu choisis **une seule direction claire**.

Typiquement, tu peux comparer :

- commandes Tauri natives directes
- crate Rust interne appelée via Tauri
- binaire Rust séparé invoqué depuis le backend ou Tauri
- mix minimal si vraiment nécessaire

Mais à la fin, tu **tranches**.
Je ne veux pas une réponse molle du style “tout est possible”.

#### Étape C — implémentation concrète du lot suivant
Tu implémentes la suite la plus pertinente immédiatement.

Le **minimum ambitieux** attendu est :

1. **inventaire natif structuré côté Rust**
   - lecture `.content`
   - lecture sidecar si présent
   - type structuré propre
   - comptage et métadonnées utiles
   - pas de scan coûteux par défaut

2. **contrats de données propres**
   - device status
   - device story
   - managed/unmanaged
   - sidecar metadata
   - duplicate/outdated/current si possible sans bricolage

3. **intégration front ou orchestration propre**
   - brancher intelligemment la nouvelle capacité
   - conserver fallback/transitions si utile
   - ne pas dégrader l’UX existante

4. **tests réels**
   - tests Rust ciblés
   - validations TS si le front bouge
   - si tu touches backend Python, tests backend ciblés aussi

#### Étape D — si et seulement si c’est mûr
Si le lot précédent est propre et suffisamment verrouillé, tu peux entamer **la préparation du push Rust** ou une brique préparatoire sérieuse :

- identité de story
- comparaison locale/device
- déduplication robuste
- plan propre pour `push_story`

Mais **tu n’attaques pas un push destructif ou trop risqué** si les fondations ne sont pas prêtes.

---

## 5. Exigence d’excellence

Je veux que tu te pousses à fond.

Cela veut dire :

- lire vraiment les fichiers utiles
- comprendre les vrais flux d’appel
- choisir l’architecture la plus forte pour ce repo
- refuser les approximations
- écrire des types propres
- écrire des tests utiles
- garder la lisibilité
- documenter juste assez pour transmettre

Je veux un résultat qui donne la sensation suivante :

> “Là, on a enfin commencé à transformer cette partie en vraie couche système robuste.”

Pas :

> “On a ajouté une rustinette décorative.”

---

## 6. Critères de qualité non négociables

Chaque changement doit être jugé selon :

### Fiabilité
- pas d’effet de bord caché
- pas de suppression implicite
- pas de comportement silencieux

### Lisibilité
- noms clairs
- types explicites
- erreurs compréhensibles

### Performance
- pas de scan profond inutile par défaut
- pas de blocage évitable côté UI
- pas de régression manifeste sur la détection ou l’inventaire

### Intégration
- compatible Tauri
- compatible produit desktop actuel
- coexistence temporaire propre avec Python si nécessaire

### Testabilité
- tests ciblés et significatifs
- validations réellement exécutées
- pas de “non testé mais probablement bon”

---

## 7. Commandes de validation utiles

Tu dois valider ce que tu changes.

Références utiles déjà vérifiées dans ce chantier :

- `bun run typecheck`
- `backend/venv/bin/python -m pytest backend/tests -v`
- pour les tests Rust Tauri locaux sur macOS tant que l’asset d’icône manque :
  - `cd tauri/src-tauri && FORGE_SKIP_ACTOOL=1 cargo test ...`

Important :

- un souci connu d’asset macOS peut casser `actool`
- ne confonds pas ce problème de build d’icône avec la validité de la logique Rust

---

## 8. Livrables attendus

Je veux **du concret**.

### Livrable 1 — décision d’architecture
Une recommandation claire, courte, assumée.

### Livrable 2 — code réel
Pas seulement du design.
Je veux des changements réels dans le dépôt si c’est sûr.

### Livrable 3 — validations exécutées
Liste précise de ce qui a été lancé et du résultat.

### Livrable 4 — next step intelligent
Le prochain lot logique, court, crédible, et priorisé.

---

## 9. Format de réponse attendu

Réponds de façon ferme, concrète, orientée exécution.

Maximum 5 blocs :

1. diagnostic utile
2. architecture retenue
3. changements réellement faits
4. validations exécutées
5. prochaine marche

Pas de roman.
Pas de prudence molle.
Pas de faux suspense.

Et si tu n’as pas assez de matière pour implémenter proprement, tu le prouves, tu expliques le blocage exact, puis tu proposes **la meilleure alternative immédiatement exécutable**.

---

## 10. Rappel stratégique

Le but n’est pas “faire du Rust pour faire du Rust”.
Le but est :

- fiabiliser la détection
- fiabiliser l’inventaire
- fiabiliser le transfert
- fiabiliser la suppression
- rendre l’état produit plus transparent
- préparer une couche durable et premium

Le tout dans **le gros logiciel Studio**.

`../Synchro_boite_a_histoires` viendra **après**, quand ici ce sera validé.

---

## 11. Exécution attendue

Tu prends le sujet **à bras-le-corps**.

Je veux une vraie avancée d’ingénierie, pas un simple commentaire d’architecture.

Travaille comme si cette couche devait devenir la référence long terme du produit.

Fin obligatoire de ta réponse :

`RÉSUMÉ: [1-2 phrases] | FICHIERS: [liste] | NEXT: [action suivante]`
