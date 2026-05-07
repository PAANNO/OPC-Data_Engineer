# OPC6-Anticipez_les_besoins_en_consommation_de_batiments

> Projet n°6 de la formation Data Engineer OpenClassrooms — *Prédire la consommation énergétique des bâtiments non résidentiels de Seattle et exposer le modèle via une API déployée sur AWS.*

**Statut du projet :** 🟡 En cours
**Date de démarrage :** 08/05/2026
**Date cible de rendu :** 19/06/2026
**Date de soutenance :** À planifier

---

## 1. Présentation

### Contexte métier

Data Engineer pour la **ville de Seattle**, dans le cadre de l'objectif municipal de neutralité carbone à 2050. L'équipe suit la consommation et les émissions des **bâtiments non destinés à l'habitation**. Les relevés terrain (2016) sont coûteux : on cherche à prédire la consommation des bâtiments non encore mesurés à partir de leurs caractéristiques structurelles. Le projet est piloté par **Douglas (Project Lead)** et bénéficie d'une forte visibilité auprès de la mairie.

### Problématique

Peut-on prédire la consommation totale d'énergie d'un bâtiment non résidentiel à partir de ses seules caractéristiques structurelles (taille, usage, année de construction, localisation), avec une fiabilité suffisante pour éviter des relevés coûteux ?

### Objectifs

- Réaliser une analyse exploratoire ciblée sur les bâtiments non résidentiels.
- Produire un feature engineering pertinent sans data leakage.
- Comparer plusieurs modèles supervisés de régression et en optimiser un.
- Identifier les facteurs influençant le plus le modèle.
- Exposer le modèle via une API BentoML déployée sur AWS, avec validation des entrées via Pydantic.
- Présenter la démarche et démontrer l'API en direct lors de la soutenance.

---

## 2. Compétences évaluées

- Préparer et transformer des données afin de les adapter au modèle d'apprentissage.
- Entraîner un modèle d'apprentissage.
- Évaluer le modèle d'apprentissage.
- Identifier ou créer une API compatible et l'intégrer pour permettre l'accès aux résultats.
- Exposer les résultats aux directions (via une API) en vue de leur exploitation.
- Présenter ses résultats.

---

## 3. Livrables attendus

| # | Livrable | Format | Mission | Statut |
|---|---|---|---|---|
| 1 | Notebooks d'analyse exploratoire et de modélisation (basés sur le template fourni) | `.ipynb` (×2) | Partie 1 | ⚪ |
| 2 | Support de présentation (méthodologie + résultats) | `.pptx` | Partie 1 | ⚪ |
| 3 | Scripts Python de l'API (logique BentoML + validation Pydantic) | `.py` | Partie 2 | ⚪ |
| 4 | Fichier de déploiement BentoML (service, code, modèle, dépendances) | `bentofile.yaml` | Partie 2 | ⚪ |

**Conditionnement final :** zip `Anticipez_les_besoins_en_consommation_de_batiments_ANNONAY_Paul-Alexandre` contenant chaque livrable au format `ANNONAY_Paul-Alexandre_<n>_<nom_livrable>_052026`.

Légende statut : ⚪ Non démarré · 🟡 En cours · 🟢 Terminé · 🔵 En relecture

---

## 4. Matrice consigne / livrables / preuves

| Élément de consigne | Livrable associé | Preuve à fournir | Statut |
|---|---|---|---|
| Filtrage strict des bâtiments non résidentiels | `01_eda.ipynb` | Justification + comptage avant/après (sur `BuildingType`) | ⚪ |
| Analyse exploratoire complète | `01_eda.ipynb` | Section "Analyse exploratoire" complétée + insights synthétisés | ⚪ |
| Choix d'une seule target documenté | `01_eda.ipynb` + `DECISIONS.md` | Distribution + justification du choix entre `SiteEnergyUse(kBtu)` et `TotalGHGEmissions` | ⚪ |
| Feature engineering sans data leakage | `02_modelisation.ipynb` | Section "Feature Engineering" + entrée `DECISIONS.md` listant les features rejetées | ⚪ |
| Préparation des features (outliers, encodage, scaling) | `02_modelisation.ipynb` | Section "Préparation des features" complétée | ⚪ |
| Comparaison de plusieurs modèles supervisés | `02_modelisation.ipynb` | Section "Comparaison de modèles" + fonction de modélisation refactorisée | ⚪ |
| Optimisation (GridSearchCV ≤ 500 combinaisons) | `02_modelisation.ipynb` | Section "Optimisation" + meilleurs hyperparamètres consignés | ⚪ |
| Feature importance | `02_modelisation.ipynb` | Histogramme des features les plus impactantes | ⚪ |
| Présentation pro de la démarche | Livrable 2 (.pptx) | Slides : contexte, EDA, démarche, perfs, features clés | ⚪ |
| API définie en local (BentoML) | `src/api/service.py` | Lancement via `bentoml serve`, requêtes Swagger fonctionnelles | ⚪ |
| Validation des entrées API (Pydantic) | `src/api/schemas.py` | Test avec valeurs incohérentes refusées (HTTP 422) | ⚪ |
| `bentofile.yaml` complet | `deployment/bentofile.yaml` | Service, code source, modèle, dépendances, image Docker construite | ⚪ |
| Déploiement AWS + URL HTTPS accessible | Démo soutenance | Lien HTTPS testé, requête réussie en live, validation testée en live | ⚪ |
| Fiche d'autoévaluation OC complétée | Hors livrable noté | PDF rempli avant la session mentor finale | ⚪ |

---

## 5. Organisation du dépôt

```
OPC6-Anticipez_les_besoins_en_consommation_de_batiments/
├── README.md                       # Ce fichier
├── DECISIONS.md                    # Journal des décisions techniques
├── consigne.md                     # Consigne OpenClassrooms originale
├── pyproject.toml                  # Gestion des dépendances (uv, PEP 621)
├── uv.lock                         # Lockfile des dépendances (versionné)
├── .python-version                 # Version Python épinglée par uv
├── .gitignore
├── data/
│   └── raw/
│       └── 2016_Building_Energy_Benchmarking.csv  # Non versionné si > seuil
├── notebooks/
│   ├── 01_eda.ipynb                # Analyse exploratoire (template OC complété)
│   └── 02_modelisation.ipynb       # Feature engineering + modélisation (template OC complété)
├── src/
│   ├── api/
│   │   ├── __init__.py
│   │   ├── service.py              # Logique BentoML + endpoints
│   │   └── schemas.py              # Validation Pydantic
│   └── training/
│       ├── __init__.py
│       └── train.py                # Script d'entraînement + sauvegarde du Bento
├── deployment/
│   └── bentofile.yaml              # Configuration du build Docker
├── docs/
│   ├── presentation.pptx           # Livrable 2
│   └── autoevaluation.pdf          # Fiche OC complétée
└── models/                         # Artefacts modèles locaux (optionnel, non versionné)
```

*Structure susceptible d'évoluer — voir `DECISIONS.md` pour toute modification.*

---

## 6. Environnement technique

- **Système :** Windows 11 Pro
- **IDE :** VS Code
- **Langage :** Python 3.x
- **Outils principaux :** pandas, scikit-learn, **BentoML**, **Pydantic**, Docker, **AWS** (compte existant)
- **Gestion des dépendances :** **uv** (`pyproject.toml` au format PEP 621, `uv.lock`)

### Installation et exécution

```bash
# Cloner le dépôt
git clone <url-du-repo>
cd OPC6-Anticipez_les_besoins_en_consommation_de_batiments

# Synchronisation de l'environnement avec uv (crée .venv automatiquement)
uv sync

# Lancement des notebooks
uv run jupyter lab

# Entraînement du modèle (sauvegarde via BentoML)
uv run python src/training/train.py

# Lancement de l'API en local
uv run bentoml serve src.api.service:svc

# Build et conteneurisation
uv run bentoml build
uv run bentoml containerize <bento_tag>

# Export des dépendances figées (pour le bentofile.yaml)
uv export --no-dev --no-hashes > deployment/requirements.txt
```

---

## 7. Étapes de réalisation

| Phase | Description | Charge | Statut | Date cible |
|---|---|---|---|---|
| 0 | Cadrage, récupération données + template, env uv | 3 h | 🟢 | 08/05 |
| 1 | Cours OC "Initiez-vous au ML" (chapitres ciblés) | 6 h | ⚪ | 11/05 |
| 2 | Analyse exploratoire (`01_eda.ipynb`) | 8 h | ⚪ | 17/05 |
| 3 | Feature engineering (`02_modelisation.ipynb`) | 6 h | ⚪ | 20/05 |
| 4 | Préparation des features pour la modélisation | 4 h | ⚪ | 22/05 |
| 5 | Comparaison de modèles + refactoring | 6 h | ⚪ | 25/05 |
| 6 | Optimisation GridSearch + feature importance | 5 h | ⚪ | 28/05 |
| 7 | Préparation du PPT (livrable 2) | 5 h | ⚪ | 31/05 |
| 8 | API BentoML en local + validation Pydantic | 5 h | ⚪ | 04/06 |
| 9 | `bentofile.yaml`, build Docker, déploiement AWS, tests | 6 h | ⚪ | 11/06 |
| 10 | Fiche d'autoévaluation, relecture, point mentor final | 3 h | ⚪ | 16/06 |
| 11 | Préparation soutenance (plan, anticipation des questions) | 3 h | ⚪ | 18/06 |
| | **Total estimé** | **~60 h** *(la consigne annonce 50 h, marge prudente)* | | **Rendu : 19/06** |

---

## 8. Suivi d'avancement

*Mise à jour à chaque étape importante du projet.*

- **08/05/2026** — Démarrage du projet. Création du repo, mise en place de uv, copie de la consigne, du template OC et du dataset Seattle 2016.
- **08/05/2026** — 🟢 **Phase 0 terminée.** Environnement uv opérationnel sur Python 3.13.13 ; stack ML (pandas 2.3.3, scikit-learn 1.8.0, BentoML 1.4.39, Pydantic 2.13.4) installée et validée par import.

---

## 9. Décisions techniques

Les choix structurants (target retenue, périmètre du filtrage, librairies, modèle final, stratégie d'encodage, configuration AWS…) sont tracés dans [`DECISIONS.md`](./DECISIONS.md).

---

## 10. Points de vigilance et limites

- **Data leakage** : ne jamais utiliser de variables dérivées de la consommation observée comme features (consommations électricité/gaz mesurées, EUI, GHG si la target est l'énergie). Seule l'**existence** d'une source d'énergie est admissible.
- **Périmètre** : restreindre strictement aux bâtiments non résidentiels — exclure tous les `Multifamily*`. Vérifier le comptage avant/après filtrage.
- **Volume après nettoyage** : ne pas dropna agressivement. Le dataset compte ~1670 bâtiments non résidentiels avant nettoyage ; viser un dataset final ≥ 1300 lignes pour rester confortable en modélisation.
- **Reproductibilité** : `random_state` fixé partout (split, modèles, GridSearch).
- **Performance ≠ objectif principal** : OC précise que la performance n'est pas évaluée — c'est la rigueur de la démarche qui compte.
- **Concepts BentoML à éviter** : pas de `Runner` (archivé), pas de `bentoctl` (archivé).
- **Coût AWS** : arrêter le service après les tests / soutenance pour ne pas consommer le compte. Documenter les commandes d'arrêt.
- **Limites du modèle** à expliciter en soutenance : généralisation à des bâtiments hors Seattle non garantie, données 2016 uniquement, biais d'échantillonnage des bâtiments mesurés.

---

## 11. Préparation de la soutenance

### Plan de présentation (15 min — cible)

1. Contexte Seattle et problématique métier (≈ 1 min)
2. Présentation du jeu de données et insights clés de l'EDA (≈ 3 min)
3. Démarche de préparation et de feature engineering (≈ 3 min)
4. Comparaison des modèles, optimisation, performances du modèle retenu (≈ 3 min)
5. Features les plus impactantes (≈ 2 min)
6. **Démo live de l'API déployée sur AWS + test de la validation Pydantic (≈ 3 min)**

### Questions probables du mentor / évaluateur (= Douglas)

- *Pourquoi cette target plutôt que l'autre ?* → renvoi vers `DECISIONS.md`
- *Comment as-tu écarté le data leakage ?* → liste des features rejetées et justification
- *Pourquoi ce modèle final ?* → tableau comparatif des perfs en cross-validation
- *Comment ton code garantit la reproductibilité ?* → `random_state`, uv (`uv.lock`), `bentofile.yaml`
- *Comment ton API gère une donnée incohérente ?* → démo live d'un payload invalide
- *Pourquoi avoir choisi AWS plutôt qu'un autre Cloud ?* → renvoi vers `DECISIONS.md`
- *Que se passe-t-il si on entraîne sur 2017 ?* → limites de généralisation
- *Pourquoi ces hyperparamètres dans la GridSearch ?* → grille restée sous 500 combinaisons + justification

### Points faibles à anticiper

- *À identifier en cours de projet — par exemple : faible volume après nettoyage, MAE jugée élevée, perfs inégales selon les segments de bâtiments, etc.*

---

## 12. Ressources

- [Consigne OpenClassrooms complète](./consigne.md)
- [Données — Seattle 2016 Building Energy Benchmarking](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/Data_Scientist_P4/2016_Building_Energy_Benchmarking.csv)
- [Source données — Seattle Open Data](https://data.seattle.gov/Built-Environment/Building-Energy-Benchmarking-Data-2015-Present/teqw-tu6e/about_data)
- [Notebook template OC](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/922_Data+Engineer/922_P6/template_modelistation_supervisee.ipynb)
- [Fiche d'autoévaluation OC](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/922_Data+Engineer/922_P6/P6_+Fiche+d'auto-e%CC%81valuation.pdf)
- [Cours OC — Initiez-vous au Machine Learning](https://openclassrooms.com/fr/courses/8063076-initiez-vous-au-machine-learning)
- [Documentation BentoML](https://docs.bentoml.org/en/latest/get-started/hello-world.html)
- [Documentation Pydantic](https://docs.pydantic.dev/latest/)
- [Documentation scikit-learn — `cross_validate`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.cross_validate.html)
- [Documentation scikit-learn — `GridSearchCV`](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.GridSearchCV.html)
- [AWS — Push d'une image Docker vers ECR](https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html)

---

## 13. Auteur

ANNONAY Paul-Alexandre — Formation Data Engineer OpenClassrooms (échéance 02/05/2027)