# TP3 : Identification des Paramètres Géométriques d'un Robot 3R Plan

## Description du Projet
Ce dépôt contient l'implémentation sous MATLAB des travaux pratiques portant sur l'identification des paramètres géométriques d'un robot manipulateur plan à trois liaisons rotoïdes (3R). 

L'objectif principal est de concevoir et d'implémenter un algorithme d'optimisation non-linéaire (méthode de Gauss-Newton) pour estimer les longueurs des segments du robot, les offsets des capteurs articulaires, ainsi que la transformation du repère de mesure. Ce projet met en évidence les problèmes d'identifiabilité (paramètres redondants) et évalue la robustesse de l'algorithme face aux incertitudes expérimentales.

## Structure des Fichiers

Le projet est divisé en trois fichiers MATLAB principaux :

*   `mod_geom.m` : Fonction évaluant le modèle géométrique direct. Elle calcule la position (x, y) et l'orientation (alpha) de l'effecteur dans le repère de mesure, en prenant en compte les offsets articulaires et le décalage du repère de base.
*   `jacobien.m` : Fonction calculant la matrice Jacobienne (matrice des sensibilités) du modèle géométrique par rapport aux 10 paramètres, en utilisant une méthode d'approximation numérique par différences finies.
*   `main.m` : Script principal orchestrant la procédure d'identification. Il génère les données (avec et sans bruit), gère la réduction du vecteur de paramètres pour assurer l'observabilité, exécute la boucle itérative de Gauss-Newton, et lance les différents tests de robustesse.

## Prérequis et Exécution

*   Environnement requis : MATLAB (aucune toolbox spécifique n'est nécessaire).
*   Exécution : Ouvrir MATLAB, s'assurer que les trois fichiers `.m` sont dans le même répertoire de travail, puis exécuter le script `main.m` depuis la fenêtre de commande.

## Concepts Théoriques Abordés

1.  Modélisation Cinématique : Construction du modèle d'un bras 3R incluant les défauts géométriques (offsets, repères décalés).
2.  Identifiabilité : Analyse du rang de la matrice Jacobienne pour identifier les paramètres couplés (redondances entre la base et le premier axe).
3.  Moindres Carrés Non-Linéaires : Utilisation de l'algorithme de Gauss-Newton pour minimiser l'erreur quadratique entre les mesures expérimentales et les prédictions du modèle.
4.  Robustesse : Étude de l'impact du bruit de mesure, de la quantité de données (N), du conditionnement de la matrice (excitabilité des trajectoires) et de la sensibilité aux minima locaux (importance de l'estimation initiale).

## Auteurs
Fatoumata Diallo & Marita El Hajj
