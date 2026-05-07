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
- `pyproject.toml` : `requires-python = ">=3.13,<3.14"` + `target-version = "py313"`.
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

## 08/05/2026 — Choix de la target (À TRANCHER avec mentor)

**Contexte :** La consigne précise que plusieurs colonnes sont candidates et qu'**une seule** doit être retenue pour tout le projet. Le brief de Douglas mentionne explicitement la consommation **et** les émissions, mais le titre du projet et la formulation centrale insistent sur la consommation. La précision apportée le 08/05/2026 confirme que la target sera une colonne agrégée (pas une source d'énergie individuelle).

**Options envisagées :**
- **`SiteEnergyUse(kBtu)`** — consommation totale d'énergie sur site.
  - ➕ Aligné avec le titre du projet.
  - ➕ Plus directement liée aux features structurelles.
  - ➕ 99,8 % de complétude (3371 / 3376).
  - ➖ Distribution très skewed (min=0, médiane=1,8M, max=874M) → log-transformation à prévoir.
  - ➖ 18 valeurs nulles à investiguer (bâtiments vides ? erreurs ?).
- **`TotalGHGEmissions`** — émissions totales de gaz à effet de serre.
  - ➕ Aligné avec l'objectif "neutralité carbone 2050".
  - ➕ 99,7 % de complétude.
  - ➖ Dépend du mix énergétique réel, donc plus indirectement liée aux features structurelles.
  - ➖ Quelques valeurs négatives (-0,80) à investiguer.
- **Modéliser les deux séparément.**
  - ➖ Hors scope strict (la consigne demande une seule target).

**Décision :** *À trancher lors de la 1ʳᵉ session mentor (semaine S1) — hypothèse de travail : `SiteEnergyUse(kBtu)`.*

**Justification (à compléter) :** Le titre du projet (« Anticipez les besoins en consommation ») et la formulation centrale de l'énoncé désignent la consommation comme cible principale. Les émissions sont une conséquence du mix énergétique, pas directement de la structure du bâtiment.

**Alternatives écartées :** `TotalGHGEmissions` — dépendance plus indirecte aux features structurelles ; à mentionner en limite/perspective dans la soutenance. Double modélisation — hors scope.

**Impacts :** Conditionne tout le feature engineering, le choix des métriques (R², MAE, RMSE), et la communication métier en soutenance. À acter définitivement avant la fin de la phase 2.

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