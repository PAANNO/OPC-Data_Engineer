BEGIN TRANSACTION;

DROP TABLE IF EXISTS stg_calendrier;
DROP TABLE IF EXISTS stg_clients;
DROP TABLE IF EXISTS stg_produits;
DROP TABLE IF EXISTS stg_employe;
DROP TABLE IF EXISTS stg_vente_detail;

CREATE TABLE stg_calendrier (
    date TEXT,
    annee TEXT,
    mois TEXT,
    jour TEXT,
    mois_nom TEXT,
    annee_mois TEXT,
    jour_semaine TEXT,
    trimestre TEXT
);

CREATE TABLE stg_clients (
    customer_id TEXT,
    date_inscription TEXT
);

CREATE TABLE stg_produits (
    ean TEXT,
    categorie TEXT,
    rayon TEXT,
    libelle_produit TEXT,
    prix TEXT
);

CREATE TABLE stg_employe (
    id_employe TEXT,
    employe TEXT,
    prenom TEXT,
    nom TEXT,
    date_debut TEXT,
    hash_mdp TEXT,
    mail TEXT
);

CREATE TABLE stg_vente_detail (
    id_bdd TEXT,
    customer_id TEXT,
    id_employe TEXT,
    ean TEXT,
    date_achat TEXT,
    id_ticket TEXT
);

COMMIT;