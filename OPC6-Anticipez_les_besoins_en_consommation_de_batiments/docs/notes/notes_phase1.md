# Phase 1 — Notes du cours OC "Initiez-vous au Machine Learning"

> Fiche de prise de notes structurée par concept.  
> Objectif : ne garder que ce qui sera concrètement utile pour les phases 2 à 11 du projet. **À remplir au fil de la lecture.**

**Auteur :** ANNONAY Paul-Alexandre  
**Démarrage :** 08/05/2026  
**Fin cible :** 11/05/2026  
**Lien cours :** https://openclassrooms.com/fr/courses/8063076-initiez-vous-au-machine-learning

---

## Suivi de progression

| # | Chapitre | Statut | Date | Temps réel |
|---|---|---|---|---|
| 1 | P1 Ch. 1 — Découvrez le ML | ⚪ | | |
| 2 | P1 Ch. 2 — Domaine d'application du ML | ⚪ | | |
| 3 | P1 Ch. 3 — Types d'apprentissage | ⚪ | | |
| 4 | P1 Ch. 4 — De la problématique business à la production | ⚪ | | |
| 5 | P2 Ch. 1 — Évaluez la performance d'un modèle prédictif | ⚪ | | |
| 6 | P2 Ch. 2 — Identifiez les enjeux du sur-apprentissage | ⚪ | | |
| 7 | P3 Ch. 1 — Le rôle central du jeu de données | ⚪ | | |
| 8 | P3 Ch. 2 — Améliorez un jeu de données | ⚪ | | |
| 9 | P3 Ch. 3 — Transformez les variables | ⚪ | | |
| 10 | P3 Ch. 4 — Augmentez la robustesse de vos modèles | ⚪ | | |

⚪ Non commencé · 🟡 En cours · 🟢 Terminé

---

## 1. Vocabulaire fondamental

*À compléter au fil des chapitres. Définition courte + exemple appliqué au projet Seattle.*

- **Modèle (de ML)** :
- **Feature (variable explicative)** :
- **Target (variable cible)** :
- **Prédiction** :
- **Entraînement (training)** :
- **Inférence** :
- **Algorithme supervisé** :
- **Régression** (vs classification) :
- **Hyperparamètre** (vs paramètre) :

---

## 2. Cycle d'un projet ML (P1 Ch. 4)

*L'enchaînement à mémoriser — c'est exactement ce que tu vas faire dans le projet.*

1.
2.
3.
4.
5.
6.

**Mapping avec les phases du projet OPC6 :**

| Étape du cycle ML | Phase OPC6 correspondante |
|---|---|
| | |
| | |

---

## 3. Métriques de régression (P2 Ch. 1) ⭐ CRITIQUE

*Tu vas utiliser ces métriques en phase 5. Elles seront aussi citées dans la PPT (livrable 2) et challengées en soutenance.*

### R² (coefficient de détermination)
- **Que mesure-t-il ?** :
- **Plage de valeurs** :
- **Comment l'interpréter ?** :
- **Limite** :

### MAE (Mean Absolute Error)
- **Que mesure-t-il ?** :
- **Unité** :
- **Comment l'interpréter ?** :
- **Avantage vs RMSE** :

### RMSE (Root Mean Squared Error)
- **Que mesure-t-il ?** :
- **Unité** :
- **Différence avec la MAE** :
- **Quand la préférer à la MAE ?** :

### Pour le projet
- Quelle métrique présenter en priorité dans le PPT ?
- Comment la "traduire" en langage métier (ex : « le modèle se trompe de ± X kBtu ») ?

---

## 4. Train / Test / Overfit (P2 Ch. 2) ⭐ CRITIQUE

### Train-Test Split
- **Pourquoi séparer ?** :
- **Proportion classique** (80/20, 70/30…) :
- **Rôle du `random_state`** :

### Overfit / Sur-apprentissage
- **Définition courte** :
- **Comment le détecter ?** (signal sur train vs test) :
- **Comment le combattre ?** :

### Underfit / Sous-apprentissage
- **Définition courte** :
- **Comment le détecter ?** :

---

## 5. Validation croisée (P3 Ch. 4) ⭐ CRITIQUE

*Cœur de la phase 5. Méthode `cross_validate` déjà importée dans le template OC.*

- **Définition** :
- **Différence avec un simple train/test split** :
- **K-Fold** : principe en une phrase
- **Combien de folds en pratique ?** :
- **Quand l'utiliser ?** :

### Méthode `cross_validate` de sklearn
- **Que prend-elle en entrée ?** :
- **Que renvoie-t-elle ?** :
- **Comment fixer la métrique ?** :

---

## 6. GridSearch et hyperparamètres (P3 Ch. 4) ⭐ CRITIQUE

*Cœur de la phase 6. Méthode `GridSearchCV` déjà importée.*

- **Différence paramètre vs hyperparamètre** :
- **Principe de la GridSearch** :
- **Combien de combinaisons en pratique ?** : (consigne OC : max 500)
- **Risque si trop de combinaisons** :
- **Pourquoi tester sur petite grille avant ?** :

---

## 7. Préparation des features (P3 Ch. 3) ⭐ CRITIQUE

*Cœur des phases 3 et 4 du projet.*

### Encoding des variables catégorielles

#### OneHotEncoder
- **Quand l'utiliser ?** :
- **Principe** :
- **Limite** :
- **Argument `max_categories`** :

#### LabelEncoder
- **Quand l'utiliser ?** :
- **Différence essentielle avec OneHotEncoder** :
- **Piège classique** :

### Scaling des variables numériques

#### StandardScaler
- **Que fait-il ?** :
- **Quand est-il nécessaire ?** :
- **Quand est-il inutile ?** :

### Feature engineering
- **Définition** :
- **Distinction avec la simple transformation** :
- **Data leakage** : définition + exemple appliqué au projet Seattle

---

## 8. Familles de modèles à connaître (lecture transverse)

*Tu vas en tester plusieurs en phase 5. Tu n'as pas besoin de maîtriser leur math, juste leur logique générale.*

### Régression linéaire (`LinearRegression`)
- **Idée intuitive** :
- **Hypothèses sous-jacentes** :
- **Avantages** :
- **Limites** :
- **Sensible au scaling ?** :

### Modèles à base d'arbres (`RandomForestRegressor`, `GradientBoosting…`)
- **Idée intuitive** :
- **Avantages** :
- **Limites** :
- **Sensibles au scaling ?** :
- **Permettent la `feature_importance` directement ?** :

### SVM (`SVR`)
- **Idée intuitive** :
- **Sensible au scaling ?** :
- **Limites en pratique** :

### DummyRegressor
- **À quoi sert-il ?** :
- **Pourquoi en avoir un dans la comparaison ?** :

---

## 9. Feature Importance et interprétation (P3 Ch. 4)

*Phase 6 du projet. Histogramme attendu dans le livrable.*

### Feature importance native (modèles à arbres)
- **Comment l'obtenir avec sklearn ?** :
- **Limite (importance = ?) ** :

### Permutation Importance
- **Quand l'utiliser ?** :
- **Méthode sklearn** :

### Pour le projet
- À utiliser sur le modèle retenu uniquement ? Ou sur tous ?
- Format de présentation attendu :

---

## 10. Auto-test de fin de phase

*À remplir avant de démarrer la phase 2. Si tu cales sur 3+ questions, retourne au cours sur le chapitre concerné.*

- [ ] Je sais expliquer la différence entre **régression** et **classification** en une phrase.
- [ ] Je sais à quoi sert un **train/test split** et pourquoi il faut fixer le `random_state`.
- [ ] Je sais ce qu'est l'**overfit** et comment le repérer.
- [ ] Je connais la différence entre **MAE** et **RMSE** et je sais laquelle est plus sensible aux outliers.
- [ ] Je sais interpréter un **R²** (cas R²=0, R²=1, R² négatif).
- [ ] Je comprends le principe de la **validation croisée K-Fold**.
- [ ] Je sais à quoi sert une **GridSearchCV** et pourquoi on limite le nombre de combinaisons.
- [ ] Je connais la différence entre **OneHotEncoder** et **LabelEncoder** et je sais lequel utiliser sur quel type de variable.
- [ ] Je sais quand le **scaling** (StandardScaler) est nécessaire et quand il ne l'est pas.
- [ ] Je sais expliquer ce qu'est un **data leakage** avec un exemple concret pour le projet Seattle.
- [ ] Je sais ce qu'est la **feature importance** et comment l'obtenir.

---

## Questions à poser au mentor (1ʳᵉ session)

*Tout ce qui reste flou après la phase 1. Le mentor est là pour ça.*

-
-

---

## Liens rapides

- [Cours complet — Initiez-vous au Machine Learning](https://openclassrooms.com/fr/courses/8063076-initiez-vous-au-machine-learning)
- [Lexique des notions abordées dans le projet](https://openclassrooms.com/fr/paths/1039/projects/1832/2265-ressource-pedagogique---lexique-des-notions-abordees)
- [`cross_validate` — sklearn](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.cross_validate.html)
- [`GridSearchCV` — sklearn](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.GridSearchCV.html)
- [`permutation_importance` — sklearn](https://scikit-learn.org/stable/modules/generated/sklearn.inspection.permutation_importance.html)
