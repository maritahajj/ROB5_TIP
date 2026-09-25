# TP2 — Identification dynamique d'un robot manipulateur à deux axes (2R)

Ce dépôt contient l'ensemble des scripts MATLAB réalisés dans le cadre du TP2 portant sur l'identification des paramètres dynamiques (gravité, frottements, inertie, couplage) d'un robot plan à deux axes (2R) avec actionneurs montés sur le bâti (paramétrage absolu).

## Fichiers rendus

```text
TP2/
├── ident_axe2_v_cste.m
├── ident_axe2_v_cste_filtre.m
├── ident_axe1_v_cste.m
├── ident_axe1_v_cste_filtre.m
├── ident_combine.m
├── releve_vit_cste_axe1.mat
├── releve_vit_cste_axe2.mat
└── releve_mvts_combines.mat
```

### 1. Modélisation théorique

Le modèle dynamique du robot 2R est d'abord établi avec la méthode de Newton-Euler en paramétrage relatif classique, puis réécrit en paramétrage absolu (Eq. 3 du sujet), correspondant au montage réel des actionneurs sur le bâti (moteurs déportés, liaison par courroie). Ce changement de paramétrage simplifie le modèle : l'inertie de l'axe 1 devient constante, les effets de Coriolis s'annulent, et le couple de gravité sur l'axe 1 ne dépend plus de la position de l'axe 2.

La dynamique des actionneurs (réducteurs, frottements) est ensuite intégrée (Eq. 5), avant d'être réécrite sous une forme linéaire en les paramètres inconnus (Eq. 6 et 7), exploitable par une identification aux moindres carrés.

### 2. Identification des frottements et de la gravité (vitesse constante)

#### `ident_axe2_v_cste.m`
Charge `releve_vit_cste_axe2.mat` (mesures à axe 1 immobile, axe 2 à vitesse constante) et construit la matrice de régression `Y(θ₂, θ̇₂) = [cos θ₂, sgn(θ̇₂), θ̇₂, 1]` à partir des données brutes (`i2`, `qp2`). Résout `p = Y⁺u = (YᵀY)⁻¹Yᵀu` pour identifier `p = [α₂, a₂, b₂, c₂]ᵀ`.

#### `ident_axe2_v_cste_filtre.m`
Copie du script précédent, utilisant les données filtrées (`ifil2`, `qpfil2`) au lieu des données brutes, pour comparer l'effet du filtrage non déphasant sur la qualité de l'identification.

#### `ident_axe1_v_cste.m` / `ident_axe1_v_cste_filtre.m`
Même démarche appliquée à l'axe 1, à partir de `releve_vit_cste_axe1.mat` (mouvements de l'axe 1 à vitesse constante, avec `θ̇₂ = θ̇₁` et `θ₂ − θ₁ = −π`, configuration équivalente à `θ̇₂ = 0`), en version brute et filtrée.

**Paramètres identifiés :**

| Paramètre | Axe 1 brut | Axe 1 filt. | Axe 2 brut | Axe 2 filt. |
|---|---|---|---|---|
| α (Gravité) | 0.8732 | 0.8721 | 0.0833 | 0.0829 |
| a (Frottement sec) | 0.1763 | 0.1755 | 0.0582 | 0.0582 |
| b (Frott. visqueux) | 0.0055 | 0.0060 | 0.0019 | 0.0019 |
| c (Asymétrie offset) | -0.0310 | -0.0302 | -0.0123 | -0.0123 |

### 3. Identification des termes inertiels (excitation persistante)

#### `ident_combine.m`
Charge `releve_mvts_combines.mat` (mouvements sinusoïdaux combinés, fréquence et amplitude variables sur les deux axes). Après soustraction des couples de gravité et de frottement précédemment identifiés, construit la matrice des régresseurs `Z(q, q̇, q̈)` (deux lignes par échantillon, cf. Eq. 7 du sujet) à partir des données filtrées (`ifil1`, `ifil2`, `qpfil1`, `qpfil2`, `qppfil1`, `qppfil2`). Résout le système par moindres carrés pour extraire les trois paramètres inertiels restants.

**Paramètres identifiés :**

| Paramètre | Valeur |
|---|---|
| I'₁ + m₂l₁² + Ia1 (inertie axe 1) | 0.027263 |
| h (couplage inter-axes) | 0.001726 |
| I'₂ + Ia2 (inertie axe 2) | 0.000623 |

Le script affiche également, pour chaque axe et en fonction du temps, le couple équivalent mesuré (`NᵢKcᵢiᵢ`), ainsi que les couples de gravité, de frottement, des effets centrifuges, des termes d'inertie, et leur somme (couple total du modèle), permettant de comparer graphiquement le modèle reconstruit aux mesures.

## Exécution

Ouvrir MATLAB et se placer dans le dossier `TP2`.

Pour l'identification des frottements et de la gravité :
```matlab
load releve_vit_cste_axe2
ident_axe2_v_cste
ident_axe2_v_cste_filtre

load releve_vit_cste_axe1
ident_axe1_v_cste
ident_axe1_v_cste_filtre
```

Pour l'identification des termes inertiels :
```matlab
load releve_mvts_combines
ident_combine
```

Après exécution, les paramètres identifiés (`p`) s'affichent dans le Command Window, ainsi que les graphiques de comparaison couple mesuré / couple reconstruit.

## Prérequis
- MATLAB (testé sur une version standard)
- Signal Processing Toolbox (pour la commande `filtfilt` utilisée sur les signaux filtrés)
