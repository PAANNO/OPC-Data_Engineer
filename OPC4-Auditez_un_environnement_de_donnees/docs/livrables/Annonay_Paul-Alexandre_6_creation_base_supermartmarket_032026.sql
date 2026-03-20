PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;


DROP TABLE IF EXISTS vente_detail;
DROP TABLE IF EXISTS employe;
DROP TABLE IF EXISTS produits;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS calendrier;
DROP TABLE IF EXISTS calendrier_calculated;
DROP TABLE IF EXISTS employe_calculated;

CREATE TABLE calendrier (
    date_id INTEGER PRIMARY KEY,
    annee INTEGER GENERATED ALWAYS AS (CAST(strftime('%Y', date('1899-12-30', '+' || date_id || ' days')) AS INTEGER)) STORED,
    mois INTEGER GENERATED ALWAYS AS (CAST(strftime('%m', date('1899-12-30', '+' || date_id || ' days')) AS INTEGER)) STORED,
    jour INTEGER GENERATED ALWAYS AS (CAST(strftime('%d', date('1899-12-30', '+' || date_id || ' days')) AS INTEGER)) STORED,
    mois_nom TEXT GENERATED ALWAYS AS (
        CASE CAST(strftime('%m', date('1899-12-30', '+' || date_id || ' days')) AS INTEGER)
            WHEN 1 THEN 'janvier'
            WHEN 2 THEN 'février'
            WHEN 3 THEN 'mars'
            WHEN 4 THEN 'avril'
            WHEN 5 THEN 'mai'
            WHEN 6 THEN 'juin'
            WHEN 7 THEN 'juillet'
            WHEN 8 THEN 'août'
            WHEN 9 THEN 'septembre'
            WHEN 10 THEN 'octobre'
            WHEN 11 THEN 'novembre'
            WHEN 12 THEN 'décembre'
        END
    ) STORED,
    annee_mois INTEGER GENERATED ALWAYS AS (date_id - CAST(strftime('%d', date('1899-12-30', '+' || date_id || ' days')) AS INTEGER) + 1) STORED,
    jour_semaine INTEGER GENERATED ALWAYS AS (((date_id + 6) % 7) + 1) STORED,
    trimestre TEXT GENERATED ALWAYS AS (
        CASE
            WHEN CAST(strftime('%m', date('1899-12-30', '+' || date_id || ' days')) AS INTEGER) BETWEEN 1 AND 3 THEN 'Q1'
            WHEN CAST(strftime('%m', date('1899-12-30', '+' || date_id || ' days')) AS INTEGER) BETWEEN 4 AND 6 THEN 'Q2'
            WHEN CAST(strftime('%m', date('1899-12-30', '+' || date_id || ' days')) AS INTEGER) BETWEEN 7 AND 9 THEN 'Q3'
            ELSE 'Q4'
        END
    ) STORED
);

CREATE TABLE clients (
    customer_id TEXT PRIMARY KEY,
    date_inscription INTEGER NOT NULL,
    FOREIGN KEY (date_inscription) REFERENCES calendrier(date_id)
);

CREATE TABLE produits (
    ean TEXT PRIMARY KEY,
    categorie TEXT NOT NULL,
    rayon TEXT NOT NULL,
    libelle_produit TEXT NOT NULL,
    prix REAL NOT NULL CHECK (prix >= 0)
);

CREATE TABLE employe (
    id_employe TEXT PRIMARY KEY,
    employe TEXT GENERATED ALWAYS AS (lower(substr(prenom, 1, 1) || nom)) STORED UNIQUE,
    prenom TEXT NOT NULL,
    nom TEXT NOT NULL,
    date_debut INTEGER NOT NULL,
    hash_mdp TEXT NOT NULL UNIQUE,
    mail TEXT GENERATED ALWAYS AS (lower(substr(prenom, 1, 1) || nom) || '@supersmartmarket.fr') STORED UNIQUE,
    FOREIGN KEY (date_debut) REFERENCES calendrier(date_id)
);

CREATE TABLE vente_detail (
    id_bdd TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL,
    id_employe TEXT NOT NULL,
    ean TEXT NOT NULL,
    date_achat INTEGER NOT NULL,
    id_ticket TEXT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES clients(customer_id),
    FOREIGN KEY (id_employe) REFERENCES employe(id_employe),
    FOREIGN KEY (ean) REFERENCES produits(ean),
    FOREIGN KEY (date_achat) REFERENCES calendrier(date_id)
);

CREATE INDEX idx_vente_detail_customer_id ON vente_detail(customer_id);
CREATE INDEX idx_vente_detail_id_employe ON vente_detail(id_employe);
CREATE INDEX idx_vente_detail_ean ON vente_detail(ean);
CREATE INDEX idx_vente_detail_date_achat ON vente_detail(date_achat);
CREATE INDEX idx_vente_detail_id_ticket ON vente_detail(id_ticket);

COMMIT;