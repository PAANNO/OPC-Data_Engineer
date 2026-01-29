# OPC2 – Analysez les données de systèmes éducatifs

Dépôt de travail pour le **projet 2** du parcours **Data Engineer – OpenClassrooms**.

Ce projet a une durée estimée de **30 heures** et a pour objectif de renforcer mes fondamentaux de **Python pour la Data Science** en analysant des **données de systèmes éducatifs** à l’aide de **notebooks Jupyter**.

## 🎯 Objectifs du projet

Résumé en quelques lignes :

- Analyser un jeu de données issu de systèmes éducatifs à l’aide de Python et de Jupyter Notebook.
- Réaliser une **analyse exploratoire univariée** et des **visualisations** pour mieux comprendre les données.
- Mettre en place un environnement de travail adapté (Poetry / environnement virtuel, Jupyter, organisation du dépôt).
- Produire des notebooks propres et structurés, pouvant être compris par un public métier et technique.

## 🧩 Contexte

- **Contexte métier :** le projet s’inscrit dans l’analyse de données de systèmes éducatifs (indicateurs de performance, réussite, etc.) afin de mieux comprendre ces systèmes et de préparer des analyses plus avancées.
- **Contexte technique :** jeu de données tabulaire (fichiers CSV) analysé dans des notebooks Jupyter, en utilisant principalement **Python**, **Pandas** et des bibliothèques de visualisation (Matplotlib / Seaborn, etc).
- **Cadre OpenClassrooms :**
  - Parcours : *Data Engineer – OpenClassrooms*
  - Projet 2 : *Analysez les données de systèmes éducatifs*
  - Durée indicative : *30 heures*

## 🎓 Compétences évaluées (brief OC)

Compétences cibles du projet :

- Appliquer des analyses statistiques descriptives et naviguer visuellement dans les données.
- Configurer l’environnement de travail nécessaire à l’exploitation des données.
- Corriger les anomalies manuellement et à l’aide d'outils adaptés.

## 🏗️ Architecture du projet

Grandes briques prévues pour ce projet :

- **Sources de données :**
  - Fichiers CSV fournis par OpenClassrooms (données de systèmes éducatifs).
- **Étapes du travail :**
  - Mise en place de l’environnement Python / Jupyter.
  - Analyse exploratoire univariée (statistiques descriptives, visualisations).
  - Nettoyage des données (gestion des valeurs manquantes, incohérences, doublons, etc.).
  - Analyse plus approfondie et réponse à une problématique métier.
- **Stockage :**
  - Données stockées localement dans le dossier `data/` (brut vs nettoyé).
- **Outils utilisés :**
  - Python, Jupyter Notebook, Pandas, NumPy, Matplotlib, Seaborn.

Un schéma plus détaillé pourra être ajouté dans `docs/` et référencé ici :

```mermaid
flowchart LR
    A["Jeu de données systèmes éducatifs (CSV)"] --> B[Exploration & statistiques descriptives]
    B --> C[Nettoyage / préparation des données]
    C --> D[Jeu de données nettoyé]
    D --> E[Analyses complémentaires & visualisations]
    E --> F["Restitution (notebook / rapport)"]
```

## 🛠️ Stack technique

- Langage : Python 3.14
- Environnement de développement : VS Code + extensions (Python, Jupyter, etc.)
- GGestion de version : Git & GitHub
- Base(s) de données : `fichiers CSV locaux.`
- Traitements de données : `Pandas, NumPy`
- visualisation : `Pandas Profiling, Matplotlib, Seaborn`
- Orchestration / ingestion : `notebooks Jupyter et scripts Python`

## 📂 Structure du dépôt

```txt
.
├─ .vscode/
│  └─ settings.json
├─ data/
│  ├─ raw/
│  ├─ processed/  # données nettoyées / transformées
├─ docs/          # schémas, compte-rendus, notes, exports de diagrammes
|  ├─ Livrables/
├─ notebooks/     # notebooks Jupyter d'exploration / POC
├─ src/
│      ├─ __init__.py
│      ├─ config/        # fichiers de config (YAML/JSON)
│      └─ pipelines/     # scripts ETL, jobs, traitements
├─ tests/         # tests unitaires / d’intégration
├─ .gitignore
├─ README.md
├─ requirements.txt
└─ LICENSE        # optionnel (MIT par ex.)
```

## 🚀 Installation & exécution

### 1. Prérequis

- Python 3.14
- Git installé

### 2. Cloner le dépôt
Cloner le dépôt principal, puis se placer dans le dossier du projet 2 :
```bash
git clone https://github.com/PAANNO/OPC-Data_Engineer.git
cd OPC-Data_Engineer/"OPC2-Analysez les données de systèmes éducatifs"
```
### 3. Créer et activer l'environnement virtuel
```bash
python -m venv .venv

# Windows (PowerShell)
.\.venv\Scripts\Activate.ps1

#macOS / Linux
source .venv/bin/activate
```
### 4. Installer les dépendances
```bash
pip install --upgrade pip
pip install -r requirements.txt
```
## ✅ Qualité, formatage & tests

### Formatage

Le projet utilise Black pour formater le code :

```bash
black src tests
```
### Tests

Les tests sont basés sur `pytest` :
```bash
pytest
```
## 📎 Livrables OpenClassrooms
- Code source dans ce dépôt Git
- Rapport / présentation : voir dossier docs/
- (Selon le projet) exports de données, captures d’écran, schémas d’architecture

## ✍️ Auteur
- Nom : Paul-Alexandre ANNONAY
- Parcours : Data Engineer – OpenClassrooms
- Email : pa.annonay@gmail.com

### b) `.gitignore` (Python + notebooks)

```gitignore
# Environnements virtuels
.venv/
env/
venv/

# Python
__pycache__/
*.py[cod]
*.pyo
*.pyd
*.pdb

# Jupyter
.ipynb_checkpoints/

# Données volumineuses / temporaires
data/raw/
data/processed/
data/external/

# Logs / sorties
logs/
*.log

# OS
.DS_Store
Thumbs.db

# VS Code
.vscode/*
!.vscode/settings.json
```

### c) `requirements.txt` – base pour un projet data engineer
```txt
# Core
python-dotenv

# Data manipulation
pandas
numpy

# BDD / SQL
sqlalchemy
psycopg2-binary  # si tu utilises PostgreSQL

# Notebooks
jupyter
ipykernel

# Qualité
black
pytest

# À compléter selon le projet :
# pyspark
# kafka-python
# requests
# pydantic
```

### d) `.vscode/settings.json` – pour que VS Code soit nickel
```json
{
  // Interpréteur Python : le .venv du projet
  "python.defaultInterpreterPath": "${workspaceFolder}/.venv/bin/python",

  // Formatage automatique
  "editor.formatOnSave": true,
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter"
  },

  // Masquer certains dossiers dans l'explorateur
  "files.exclude": {
    "**/__pycache__": true,
    "**/.pytest_cache": true
  },

  // Jupyter: utiliser le kernel associé à l'interpréteur sélectionné
  "jupyter.jupyterServerType": "local"
}
```