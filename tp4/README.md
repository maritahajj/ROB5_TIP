# TP4 : identification en ligne (RLS et filtre de Kalman)

Identification des paramètres de gravité et de frottement de l'axe 2 à partir
des données filtrées du TP2 (`releve_vit_cste_axe2.mat`).

Modèle : `i2 = G*cos(q2) + Fv*qp2 + Fs*sign(qp2) + off`, avec `theta = [G; Fv; Fs; off]`.

## Lancer

Placer `releve_vit_cste_axe2.mat` dans ce dossier, puis exécuter `TP4_main.m`.
Les résultats sont déterministes (pas de tirage aléatoire).

## Fichiers

| Fichier | Rôle |
|---|---|
| `TP4_main.m` | Script principal : MC hors ligne, RLS (effet de λ et P1), Kalman (effet de Q et R), comparaison |
| `regresseur.m` | Construit la matrice d'observation A (N x 4) |
| `rls_estimation.m` | Moindres carrés récursifs avec facteur d'oubli |
| `kalman_estimation.m` | Filtre de Kalman pour des paramètres à marche aléatoire |
| `bilan.m`, `afficher_bilan.m` | Indicateurs : valeurs finales, écart au MC, fluctuation, erreur a priori |
| `tracer_parametres.m` | Tracé des 4 paramètres au cours du temps |

## Réglages retenus

- RLS : λ = 1, P1 = 10² I (un P1 petit régularise l'estimation vers zéro).
- Kalman : R = variance du résidu des MC (1.1e-3 A²), Q = 1e-10·diag(θ_MC²), P1 = I.
