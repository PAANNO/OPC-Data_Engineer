PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

-- =====================================
-- NETTOYAGE
-- =====================================
DROP VIEW IF EXISTS v_ventes_tardives;

DROP TRIGGER IF EXISTS trg_log_insert_vente_detail;
DROP TRIGGER IF EXISTS trg_log_update_produits_prix;
DROP TRIGGER IF EXISTS trg_produits_check_prix_update;

DROP TABLE IF EXISTS logs_audit;
DROP TABLE IF EXISTS vente_detail;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS produits;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS calendrier;
DROP TABLE IF EXISTS employe;

-- =====================================
-- DIMENSION CALENDRIER
-- date_id = numéro de série Excel --> nombre de jours depuis le 30/12/1899
-- 1 = dimanche, 7 = samedi pour jour_semaine
-- =====================================
CREATE TABLE calendrier (
    date_id INTEGER PRIMARY KEY,

    annee INTEGER GENERATED ALWAYS AS (
        CAST(strftime('%Y', date('1899-12-30', '+' || date_id || ' days')) AS INTEGER)
    ) STORED,

    mois INTEGER GENERATED ALWAYS AS (
        CAST(strftime('%m', date('1899-12-30', '+' || date_id || ' days')) AS INTEGER)
    ) STORED,

    jour INTEGER GENERATED ALWAYS AS (
        CAST(strftime('%d', date('1899-12-30', '+' || date_id || ' days')) AS INTEGER)
    ) STORED,

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

    annee_mois INTEGER GENERATED ALWAYS AS (
        date_id
        - CAST(strftime('%d', date('1899-12-30', '+' || date_id || ' days')) AS INTEGER)
        + 1
    ) STORED,

    jour_semaine INTEGER GENERATED ALWAYS AS (
        ((date_id + 6) % 7) + 1
    ) STORED,

    trimestre TEXT GENERATED ALWAYS AS (
        CASE
            WHEN CAST(strftime('%m', date('1899-12-30', '+' || date_id || ' days')) AS INTEGER) BETWEEN 1 AND 3 THEN 'Q1'
            WHEN CAST(strftime('%m', date('1899-12-30', '+' || date_id || ' days')) AS INTEGER) BETWEEN 4 AND 6 THEN 'Q2'
            WHEN CAST(strftime('%m', date('1899-12-30', '+' || date_id || ' days')) AS INTEGER) BETWEEN 7 AND 9 THEN 'Q3'
            ELSE 'Q4'
        END
    ) STORED
);

-- =====================================
-- DIMENSION CLIENTS
-- date_inscription stockée au même format que les autres dates : entier Excel
-- =====================================
CREATE TABLE clients (
    customer_id TEXT PRIMARY KEY,
    date_inscription INTEGER NOT NULL,
    FOREIGN KEY (date_inscription) REFERENCES calendrier(date_id)
);

-- =====================================
-- DIMENSION PRODUITS
-- EAN conservé en TEXT pour éviter toute altération due a la longueur
-- =====================================
CREATE TABLE produits (
    ean TEXT PRIMARY KEY,
    categorie TEXT NOT NULL,
    rayon TEXT NOT NULL,
    libelle_produit TEXT NOT NULL,
    prix REAL NOT NULL CHECK (prix >= 0)
);

-- =====================================
-- DIMENSION EMPLOYE
-- nécessite un SQLite avec ICU pour bien gérer lower() sur les caractères accentués
-- =====================================
CREATE TABLE users (
    id_employe TEXT PRIMARY KEY,
    prenom TEXT NOT NULL,
    nom TEXT NOT NULL,

    employe TEXT GENERATED ALWAYS AS (
        lower(substr(prenom, 1, 1) || nom)
    ) STORED UNIQUE,

    date_debut INTEGER NOT NULL,
    hash_mdp TEXT NOT NULL,

    mail TEXT GENERATED ALWAYS AS (
        lower(substr(prenom, 1, 1) || nom) || '@supersmartmarket.fr'
    ) STORED UNIQUE,
    type_user TEXT,

    FOREIGN KEY (date_debut) REFERENCES calendrier(date_id)
);

-- =====================================
-- TABLE DE FAITS VENTE_DETAIL
-- CORRECTIF PRINCIPAL : ajout de date_integration
-- date_vente = date métier
-- date_integration = date technique de chargement dans la base analytique
-- =====================================
CREATE TABLE vente_detail (
    id_bdd TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL,
    id_employe TEXT NOT NULL,
    ean TEXT NOT NULL,
    date_vente INTEGER NOT NULL,
    date_integration INTEGER NOT NULL DEFAULT (CAST(julianday('now', 'localtime') - julianday('1899-12-30') AS INTEGER)),
    id_ticket TEXT NOT NULL,
    prix_reference_integration NUMERIC NOT NULL DEFAULT 0 CHECK (prix_reference_integration >= 0),

    FOREIGN KEY (customer_id) REFERENCES clients(customer_id),
    FOREIGN KEY (id_employe) REFERENCES users(id_employe),
    FOREIGN KEY (ean) REFERENCES produits(ean),
    FOREIGN KEY (date_vente) REFERENCES calendrier(date_id)
);

-- =====================================
-- LOGS D'AUDIT RENFORCÉS POUR LE PROTOTYPE
-- =====================================
CREATE TABLE logs_audit (
    id_log INTEGER PRIMARY KEY AUTOINCREMENT,
    date_log INTEGER NOT NULL DEFAULT (CAST(julianday('now', 'localtime') - julianday('1899-12-30') AS INTEGER)),
    horodatage TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    source_action TEXT NOT NULL,
    id_user TEXT,
    action_log TEXT NOT NULL CHECK (action_log IN ('INSERT', 'UPDATE', 'DELETE')),
    table_affected TEXT NOT NULL,
    ligne_affected TEXT,
    champ_affected TEXT,
    ancienne_valeur TEXT,
    nouvelle_valeur TEXT,

    FOREIGN KEY (date_log) REFERENCES calendrier(date_id),
    FOREIGN KEY (id_user) REFERENCES users(id_employe)
);

-- =====================================
-- INDEX UTILES
-- =====================================
CREATE INDEX idx_clients_date_inscription ON clients(date_inscription);
CREATE INDEX idx_produits_rayon ON produits(rayon);
CREATE INDEX idx_users_date_debut ON users(date_debut);
CREATE INDEX idx_vente_detail_customer_id ON vente_detail(customer_id);
CREATE INDEX idx_vente_detail_id_employe ON vente_detail(id_employe);
CREATE INDEX idx_vente_detail_ean ON vente_detail(ean);
CREATE INDEX idx_vente_detail_date_vente ON vente_detail(date_vente);
CREATE INDEX idx_vente_detail_date_integration ON vente_detail(date_integration);
CREATE INDEX idx_vente_detail_id_ticket ON vente_detail(id_ticket);
CREATE INDEX idx_logs_audit_table_action ON logs_audit(table_affected, action_log);

-- =====================================
-- TRIGGERS DE CONTRÔLE ET DE TRAÇABILITÉ
-- =====================================
CREATE TRIGGER trg_produits_check_prix_update
BEFORE UPDATE OF prix ON produits
FOR EACH ROW
WHEN NEW.prix < 0
BEGIN
    SELECT RAISE(ABORT, 'Prix negatif interdit');
END;

CREATE TRIGGER trg_log_update_produits_prix
AFTER UPDATE OF prix ON produits
FOR EACH ROW
WHEN OLD.prix <> NEW.prix
BEGIN
    INSERT INTO logs_audit (
        source_action,
        action_log,
        table_affected,
        ligne_affected,
        champ_affected,
        ancienne_valeur,
        nouvelle_valeur
    )
    VALUES (
        'TRIGGER_PRODUITS',
        'UPDATE',
        'produits',
        NEW.ean,
        'prix',
        CAST(OLD.prix AS TEXT),
        CAST(NEW.prix AS TEXT)
    );
END;

CREATE TRIGGER trg_log_insert_vente_detail
AFTER INSERT ON vente_detail
FOR EACH ROW
BEGIN
    UPDATE vente_detail
    SET prix_reference_integration = (
        SELECT p.prix
        FROM produits p
        WHERE p.ean = NEW.ean
    )
    WHERE id_bdd = NEW.id_bdd;

    INSERT INTO logs_audit (
        source_action,
        action_log,
        table_affected,
        ligne_affected,
        champ_affected,
        ancienne_valeur,
        nouvelle_valeur
    )
    VALUES (
        'TRIGGER_VENTE_DETAIL',
        'INSERT',
        'vente_detail',
        NEW.id_bdd,
        NULL,
        NULL,
        'date_vente=' || NEW.date_vente
        || '; date_integration=' || NEW.date_integration
        || '; prix_reference_integration='
        || COALESCE(
            (
                SELECT CAST(p.prix AS TEXT)
                FROM produits p
                WHERE p.ean = NEW.ean
            ),
            'NULL'
        )
    );
END;

-- =====================================
-- VUE DE CONTRÔLE DES CHARGEMENTS TARDIFS
-- =====================================
CREATE VIEW v_ventes_tardives AS
SELECT
    v.id_bdd,
    v.customer_id,
    v.id_employe,
    v.ean,
    v.id_ticket,
    v.date_vente,
    date('1899-12-30', '+' || v.date_vente || ' days') AS date_vente_iso,
    v.date_integration,
    date('1899-12-30', '+' || v.date_integration || ' days') AS date_integration_iso,
    CASE
        WHEN v.date_integration > v.date_vente THEN 1
        ELSE 0
    END AS chargement_tardif
FROM vente_detail v;

COMMIT;