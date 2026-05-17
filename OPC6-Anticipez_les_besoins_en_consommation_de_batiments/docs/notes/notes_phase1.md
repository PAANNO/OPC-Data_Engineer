# Phase 1 — Notes du cours OC "Initiez-vous au Machine Learning"

> Fiche de référence structurée par concept. Synthèse du cours OC + applications concrètes au projet Seattle. **Document de révision réutilisable** pour les projets ML suivants de la formation.

**Auteur :** ANNONAY Paul-Alexandre
**Démarrage :** 08/05/2026
**Fin cible :** 14/05/2026
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

- **Modèle (de ML)** : objet mathématique entraîné à partir de données pour produire des prédictions. Concrètement en sklearn, c'est l'objet retourné par `model.fit(X, y)`.
  *Projet Seattle :* le modèle prendra en entrée les caractéristiques d'un bâtiment et produira en sortie une estimation de sa consommation énergétique.

- **Feature (variable explicative)** : une colonne du jeu de données utilisée comme entrée du modèle. Aussi appelée *prédicteur*.
  *Projet Seattle :* `PropertyGFATotal` (surface du bâtiment), `YearBuilt`, `PrimaryPropertyType` sont des features candidates.

- **Target (variable cible)** : la colonne que le modèle apprend à prédire. C'est la variable de sortie.
  *Projet Seattle :* `SiteEnergyUse(kBtu)` (hypothèse retenue dans `DECISIONS.md`).

- **Prédiction** : valeur produite par le modèle pour une observation donnée, via `model.predict(X)`.

- **Entraînement (training)** : étape où le modèle ajuste ses paramètres internes pour minimiser une erreur sur le jeu d'entraînement (`X_train`, `y_train`).

- **Inférence** : étape d'utilisation du modèle pour produire des prédictions sur de nouvelles données (`X_test` en évaluation, ou nouvelles données en production via l'API).

- **Algorithme supervisé** : le modèle apprend à partir de données *étiquetées* (on connaît la target pour chaque observation du jeu d'entraînement).
  *Projet Seattle :* on a la consommation réelle de chaque bâtiment de 2016 → apprentissage supervisé.

- **Régression** : tâche supervisée où la target est *continue* (un nombre).
  **Classification** : tâche supervisée où la target est *catégorielle* (une classe).
  *Projet Seattle :* régression — la consommation est une valeur continue en kBtu.

- **Hyperparamètre** : paramètre fixé *avant* l'entraînement, choisi par le développeur (ex : `n_estimators=100` pour un RandomForest).
  **Paramètre** : valeur apprise par le modèle *pendant* l'entraînement (ex : les coefficients d'une régression linéaire). À ne pas confondre.

---

## 2. Cycle d'un projet ML (P1 Ch. 4)

1. **Compréhension du problème métier** — quelle question business résout-on ?
2. **Récupération et exploration des données** (EDA)
3. **Préparation des données** (nettoyage, feature engineering, encoding, scaling)
4. **Sélection et entraînement de modèles candidats**
5. **Évaluation et comparaison** (sur jeu de test, en validation croisée)
6. **Optimisation** du meilleur modèle (hyperparamètres, feature importance)
7. **Mise en production** (API, monitoring, maintenance)

**Mapping avec les phases du projet OPC6 :**

| Étape du cycle ML | Phase OPC6 correspondante |
|---|---|
| Compréhension du problème | Phase 0 (analyse de la consigne, brief Douglas) |
| Récupération et exploration | Phase 2 (`01_eda.ipynb`) |
| Préparation des données | Phases 3 et 4 (feature engineering + préparation) |
| Sélection et entraînement | Phase 5 (comparaison de modèles) |
| Évaluation et comparaison | Phase 5 (cross-validation) |
| Optimisation | Phase 6 (GridSearch + feature importance) |
| Mise en production | Phases 8 et 9 (API BentoML + déploiement AWS) |

---

## 3. Métriques de régression (P2 Ch. 1) ⭐ CRITIQUE

### R² (coefficient de détermination)
- **Que mesure-t-il ?** La proportion de variance de la target expliquée par le modèle.
- **Plage de valeurs :** ≤ 1 (peut être négatif si le modèle est pire qu'une prédiction par la moyenne).
- **Comment l'interpréter ?**
  - R² = 1 → prédictions parfaites.
  - R² = 0 → le modèle équivaut à prédire la moyenne pour tout le monde.
  - R² < 0 → le modèle est pire qu'une prédiction constante.
  - R² = 0.7 → le modèle "explique" 70 % de la variance de la target.
- **Limite :** un R² élevé ne garantit pas que les prédictions individuelles sont fiables. Toujours regarder MAE/RMSE en complément.

### MAE (Mean Absolute Error)
- **Que mesure-t-il ?** La moyenne des écarts absolus entre prédictions et valeurs réelles.
- **Unité :** la même que la target.
- **Comment l'interpréter ?** "Le modèle se trompe en moyenne de ± MAE unités."
- **Avantage vs RMSE :** moins sensible aux outliers, plus interprétable en langage métier.

### RMSE (Root Mean Squared Error)
- **Que mesure-t-il ?** La racine carrée de la moyenne des erreurs au carré.
- **Unité :** la même que la target.
- **Différence avec la MAE :** pénalise plus fortement les grandes erreurs (car au carré).
- **Quand la préférer à la MAE ?** Quand les grosses erreurs ont un coût disproportionné (en énergie : une sous-estimation massive est plus problématique qu'une petite erreur sur 10 bâtiments).

### Pour le projet
- **Métrique à présenter en priorité dans le PPT :** la MAE — c'est la plus interprétable pour Douglas (Project Lead, profil non technique).
- **Traduction métier :** *« Pour un bâtiment moyen, notre modèle prédit la consommation à ± X kBtu près, soit environ ± Y % de la consommation réelle. »*
- **Présenter aussi R² + RMSE** pour la rigueur scientifique, mais dans un second temps.

---

## 4. Train / Test / Overfit (P2 Ch. 2) ⭐ CRITIQUE

### Train-Test Split
- **Pourquoi séparer ?** Pour évaluer le modèle sur des données qu'il n'a jamais vues. Sans cela, on ne peut pas savoir s'il généralise ou s'il a juste "mémorisé" les données d'entraînement.
- **Proportion classique :** 80/20 ou 70/30. Pour le projet Seattle (~1500 lignes après nettoyage), 80/20 est un bon compromis.
- **Rôle du `random_state` :** garantit que le découpage est reproductible. Sans lui, chaque ré-exécution donnerait un découpage différent et des perfs différentes. **Toujours fixer `random_state=42`** (ou autre valeur stable) dans le projet.

### Overfit / Sur-apprentissage
- **Définition courte :** le modèle apprend "par cœur" les données d'entraînement, y compris leur bruit, et perd sa capacité à généraliser.
- **Comment le détecter ?** Performance excellente sur le train, dégradée sur le test (ex : R² = 0.95 sur train, R² = 0.4 sur test).
- **Comment le combattre ?**
  - Réduire la complexité du modèle (ex : `max_depth` plus petit sur un arbre).
  - Plus de données (souvent pas possible).
  - Régularisation (Ridge, Lasso pour les modèles linéaires).
  - Validation croisée pour détecter le problème dès la sélection des hyperparamètres.

### Underfit / Sous-apprentissage
- **Définition courte :** le modèle est trop simple pour capturer les patterns des données. Performance médiocre sur train ET test.
- **Comment le détecter ?** R² faible sur train *et* test (ex : R² = 0.2 partout). Souvent : modèle linéaire sur un problème fortement non-linéaire.

---

## 5. Validation croisée (P3 Ch. 4) ⭐ CRITIQUE

- **Définition :** méthode d'évaluation qui découpe le jeu de données en K parties (folds), entraîne le modèle K fois en utilisant tour à tour chaque fold comme jeu de test, puis moyenne les performances.
- **Différence avec un simple train/test split :**
  - Le simple split donne une estimation de performance avec une *forte variance* (dépend du tirage).
  - La CV donne une estimation plus *stable* et permet de mesurer la variabilité (écart-type des scores).
- **K-Fold :** principe = découpe le dataset en K morceaux égaux ; chaque morceau sert de test une fois et de train K-1 fois.
- **Combien de folds en pratique ?** **K=5** est le standard de fait, bon compromis biais/variance/temps de calcul. K=10 est aussi courant.
- **Quand l'utiliser ?**
  - Pour évaluer la robustesse d'un modèle.
  - Pour comparer plusieurs modèles candidats équitablement.
  - À l'intérieur d'une GridSearchCV pour sélectionner les hyperparamètres.

### Méthode `cross_validate` de sklearn
- **Entrée :** un estimateur (modèle), `X`, `y`, le nombre de folds `cv=5`, et la (les) métrique(s) `scoring=['r2', 'neg_mean_absolute_error', 'neg_root_mean_squared_error']`.
- **Sortie :** un dict avec `test_score`, `train_score` (si demandé), `fit_time`, `score_time`. Chaque clé contient un array de K valeurs (une par fold).
- **⚠️ Piège :** sklearn convertit les métriques d'erreur (MAE, RMSE) en *négatif* pour homogénéiser avec R² (où "plus grand = mieux"). Il faut donc utiliser `neg_mean_absolute_error` et prendre la valeur absolue à l'affichage.

---

## 6. GridSearch et hyperparamètres (P3 Ch. 4) ⭐ CRITIQUE

- **Différence paramètre vs hyperparamètre :**
  - **Paramètre :** valeur *apprise* par le modèle pendant `fit()` (ex : coefficients d'une régression linéaire).
  - **Hyperparamètre :** valeur *fixée par le développeur* avant l'entraînement (ex : `n_estimators`, `max_depth`, `learning_rate`).
- **Principe de la GridSearch :** on définit une "grille" de valeurs pour chaque hyperparamètre à tester. La GridSearchCV entraîne le modèle pour *toutes les combinaisons*, évalue chacune par validation croisée, et renvoie la meilleure.
- **Combien de combinaisons en pratique ?** La consigne OC impose **max 500 combinaisons**. Soit par exemple : 5 valeurs × 5 valeurs × 4 valeurs × 5 folds = 500 entraînements. Au-delà, le temps de calcul explose.
- **Risque si trop de combinaisons :** temps de calcul prohibitif (heures, voire jours), surconsommation mémoire, et surtout sur-apprentissage sur le jeu de validation (on finit par optimiser sur le bruit).
- **Pourquoi tester sur petite grille avant ?** Pour estimer le temps d'une combinaison et valider que la pipeline fonctionne avant de lancer la grille complète. La consigne OC recommande explicitement de tester avec ~10 combinaisons d'abord.

---

## 7. Préparation des features (P3 Ch. 3) ⭐ CRITIQUE

### Encoding des variables catégorielles

#### OneHotEncoder
- **Quand l'utiliser ?** Sur des variables catégorielles *nominales* (sans ordre intrinsèque) : type de bâtiment, code postal, quartier…
- **Principe :** crée une colonne binaire par modalité. Pour 3 quartiers `A/B/C`, on obtient 3 colonnes `is_A`, `is_B`, `is_C`.
- **Limite :** explose en nombre de colonnes si la cardinalité est élevée (centaines de modalités → centaines de colonnes).
- **Argument `max_categories`** (sklearn ≥ 1.1) : limite le nombre de modalités encodées, regroupe les rares dans une colonne "infrequent". **Essentiel** pour le projet Seattle sur des colonnes comme `Neighborhood` ou `ZipCode`.

#### LabelEncoder
- **Quand l'utiliser ?** Uniquement sur la *target* d'un problème de classification, ou sur une variable catégorielle *ordinale* (avec ordre : `low/medium/high`).
- **Différence essentielle avec OneHotEncoder :** produit une seule colonne avec des entiers `0, 1, 2…`.
- **Piège classique :** l'utiliser sur des features nominales (ex : `Neighborhood`) → le modèle interprétera à tort que "quartier 3 > quartier 1", ce qui n'a aucun sens.

### Scaling des variables numériques

#### StandardScaler
- **Que fait-il ?** Centre chaque variable sur la moyenne (μ=0) et la met à l'échelle de l'écart-type (σ=1). Formule : `(x - μ) / σ`.
- **Quand est-il nécessaire ?**
  - Régression linéaire (et variantes : Ridge, Lasso).
  - SVM (`SVR`).
  - Modèles à base de distance (k-NN).
  - Réseaux de neurones.
- **Quand est-il inutile ?** Modèles à base d'arbres (DecisionTree, RandomForest, GradientBoosting) — ils sont invariants aux changements d'échelle.

### Feature engineering
- **Définition :** création de *nouvelles* features à partir des features existantes pour aider le modèle.
  *Projet Seattle :* `building_age = 2016 - YearBuilt`, ou `is_multi_use = NumberOfBuildings > 1`.
- **Distinction avec la simple transformation :** transformer (scaler une colonne) ≠ créer (combiner deux colonnes pour en obtenir une troisième porteuse de sens).
- **Data leakage** : utiliser comme feature une variable qui n'est connue *qu'après* le phénomène à prédire, ou qui dépend de la target.
  *Exemple piégeux dans le projet Seattle :* utiliser `Electricity(kBtu)` ou `NaturalGas(kBtu)` comme features pour prédire `SiteEnergyUse(kBtu)` → c'est *exactement* l'addition de ces deux variables. Le modèle aurait un R² ≈ 1, mais ne servirait à rien : il faudrait connaître la consommation pour la prédire.
  *Règle :* seule l'**existence** d'une source d'énergie (binaire `has_natural_gas`) est admissible, pas la valeur mesurée.

---

## 8. Familles de modèles à connaître

### Régression linéaire (`LinearRegression`)
- **Idée intuitive :** trouver la "meilleure droite" (ou hyperplan en N dimensions) qui passe au plus près des points. Modèle de la forme `y = a₁x₁ + a₂x₂ + ... + b`.
- **Hypothèses sous-jacentes :** relation linéaire entre features et target, indépendance des features, distribution résiduelle normale.
- **Avantages :** rapide, interprétable (coefficients = poids de chaque feature), bon baseline.
- **Limites :** ne capture pas les non-linéarités ni les interactions, sensible aux outliers, sensible à la multicolinéarité.
- **Sensible au scaling ?** Pas pour la performance, mais oui pour l'interprétation des coefficients.

### Modèles à base d'arbres (`RandomForestRegressor`, `GradientBoostingRegressor`)
- **Idée intuitive :**
  - *Arbre de décision :* série de questions binaires sur les features ("la surface est-elle > 5000 ?"), qui partitionne l'espace en zones avec une valeur de prédiction par zone.
  - *Random Forest :* moyenne des prédictions de N arbres entraînés sur des sous-échantillons aléatoires.
  - *Gradient Boosting :* construit les arbres séquentiellement, chacun corrigeant les erreurs du précédent.
- **Avantages :** capturent les non-linéarités et interactions, robustes aux outliers, peu d'hypothèses sur les données, fournissent une `feature_importances_` native.
- **Limites :** boîte noire (moins interprétables qu'une régression linéaire), peuvent surapprendre si non régulés, plus lents.
- **Sensibles au scaling ?** **Non**. C'est un de leurs grands atouts pratiques.
- **Permettent la `feature_importance` directement ?** **Oui**, via l'attribut `model.feature_importances_` après `fit()`.

### SVM (`SVR`)
- **Idée intuitive :** cherche le meilleur hyperplan séparateur (avec une "marge" de tolérance ε pour la régression).
- **Sensible au scaling ?** **Très** sensible. Toujours scaler avant.
- **Limites en pratique :** lent sur de grands datasets (> 10 000 lignes), choix du kernel non trivial, peu interprétable.

### DummyRegressor
- **À quoi sert-il ?** Baseline naïve qui prédit toujours la même valeur (moyenne, médiane, constante).
- **Pourquoi en avoir un dans la comparaison ?** Pour disposer d'un *plancher de référence*. Si un modèle ML fait pire que le DummyRegressor, c'est qu'il y a un problème majeur. **Outil indispensable** pour donner un sens aux scores des autres modèles.

---

## 9. Feature Importance et interprétation

### Feature importance native (modèles à arbres)
- **Comment l'obtenir avec sklearn ?** Après `fit()`, accéder à `model.feature_importances_` qui retourne un array de valeurs entre 0 et 1 (la somme vaut 1).
- **Limite (importance = quoi ?)** Mesure à quel point la feature a contribué à *réduire l'impureté* (variance) dans les splits des arbres. Une feature avec beaucoup de modalités peut avoir une importance artificiellement gonflée — à interpréter avec prudence.

### Permutation Importance
- **Quand l'utiliser ?** Pour les modèles qui n'ont pas de `feature_importances_` natif (régression linéaire, SVM). Ou en complément, pour valider les importances natives.
- **Méthode sklearn :** `from sklearn.inspection import permutation_importance`. Principe : mesurer la chute de performance quand on permute aléatoirement les valeurs d'une feature — plus la chute est grande, plus la feature est importante.

### Pour le projet
- **À utiliser sur le modèle retenu uniquement** (= après la GridSearch de la phase 6). Pas avant — sinon on consomme du temps de calcul sur des modèles qui ne seront pas retenus.
- **Format de présentation attendu** : un **histogramme** des features ordonnées par importance décroissante. Top 10 features suffisent pour le PPT.

---

## 10. Auto-test de fin de phase

*À remplir avant de démarrer la phase 2. Coche au fur et à mesure pour vérifier que tu maîtrises chaque point. Si tu cales sur 3+ questions, retourne au cours sur le chapitre concerné.*

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

*Tout ce qui reste flou après la phase 1, et les arbitrages structurants à valider avant la phase 2.*

### ⭐ Question prioritaire — Ambiguïté sur la cible

La consigne contient deux formulations en tension :

- **Brief de Douglas** : *« vous voulez tenter de prédire les émissions de CO2 ET la consommation totale d'énergie »* → laisse entendre deux cibles.
- **Instruction technique** : *« plusieurs colonnes sont éligibles, faites le choix d'une seule et conservez-la pour le projet »* → impose une cible.

**Lecture défendue côté projet (hypothèse de travail) :** cible unique `SiteEnergyUse(kBtu)` (option A — lecture stricte de l'instruction technique, alignée avec le titre du projet, charge minimale).

**Lecture alternative à envisager :** deux cibles `SiteEnergyUse(kBtu)` + `TotalGHGEmissions` (option C — répond pleinement au brief commanditaire, +6h de charge estimées).

**Décision provisoire (stratégie défensive) :** les deux candidates sont conservées dans le dataset jusqu'à arbitrage mentor. Cf. `DECISIONS.md`.

**Question concrète à poser :**
> *« Comment l'évaluation OpenClassrooms interprète-t-elle la phrase "faites le choix d'une seule target" face au brief explicite du commanditaire qui mentionne les deux ? »*

### Arbitrages secondaires à valider

- Périmètre du filtrage non-résidentiel : conserver `Nonresidential COS`, `SPS-District K-12`, `Campus`, `Nonresidential WA` (1 ligne) en plus de `NonResidential` ?
- Drop de `ENERGYSTARScore` pour data leakage : choix défendable ou trop strict ?
- Stratégie de transformation de la target : log-transformation (cf. distribution skewed) acceptable ou autre approche préférée ?

### Questions méthodologiques identifiées en EDA

*Issues de l'analyse de la section 6 (nettoyage qualité) — 1611 lignes finales, 47,7 % du dataset initial.*

- **Mécanisme de manquance (MCAR / MAR / MNAR) :** les 5 colonnes avec NA résiduels (`Outlier`, `YearsENERGYSTARCertified`, `Second/ThirdLargestPropertyUseType` et leurs GFA) sont toutes MAR (NA explicable structurellement). Validation auprès du mentor que cette classification est correcte et que le traitement par feature binaire `has_…` est l'approche attendue.
- **Biais de sélection :** le modèle sera entraîné sur les bâtiments mesurés et déclarés en 2016, mais l'objectif business est de prédire ceux non encore mesurés. Comment quantifier ou défendre la généralisation ? Quelle limite à mentionner en soutenance ?
- **Déséquilibre de distribution sur les catégorielles :** `BuildingType` très déséquilibré (87 % `NonResidential` vs 1 ligne `Nonresidential WA`), `PrimaryPropertyType` modérément (~25 modalités, certaines avec moins de 15 bâtiments comme Hospital ou Laboratory). Quelle approche conseille le mentor : regroupement de modalités rares, `max_categories` sur OneHot, ou conservation telle quelle avec une mention de limite ?

### Questions issues de la lecture du cours

- *À compléter au fil de la lecture du cours.*

---

## Liens rapides

- [Cours complet — Initiez-vous au Machine Learning](https://openclassrooms.com/fr/courses/8063076-initiez-vous-au-machine-learning)
- [Lexique des notions abordées dans le projet](https://openclassrooms.com/fr/paths/1039/projects/1832/2265-ressource-pedagogique---lexique-des-notions-abordees)
- [`cross_validate` — sklearn](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.cross_validate.html)
- [`GridSearchCV` — sklearn](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.GridSearchCV.html)
- [`permutation_importance` — sklearn](https://scikit-learn.org/stable/modules/generated/sklearn.inspection.permutation_importance.html)
- [`OneHotEncoder` — sklearn](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.OneHotEncoder.html)
- [`StandardScaler` — sklearn](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html)