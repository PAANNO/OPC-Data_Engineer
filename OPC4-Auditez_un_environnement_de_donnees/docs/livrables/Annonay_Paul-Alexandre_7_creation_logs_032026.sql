BEGIN TRANSACTION;

DROP TABLE IF EXISTS logs;
DROP TABLE IF EXISTS stg_logs;

CREATE TABLE stg_logs (
    id_user TEXT NOT NULL,
    date TEXT NOT NULL,
    action TEXT NOT NULL,
    table_insert TEXT NOT NULL,
    id_ligne TEXT NOT NULL,
    champs TEXT NOT NULL,
    detail TEXT NOT NULL,
    colonne1 TEXT
);

CREATE TABLE logs (
    id_log INTEGER PRIMARY KEY AUTOINCREMENT,
    id_user TEXT NOT NULL,
    date_log INTEGER NOT NULL,
    action_log TEXT NOT NULL,
    table_affected TEXT NOT NULL,
    ligne_affected TEXT NOT NULL,
    champ_affected TEXT NOT NULL,
    detail TEXT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES employe(id_employe),
    FOREIGN KEY (date_log) REFERENCES calendrier(date_id)
);

COMMIT;