-- 1) Chiffre d'affaires total pour le 14 août
SELECT
    ROUND(SUM(p.prix), 2) AS ca_total_14_aout_2024
FROM vente_detail vd
JOIN produits p ON p.ean = vd.ean
JOIN calendrier c ON c.date_id = vd.date_achat
WHERE c.jour = 14
  AND c.mois = 8
  AND c.annee = 2024;

-- 2) Top 10 des clients par chiffre d'affaires
SELECT
    vd.customer_id,
    COUNT(*) AS nb_articles,
    ROUND(SUM(p.prix), 2) AS ca_client
FROM vente_detail vd
JOIN produits p ON p.ean = vd.ean
GROUP BY vd.customer_id
ORDER BY ca_client DESC
LIMIT 10;

-- 3) Chiffre d'affaires par employé
SELECT
    e.id_employe,
    e.employe,
    COUNT(DISTINCT vd.id_ticket) AS nb_tickets,
    COUNT(*) AS nb_articles,
    ROUND(SUM(p.prix), 2) AS ca_employe
FROM vente_detail vd
JOIN employe e ON e.id_employe = vd.id_employe
JOIN produits p ON p.ean = vd.ean
GROUP BY e.id_employe, e.employe
ORDER BY ca_employe DESC;

-- Nombre de logs
SELECT COUNT(*) FROM logs;

-- Répartition des actions
SELECT action_log, COUNT(*) AS nb
FROM logs
GROUP BY action_log
ORDER BY nb DESC;

-- Répartitions par table
SELECT table_affected, COUNT(*) AS nb
FROM logs
GROUP BY table_affected
ORDER BY nb DESC;

-- Quelle modification sur quelle table
SELECT
    table_affected,
    action_log,
    COUNT(*) AS nb
FROM logs
GROUP BY table_affected, action_log
ORDER BY table_affected, action_log;

-- Nombre de ligne par vente
SELECT ligne_affected, COUNT(*) AS nb_lignes
FROM logs
WHERE table_affected = 'Ventes'
  AND action_log = 'INSERT'
GROUP BY ligne_affected
ORDER BY nb_lignes DESC;

-- Nombre de ventes dans les logs
SELECT date_log, COUNT(DISTINCT ligne_affected) AS nb_ventes_loggees
FROM logs
WHERE table_affected = 'Ventes'
  AND action_log = 'INSERT'
GROUP BY date_log;

-- Date d'insertion des logs
SELECT date_log, COUNT(*) AS nb_log
FROM logs
GROUP BY date_log;

-- Mises à jour sur les prix
SELECT *
FROM logs
WHERE table_affected = 'Produits'
  AND action_log = 'UPDATE'
  AND champ_affected = 'prix'
LIMIT 50;

-- Date des ventes ajoutés le 15/08/2024
SELECT date_log, COUNT(*) AS nb_ventes
FROM logs
WHERE action_log = 'INSERT'
	AND table_affected = 'Ventes'
	AND champ_affected ='Date'
GROUP BY champ_affected;

-- Vérifier si tous les id_user des logs existent dans employe
SELECT DISTINCT l.id_user
FROM logs l
LEFT JOIN employe e
    ON l.id_user = e.id_employe
WHERE e.id_employe IS NULL
ORDER BY l.id_user;

-- Combien d’identifiants distincts ne correspondent pas
SELECT COUNT(DISTINCT l.id_user) AS nb_id_user_absents
FROM logs l
LEFT JOIN employe e
    ON l.id_user = e.id_employe
WHERE e.id_employe IS NULL;