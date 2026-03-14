BEGIN TRANSACTION;

INSERT INTO calendrier (date_id)
SELECT CAST(date AS INTEGER) FROM stg_calendrier
WHERE stg_calendrier.date IS NOT NULL
    AND TRIM(stg_calendrier.date) <> '';

INSERT INTO clients (customer_id, date_inscription)
SELECT DISTINCT TRIM(customer_id),
       CAST(
        julianday(
            printf(
                '%04d-%02d-%02d',
                CAST(
                    substr(
                        substr(TRIM(date_inscription), instr(TRIM(date_inscription), '/') + 1),
                        instr(substr(TRIM(date_inscription), instr(TRIM(date_inscription), '/') + 1), '/') + 1
                    ) AS INTEGER
                ),
                CAST(
                    substr(
                        substr(TRIM(date_inscription), instr(TRIM(date_inscription), '/') + 1),
                        1,
                        instr(substr(TRIM(date_inscription), instr(TRIM(date_inscription), '/') + 1), '/') - 1
                    ) AS INTEGER
                ),
                CAST(
                    substr(TRIM(date_inscription), 1, instr(TRIM(date_inscription), '/') - 1) AS INTEGER
                )
            )
        ) - julianday('1899-12-30')
    AS INTEGER)
FROM stg_clients
WHERE customer_id IS NOT NULL
    AND TRIM(customer_id) <> ''
    AND date_inscription IS NOT NULL
    AND TRIM(date_inscription) <> '';

INSERT INTO produits (ean, categorie,rayon, libelle_produit, prix)
SELECT DISTINCT TRIM(ean),
         TRIM(categorie),
         TRIM(rayon),
         TRIM(libelle_produit),
         CAST(REPLACE(prix, ',', '.') AS NUMERIC)
FROM stg_produits
WHERE ean IS NOT NULL
    AND TRIM(ean) <> ''
    AND categorie IS NOT NULL
    AND TRIM(categorie) <> ''
    AND rayon IS NOT NULL
    AND TRIM(rayon) <> ''
    AND libelle_produit IS NOT NULL
    AND TRIM(libelle_produit) <> ''
    AND prix IS NOT NULL
    AND TRIM(prix) <> '';

INSERT INTO employe (id_employe, prenom, nom, date_debut, hash_mdp)
SELECT DISTINCT TRIM(id_employe),
         TRIM(prenom),
         TRIM(nom),
         CAST(date_debut AS INTEGER),
        TRIM(hash_mdp)
FROM stg_employe
WHERE id_employe IS NOT NULL
    AND TRIM(id_employe) <> ''
    AND prenom IS NOT NULL
    AND TRIM(prenom) <> ''
    AND nom IS NOT NULL
    AND TRIM(nom) <> ''
    AND date_debut IS NOT NULL
    AND TRIM(date_debut) <> ''
    AND hash_mdp IS NOT NULL
    AND TRIM(hash_mdp) <> '';

INSERT INTO vente_detail (id_bdd, customer_id, id_employe, ean, date_achat, id_ticket)
SELECT DISTINCT TRIM(id_bdd),
         TRIM(customer_id),
         TRIM(id_employe),
         TRIM(ean),
         CAST(date_achat AS INTEGER),
         TRIM(id_ticket)
FROM stg_vente_detail
WHERE id_bdd IS NOT NULL
    AND TRIM(id_bdd) <> ''
    AND customer_id IS NOT NULL
    AND TRIM(customer_id) <> ''
    AND id_employe IS NOT NULL
    AND TRIM(id_employe) <> ''
    AND ean IS NOT NULL
    AND TRIM(ean) <> ''
    AND date_achat IS NOT NULL
    AND TRIM(date_achat) <> ''
    AND id_ticket IS NOT NULL
    AND TRIM(id_ticket) <> '';

COMMIT;