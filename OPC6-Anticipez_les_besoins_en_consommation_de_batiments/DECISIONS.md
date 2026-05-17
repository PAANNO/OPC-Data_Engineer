# Journal des décisions techniques — OPC6

Ce fichier trace les choix structurants du projet : technos, méthodes, architecture, livrables. Il sert de support de défense des choix en soutenance.

**Auteur :** ANNONAY Paul-Alexandre
**Projet démarré le :** 08/05/2026

---

## 08/05/2026 — Découpage en deux notebooks (EDA / Modélisation)

**Contexte :** La consigne OC autorise un ou plusieurs notebooks. Le template fourni mélange les deux phases dans un seul fichier, mais la consigne précise explicitement que si le code de l'EDA est long, on peut créer un second notebook pour l'alléger.

**Options envisagées :**
- **Notebook unique** (suit le template à la lettre).
  - ➕ Pas de découpage à gérer.
  - ➖ Lourd à charger, peu lisible, mélange deux logiques différentes.
- **Deux notebooks séparés** : `01_eda.ipynb` et `02_modelisation.ipynb`.
  - ➕ Lisibilité, séparation claire des phases, plus simple à présenter en soutenance.
  - ➕ Permet de relancer la modélisation sans rejouer toute l'exploration.
  - ➖ Nécessite de propager le dataset nettoyé entre les deux (export d'un CSV intermédiaire).

**Décision :** Deux notebooks séparés.

**Justification :** Recommandation explicite de la consigne pour les EDA longues. Lisibilité accrue pour l'évaluateur. Le dataset nettoyé en sortie de l'EDA sera persisté dans `data/processed/` pour servir d'entrée à la modélisation.

**Alternatives écartées :** Notebook unique — perte de lisibilité.

**Impacts :** Ajout d'un sous-dossier `data/processed/`. Le notebook 1 doit terminer par un `to_csv()` ; le notebook 2 doit commencer par un `read_csv()` sur ce fichier intermédiaire.

---

## 08/05/2026 — Gestion des dépendances avec uv

**Contexte :** La consigne recommande explicitement Poetry pour séparer les dépendances de production et de développement et générer un lockfile exploitable pour le `bentofile.yaml`. uv (Astral, 2024) est une alternative moderne qui couvre ce besoin avec un meilleur niveau de performance et un format de fichier standard PEP 621.

**Options envisagées :**
- **uv** : outil moderne, gère un `pyproject.toml` PEP 621, lockfile `uv.lock`, export direct vers `requirements.txt`.
  - ➕ Format PEP 621 (standard Python officiel), portable.
  - ➕ Performance 10× à 100× supérieure à Poetry.
  - ➕ `uv export --no-dev` produit un `requirements.txt` directement consommable par `bentofile.yaml` via `python.requirements_txt`.
  - ➕ Outil maintenu par Astral (créateurs de Ruff), adoption massive en 2024-2025.
  - ➖ Non explicitement cité par OC (mais la consigne ne l'exclut pas non plus).
- **Poetry** : recommandé par la consigne, séparation prod/dev, `poetry.lock`.
  - ➕ Mention explicite dans la consigne.
  - ➖ Plus lent, format `pyproject.toml` propriétaire (non strict PEP 621).
- **pip + venv + requirements.txt** : plus simple à mettre en place.
  - ➖ Pas de lockfile strict, perte de la séparation prod/dev.

**Décision :** uv.

**Justification :** L'esprit de la recommandation OC (avoir un lockfile pour figer les versions à déployer, séparer prod/dev pour alléger le `bentofile.yaml`) est strictement respecté. uv offre un workflow équivalent à Poetry avec de meilleures performances et un format de fichier standard. L'export vers `requirements.txt` pour le `bentofile.yaml` est même plus direct qu'avec Poetry, qui nécessite de lire manuellement le `poetry.lock` ou d'installer `poetry-plugin-export`.

**Alternatives écartées :**
- Poetry — performance inférieure et format propriétaire ; à savoir défendre en soutenance puisque c'est l'outil cité par la consigne.
- pip seul — perte du lockfile et de la séparation prod/dev nécessaires pour produire un `bentofile.yaml` propre.

**Impacts :**
- `pyproject.toml` au format PEP 621 (groupes `dependencies` et `[dependency-groups]`).
- `uv.lock` versionné dans Git.
- Toutes les commandes documentées préfixées par `uv run` (cf. README section 6).
- Le `bentofile.yaml` pointera vers un `requirements.txt` exporté via `uv export --no-dev --no-hashes`.
- **À défendre en soutenance** : argumentaire prêt sur le choix d'uv vs Poetry (cité par la consigne).

---

## 08/05/2026 — Version de Python : 3.13

**Contexte :** Le template OC déclare `Python 3.11.5` dans ses métadonnées Jupyter, mais ne contraint en rien la version d'exécution. À la date de démarrage du projet (mai 2026), Python 3.13 est sorti depuis octobre 2024 et est la version stable courante. La compatibilité avec la stack BentoML doit être vérifiée car c'est elle qui pilote l'image Docker de déploiement.

**Options envisagées :**
- **Python 3.13** (`>=3.13,<3.14`).
  - ➕ Version stable courante en 2026, supportée par toute la stack (BentoML 1.4.38 publié sous CPython 3.13.7, pandas, numpy, scikit-learn, Pydantic 2.x).
  - ➕ Argument de modernité défendable en soutenance.
  - ➖ Décalage avec la version déclarée dans le template OC (3.11.5) — sans incidence pratique car Jupyter exécute le code dans le kernel, pas dans la version déclarée.
- **Python 3.12** (`>=3.12,<3.13`).
  - ➕ Version largement éprouvée en production.
  - ➖ Pas de gain spécifique vs 3.13 pour ce projet.
- **Python 3.11** (proche du template OC).
  - ➕ Stricte cohérence avec le template fourni.
  - ➖ Version vieillissante (sortie 2022), aucun argument technique pour la conserver.

**Décision :** Python 3.13, contrainte stricte `>=3.13,<3.14` pour stabilité sur la durée du projet.

**Justification :** Stack 100 % compatible (BentoML, pandas, sklearn, Pydantic, uv). Version moderne, défendable en soutenance. La contrainte stricte évite une bascule involontaire vers 3.14 si elle sortait pendant les 6 semaines du projet — important pour garantir la reproductibilité du `uv.lock` et de l'image Docker de déploiement.

**Alternatives écartées :**
- Python 3.12 — équivalent fonctionnel sans bénéfice.
- Python 3.11 — alignement avec le template OC sans valeur technique réelle.

**Impacts :**
- `pyproject.toml` : `requires-python = ">=3.13,<3.14"` + `target-version = "py313"` pour Ruff.
- `.python-version` : `3.13` (lu automatiquement par uv).
- **⚠️ Phase 9 — Déploiement AWS** : par défaut, BentoML utilise la version Python du build environment dans l'image Docker. Mais pour éviter toute ambiguïté, il faudra **déclarer explicitement `python_version: "3.13"`** dans le `bentofile.yaml` (champ `docker.python_version`) ou dans la nouvelle SDK Python (`bentoml.images.Image(python_version="3.13")`). À tracer au moment de la phase 9.
- Le mentor ou l'évaluateur peut signaler le décalage avec le template (3.11.5) — argumentaire à préparer (Jupyter ne se base pas sur cette métadonnée pour l'exécution).

---

## 08/05/2026 — Plateforme Cloud : AWS

**Contexte :** La consigne laisse le choix entre AWS, GCP, Azure, Heroku et autres. Compte AWS déjà disponible côté projet.

**Options envisagées :**
- **AWS** : compte existant, pas de démarche administrative, écosystème riche.
- **GCP Cloud Run** : 300 € de crédits gratuits, mais demanderait de créer un compte.
- **Azure / Heroku** : pas d'argument différenciant ici.

**Décision :** AWS.

**Justification :** Compte déjà disponible — gain de temps significatif sur la phase 9. Évite la création d'un compte Cloud supplémentaire et la gestion des crédits gratuits.

**Alternatives écartées :** GCP — éliminé uniquement pour cause de double compte à gérer, pas sur des critères techniques.

**Impacts :** Choix d'un service AWS pour héberger l'image Docker. À trancher dans une décision dédiée.

---

## 08/05/2026 — Service AWS de déploiement (à arbitrer)

**Contexte :** AWS propose plusieurs services pour héberger une image Docker. La consigne recommande de rester sur des services Cloud "généralistes" et déconseille SageMaker (spécialisé ML, ajustements supplémentaires).

**Options envisagées :**
- **AWS App Runner** : déploiement direct depuis ECR, scaling auto, HTTPS natif, pricing simple.
  - ➕ Le plus simple : on pousse l'image, on récupère une URL HTTPS.
  - ➕ Idéal pour une démo soutenance.
  - ➖ Coût mensuel un peu plus élevé qu'ECS Fargate à charge constante.
- **AWS ECS Fargate** : container orchestration sans serveur.
  - ➕ Plus de contrôle, plus représentatif d'un usage industriel.
  - ➖ Plus de configuration (ALB, security groups, target groups, task definitions).
- **AWS Elastic Beanstalk** : option historique, fonctionne avec Docker.
  - ➖ Moins moderne, plus lourd à mettre en place.
- **AWS Lightsail Containers** : low-cost, simple.
  - ➕ Très simple, prix forfaitaire.
  - ➖ Moins "professionnel" en démo.

**Décision :** *À trancher — hypothèse de travail : **App Runner**.*

**Justification (à compléter à la phase 9) :** App Runner est le service AWS le plus aligné avec le besoin (un container, une URL HTTPS), avec le moins de friction technique, ce qui maximise les chances d'avoir une démo qui fonctionne le jour de la soutenance.

**Alternatives écartées :** SageMaker (déconseillé par la consigne) ; ECS Fargate (sur-ingénierie pour un projet de formation) ; Lightsail (perçu comme moins pro).

**Impacts :** Conditionne le contenu de `bentofile.yaml`, les commandes CLI et le coût total. Coût à monitorer pour ne pas dépasser quelques euros sur le mois.

---

## 08/05/2026 — Validation des entrées API : Pydantic

**Contexte :** La consigne autorise Pydantic ou Pandera pour valider la donnée envoyée à l'API.

**Options envisagées :**
- **Pydantic** : intégration native avec BentoML, validation par classes, très répandu, retourne un HTTP 422 propre en cas de violation.
- **Pandera** : pensé pour la validation de DataFrames, plus naturel si l'entrée est un batch de plusieurs bâtiments.

**Décision :** Pydantic.

**Justification :** L'API recevra typiquement une seule ligne (un bâtiment à prédire), ce qui correspond exactement au cas d'usage de Pydantic. Intégration plus idiomatique avec BentoML, documentée dans le quickstart officiel.

**Alternatives écartées :** Pandera — pertinent uniquement pour des entrées en lots, hors scope ici.

**Impacts :** Création d'un fichier `src/api/schemas.py` définissant la classe `BuildingInput` avec contraintes (types, bornes, énumérations).

---

## 08/05/2026 — Périmètre du filtrage : bâtiments non résidentiels stricts

**Contexte :** La consigne demande de ne traiter que les bâtiments **non destinés à l'habitation**. Le dataset Seattle 2016 contient 8 valeurs distinctes pour `BuildingType`, dont plusieurs ambiguës.

**Options envisagées (à valider avec mentor) :**

Conserver :
- `NonResidential` (1460 lignes) — clair.
- `Nonresidential COS` (85 lignes) — City Of Seattle, non résidentiel.
- `Nonresidential WA` (1 ligne) — anomalie isolée, à conserver ou exclure selon dispersion.
- `SPS-District K-12` (98 lignes) — écoles, non résidentiel.
- `Campus` (24 lignes) — universités/grands campus, non résidentiel.

Exclure :
- `Multifamily LR (1-4)` (1018 lignes)
- `Multifamily MR (5-9)` (580 lignes)
- `Multifamily HR (10+)` (110 lignes)

**Décision :** *Hypothèse de travail — conserver les 5 catégories non résidentielles ci-dessus, soit ~1668 lignes avant nettoyage.*

**Justification (à valider) :** Conformité stricte au brief de Douglas. La catégorie "Multifamily" désigne des immeubles d'habitation collectifs, donc à exclure. Les écoles et campus ne sont pas des habitations.

**Alternatives écartées :** Garder uniquement `NonResidential` strict — perte de ~200 bâtiments légitimes (écoles, campus) ; trop restrictif.

**Impacts :** Volume de données initial divisé par ~2. Nécessite de bien suivre les comptages avant/après chaque filtrage pour ne pas perdre trop de données.

---

## 08/05/2026 — Choix de la target — STRATÉGIE DÉFENSIVE (À VALIDER MENTOR)

**Contexte :** La consigne présente une ambiguïté structurelle sur la cible :
- **Brief de Douglas** (énoncé du commanditaire) : *« vous voulez tenter de prédire les émissions de CO2 ET la consommation totale d'énergie de bâtiments non destinés à l'habitation »* → laisse entendre **deux cibles**.
- **Instruction technique plus loin** : *« plusieurs colonnes sont éligibles, faites le choix d'une seule et conservez-la pour le projet »* → impose **une seule cible**.

Ces deux formulations sont en tension. Le titre du projet (« Anticipez les besoins en consommation ») oriente plutôt vers la consommation, mais ne lève pas l'ambiguïté du brief commanditaire.

**Options envisagées :**

- **A — Cible unique `SiteEnergyUse(kBtu)`** (consommation totale d'énergie).
  - ➕ Aligné avec le titre du projet et la lecture stricte de "faites le choix d'une seule".
  - ➕ Plus directement liée aux features structurelles (la consommation découle de la structure du bâtiment ; les émissions dépendent en plus du mix énergétique).
  - ➕ Distribution claire (99,8 % complétude sur dataset brut).
  - ➕ Charge de modélisation minimale.
  - ➖ Ne répond que partiellement au brief de Douglas (réponse fragile face à la question *« et pour les émissions ? »* en soutenance).

- **B — Cible unique `TotalGHGEmissions`** (émissions de CO2).
  - ➕ Aligné avec l'objectif municipal de neutralité carbone 2050.
  - ➖ Dépend du mix énergétique réel, donc plus indirectement liée aux features structurelles.
  - ➖ Quelques valeurs négatives observées (-0,80) à investiguer.
  - ➖ Contredit le titre du projet.

- **C — Modélisation des deux cibles** (en multi-output ou en deux pipelines indépendantes).
  - ➕ Répond pleinement au brief de Douglas.
  - ➕ Multi-output natif supporté par sklearn (RandomForest, etc.).
  - ➖ Lecture forte de "faites le choix d'une seule" → risque pédagogique.
  - ➖ Charge de modélisation +6h estimées (phases 5+6+8).
  - ➖ Métrique d'optimisation à arbitrer (R² moyen ? R² minimum ? pondéré ?) pour la GridSearch.

- **D — Target engineering** (cible composite type `emissions/consommation`).
  - ➖ **Hors périmètre de la consigne** : ne répond ni à *« prédire la consommation »* ni à *« prédire les émissions »*.
  - ➖ Perte d'interprétabilité métier (un ratio n'est pas exploitable par Douglas).
  - ➖ Le composite dépend du mix énergétique, non capturé par les features structurelles.
  - **Option explicitement écartée** (cf. discussion du 16/05).

**Décision provisoire : stratégie défensive.**

On conserve les **deux candidates** (`SiteEnergyUse(kBtu)` et `TotalGHGEmissions`) dans le dataset jusqu'à la 1ʳᵉ session mentor. Les lignes droppées sont uniquement celles qui n'ont **aucune** des deux targets renseignées (drop sur la condition `notna() OR notna()`, pas `AND`). Cela laisse les options A, B et C toutes ouvertes sans coût de travail à court terme.

**Hypothèse de travail privilégiée :** option A (`SiteEnergyUse(kBtu)`) — lecture la plus stricte de la consigne, charge minimale, alignée avec le titre du projet.

**Verdict mentor attendu sur :** lecture à retenir pour "une seule target" (option A) vs "deux cibles" (option C). La décision finale doit être actée avant la fin de la phase 2 (au plus tard 22/05/2026).

**Justification de la stratégie défensive :** une ambiguïté de spec n'est pas à trancher unilatéralement par le développeur. La pratique professionnelle est de remonter la question au commanditaire (ici représenté par le mentor). En attendant, garder les options ouvertes coûte zéro complexité (une colonne en plus dans le DataFrame) et préserve toute la valeur de l'EDA déjà produite.

**Alternatives écartées :**
- Target engineering (option D) : hors périmètre de la consigne, interprétabilité dégradée.

**Impacts :**
- Phase 2 (EDA) : poursuivie sans contrainte — l'analyse des deux candidates produit l'information nécessaire à n'importe quelle décision finale.
- Phases 3-4 (feature engineering, préparation) : pipeline de features **identique** dans tous les scénarios (les features ne dépendent pas de la target).
- Phase 5-6 (modélisation, optimisation) : **conditionnelle au verdict mentor**. Si option A ou B : ~50h budgétées. Si option C : +6h (multi-output ou pipeline doublé).
- Phase 8 (API) : si option C, un endpoint qui renvoie 2 valeurs OU 2 endpoints.
- **À défendre en soutenance** : le fait d'avoir identifié l'ambiguïté et de l'avoir levée avec le mentor est en soi un point fort méthodologique (lecture critique de la spec).

---

## 08/05/2026 — Données : 2016 uniquement

**Contexte :** Seattle Open Data publie des données 2015 à présent. La consigne pointe explicitement le fichier 2016.

**Options envisagées :**
- **2016 uniquement** : conforme à la consigne.
- **2015 + 2016** : doublerait le volume mais introduit une dimension temporelle non demandée.

**Décision :** 2016 uniquement.

**Justification :** Conformité stricte à la consigne. La dimension temporelle est hors scope.

**Alternatives écartées :** 2015 + 2016 — sortie de scope.

**Impacts :** Aucune feature temporelle inter-année. À mentionner comme limite (le modèle ne capture pas les évolutions annuelles).

---

## 08/05/2026 — Structure du dépôt

**Contexte :** Besoin d'une organisation claire séparant l'exploration (notebooks), le code de production (API), le déploiement, et la documentation.

**Options envisagées :**
- Structure flat (tout à la racine) — illisible quand le projet grossit.
- Structure modulaire `notebooks/ src/ deployment/ docs/ data/` — séparation nette.

**Décision :** Structure modulaire (cf. README section 5).

**Justification :** Lisibilité, séparation des concerns, prêt pour uv et BentoML.

**Alternatives écartées :** Structure flat.

**Impacts :** Imports Python à organiser (`src/api`, `src/training`). Le `bentofile.yaml` devra inclure explicitement les bons sous-modules.

---

## 16/05/2026 — Traitement de `ENERGYSTARScore` et `YearsENERGYSTARCertified`

**Contexte :** Lors de la phase 2 (EDA), deux colonnes liées au programme ENERGY STAR de l'EPA ont attiré l'attention par leur taux de remplissage atypique (75 % pour `ENERGYSTARScore`, 4 % pour `YearsENERGYSTARCertified`). Une investigation a été menée pour distinguer NA structurels et NA manqués, et pour décider du traitement de ces colonnes.

**Investigation menée dans `01_eda.ipynb` (section 2.bis) :**
1. Tous les bâtiments certifiés ont-ils un score ? **117 / 119 = 98 % oui** → la certification s'appuie effectivement sur le score.
2. Les certifiés ont-ils un score ≥ 75 (seuil EPA officiel) ? **Médiane=89, Q1=81** → conforme à la règle. Un seul cas atypique à score 3 (certification historique vraisemblablement non maintenue).
3. Les NA de `ENERGYSTARScore` sont-ils aléatoires ou structurels ? **Structurels.** Les types d'usage non couverts par le programme EPA (Self-Storage Facility, University, Restaurant, Laboratory) ont 0 % de score, alors que les types couverts (Hospital, Hotel, Office, Supermarket…) ont 90-100 % de score. Les NA sont donc **structurellement liés au type d'usage**, pas aléatoires.

**Options envisagées pour `ENERGYSTARScore` :**
- **A — Feature numérique brute** : garder telle quelle, imputer les NA.
  - ➖ **Data leakage : le score EPA est calculé à partir de la consommation énergétique mesurée du bâtiment** — c'est donc une variable directement dérivée de la target `SiteEnergyUse(kBtu)`.
  - ➖ 25 % de NA structurels → toute imputation serait artificielle.
- **B — Feature binaire `has_energy_star_score`** : signale uniquement l'éligibilité.
  - ➕ Pas de NA à gérer.
  - ➖ N'apporte rien de plus que `PrimaryPropertyType` (l'éligibilité est déjà déterminée par le type d'usage).
- **C — Drop colonne** : retirer totalement la variable.
  - ➕ Évite le data leakage.
  - ➕ Cohérent avec la règle générale du projet (pas de variable dérivée de la target).
  - ➖ Perte d'information apparente — à défendre en soutenance.

**Décision pour `ENERGYSTARScore` : drop colonne.**

**Justification :** le data leakage est la raison déterminante. Le score ENERGY STAR est, par construction, une variable post-mesure de la consommation : l'utiliser comme feature reviendrait à utiliser la target (ou une transformation directe de la target) pour prédire la target. C'est précisément le piège que la consigne OC nous demande d'éviter. Le test d'inclusion serait trompeur : le modèle aurait un R² artificiellement élevé sans réelle capacité prédictive sur des bâtiments non encore mesurés (qui est tout l'enjeu du projet).

**Options envisagées pour `YearsENERGYSTARCertified` :**
- **A — Garder les années** : `2014, 2015, 2016` comme features temporelles.
  - ➖ 96 % de NA, multi-valeurs, complexe à exploiter.
- **B — Transformer en feature binaire `is_energy_star_certified`** : `notna()` → True/False.
  - ➕ Information administrative légitime (démarche volontaire du propriétaire, pas une mesure directe de consommation).
  - ➕ Simple, lisible, peu de risque de leakage indirect.
- **C — Drop colonne** : trop peu remplie (4 %) pour être utile.
  - ➖ Perte d'une information potentiellement discriminante (un bâtiment certifié = un bâtiment vraisemblablement bien géré).

**Décision pour `YearsENERGYSTARCertified` : transformer en feature binaire `is_energy_star_certified`, puis drop la colonne originale.**

**Justification :** la certification est un statut administratif (démarche volontaire du propriétaire), distinct du score technique. Elle reflète des pratiques de gestion du bâtiment (souvent corrélées à des bâtiments bien entretenus, modernes, suivis), pas une mesure directe de la consommation. C'est donc une feature légitime. La binarisation simplifie le traitement et n'écarte qu'une information marginale (les années précises de certification, qui n'apportent pas grand-chose pour prédire une consommation 2016).

**Alternatives écartées :**
- `ENERGYSTARScore` comme feature numérique : data leakage rédhibitoire.
- `ENERGYSTARScore` comme feature binaire `has_score` : redondant avec `PrimaryPropertyType`.
- Drop de `YearsENERGYSTARCertified` : perte d'information utile, alors que la binarisation est triviale.

**Impacts :**
- 2 colonnes du dataset retirées (`ENERGYSTARScore`, `YearsENERGYSTARCertified`), 1 colonne ajoutée (`is_energy_star_certified`).
- **À défendre en soutenance** : c'est un choix structurant. Un évaluateur peut challenger en disant *« vous avez retiré une variable qui aurait pu améliorer la perf »*. Réponse type : *« Oui, et c'est précisément pourquoi : un score ENERGY STAR élevé est mathématiquement corrélé à une consommation basse car il est calculé à partir d'elle. Garder cette feature aurait gonflé artificiellement le R² sans bénéfice prédictif réel sur des bâtiments non encore mesurés — qui est précisément le cas d'usage de notre API en production. »*

---

## 16/05/2026 — Traitement de `ComplianceStatus` et `DefaultData`

**Contexte :** En phase 2 (EDA, section 6), deux colonnes liées à la qualité déclarative apparaissent :
- `ComplianceStatus` : catégorielle, valeurs `Compliant` (1546) et `Error - Correct Default Data` (85).
- `DefaultData` : booléenne, indique si des valeurs par défaut ont été utilisées.

Le libellé `Error - Correct Default Data` est ambigu (« erreur » dans le nom, mais signifie en réalité « données corrigées par valeurs par défaut »). Une analyse a été menée pour décider du sort des 85 bâtiments concernés (5 % du dataset à ce stade).

**Investigations menées dans `01_eda.ipynb` :**
1. **Croisement `ComplianceStatus × DefaultData` :** correspondance bijective parfaite. `Compliant` ⇔ `DefaultData=False`, `Error - Correct Default Data` ⇔ `DefaultData=True`. **Les deux colonnes mesurent exactement la même chose.**
2. **Comparaison des distributions des deux groupes :**
   - Médiane `SiteEnergyUse` : 2,73 M kBtu (Compliant) vs 2,15 M kBtu (Error) → très proche.
   - Médiane `PropertyGFATotal` : 48 125 sqft (Compliant) vs 57 298 sqft (Error) → très proche.
   - Différence sur les moyennes et écarts-types : explicable par la présence de très gros bâtiments uniquement dans le groupe Compliant (logique : les très gros bâtiments ont des équipes dédiées).

**Options envisagées :**
- **A — Drop des 85 bâtiments `Error - Correct Default Data` :** conservatisme. Perte de 5 % du dataset.
- **B — Garder les 85 bâtiments + drop de `ComplianceStatus` (redondance) :** maximum d'observations, `DefaultData` reste exploitable comme feature.
- **C — Garder + ajouter `is_default_data` comme feature explicite :** très proche de B. Pas nécessaire puisque `DefaultData` existe déjà.

**Décision : option B.** Conserver les 85 bâtiments, drop de la colonne `ComplianceStatus` (redondante), conservation de `DefaultData` comme feature potentielle.

**Justification :**
- Le libellé `Error - Correct Default Data` désigne des données **corrigées par l'autorité émettrice** (Seattle), pas des données invalides. Si Seattle les publie dans le dataset officiel, c'est qu'elle les considère comme exploitables.
- Aucun biais systématique détecté : les médianes des deux groupes sont très proches.
- 85 bâtiments représentent 5 % du dataset — perte non négligeable à ce stade du projet.
- `ComplianceStatus` est strictement redondante avec `DefaultData` : la garder ne servirait à rien.

**Alternatives écartées :**
- Drop des 85 bâtiments : conservatisme infondé statistiquement, perte de volumétrie.
- Garder les deux colonnes : redondance évidente, gaspillage de dimensionnalité.

**Impacts :**
- Dataset conservé à 1 631 lignes au lieu de 1 546 (avant drop des NA résiduels).
- Colonne `ComplianceStatus` retirée du dataset.
- `DefaultData` conservé pour la modélisation.
- **À défendre en soutenance** : un évaluateur peut challenger en disant *« vous avez gardé des données marquées Error »*. Réponse type : *« Le libellé Error correspond à des données corrigées par Seattle avec des valeurs par défaut, pas à des données invalides. L'analyse comparative montre des distributions cohérentes entre les deux groupes. Les retirer aurait privé le modèle de 5 % d'observations sans justification statistique. »*

---