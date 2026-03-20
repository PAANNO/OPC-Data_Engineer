BEGIN TRANSACTION;

INSERT INTO logs (id_user, date_log, action_log, table_affected, ligne_affected, champ_affected, detail)
SELECT TRIM(id_user),
       CAST(date AS INTEGER),
       TRIM(action),
       TRIM(table_insert),
       TRIM(id_ligne),
       TRIM(champs),
       TRIM(detail)
FROM stg_logs
WHERE id_user IS NOT NULL
    AND TRIM(id_user) <> ''
    AND date IS NOT NULL
    AND TRIM(date) <> ''
    AND action IS NOT NULL
    AND TRIM(action) <> ''
    AND table_insert IS NOT NULL
    AND TRIM(table_insert) <> ''
    AND id_ligne IS NOT NULL
    AND TRIM(id_ligne) <> '';

COMMIT;