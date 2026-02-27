-- 1. Nombre total d’appartements vendus au 1er semestre 2020

SELECT COUNT(*) AS nb_appartements_vendus_s1_2020
FROM valeurs_foncieres vf
JOIN ref_type_local rtl ON rtl.code_type_local = vf.code_type_local
WHERE rtl.type_local = 'Appartement'
  AND vf.nature_mutation = 'Vente';

-- 2. Le nombre de ventes d’appartement par région pour le 1er semestre 2020.

SELECT gr.reg_nom AS region,
       COUNT(*) AS nb_ventes
FROM valeurs_foncieres vf
JOIN ref_type_local rtl ON rtl.code_type_local = vf.code_type_local
JOIN geo_commune gc
  ON gc.dep_code = vf.code_departement
 AND gc.com_code = vf.code_commune
JOIN geo_departement gd ON gd.dep_code = gc.dep_code
JOIN geo_region gr ON gr.reg_code = gd.reg_code
WHERE rtl.type_local = 'Appartement'
  AND vf.nature_mutation = 'Vente'
GROUP BY gr.reg_nom
ORDER BY nb_ventes DESC;

-- 3. Proportion des ventes d’appartements par le nombre de pièces.

SELECT vf.nombre_pieces_principales AS nb_pieces,
       COUNT(*) AS nb_ventes,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS proportion_pct
FROM valeurs_foncieres vf
JOIN ref_type_local rtl ON rtl.code_type_local = vf.code_type_local
WHERE rtl.type_local = 'Appartement'
  AND vf.nature_mutation = 'Vente'
GROUP BY vf.nombre_pieces_principales
ORDER BY vf.nombre_pieces_principales;

-- 4. Liste des 10 départements où le prix du mètre carré est le plus élevé.

SELECT gd.dep_code,
       gd.dep_nom,
       ROUND(AVG(vf.valeur_fonciere / vf.surface_reelle_bati), 2) AS prix_m2_moyen
FROM valeurs_foncieres vf
JOIN geo_departement gd ON gd.dep_code = vf.code_departement
WHERE vf.nature_mutation = 'Vente'
  AND vf.valeur_fonciere IS NOT NULL
GROUP BY gd.dep_code, gd.dep_nom
ORDER BY prix_m2_moyen DESC
LIMIT 10;

-- 5. Prix moyen du mètre carré d’une maison en Île-de-France.

SELECT ROUND(AVG(vf.valeur_fonciere / vf.surface_reelle_bati), 2) AS prix_m2_moyen_maison_idf
FROM valeurs_foncieres vf
JOIN ref_type_local rtl ON rtl.code_type_local = vf.code_type_local
JOIN geo_commune gc
  ON gc.dep_code = vf.code_departement
 AND gc.com_code = vf.code_commune
JOIN geo_departement gd ON gd.dep_code = gc.dep_code
JOIN geo_region gr ON gr.reg_code = gd.reg_code
WHERE rtl.type_local = 'Maison'
  AND vf.nature_mutation = 'Vente'
  AND vf.valeur_fonciere IS NOT NULL
  AND vf.surface_reelle_bati IS NOT NULL
  AND gr.reg_nom = 'Ile-de-France';

-- 6. Liste des 10 appartements les plus chers avec la région et le nombre de mètres carrés.

SELECT vf.valeur_fonciere,
       vf.surface_reelle_bati AS surface_m2,
       gr.reg_nom AS region,
       gc.com_nom AS commune
FROM valeurs_foncieres vf
JOIN ref_type_local rtl ON rtl.code_type_local = vf.code_type_local
JOIN geo_commune gc
  ON gc.dep_code = vf.code_departement
 AND gc.com_code = vf.code_commune
JOIN geo_departement gd ON gd.dep_code = gc.dep_code
JOIN geo_region gr ON gr.reg_code = gd.reg_code
WHERE rtl.type_local = 'Appartement'
  AND vf.nature_mutation = 'Vente'
ORDER BY vf.valeur_fonciere DESC
LIMIT 10;

-- 7. Taux d’évolution du nombre de ventes entre le premier et le second trimestre de 2020.

WITH t1 AS (
  SELECT COUNT(*) AS c
  FROM valeurs_foncieres
  WHERE nature_mutation = 'Vente'
    AND date_mutation >= '2020/01/01'
    AND date_mutation <  '2020/04/01'
),
t2 AS (
  SELECT COUNT(*) AS c
  FROM valeurs_foncieres
  WHERE nature_mutation = 'Vente'
    AND date_mutation >= '2020/04/01'
    AND date_mutation <  '2020/07/01'
)
SELECT
  t1.c AS ventes_t1,
  t2.c AS ventes_t2,
  ROUND((t2.c - t1.c) * 100.0 / NULLIF(t1.c, 0), 2) AS taux_evolution_pct
FROM t1, t2;

-- 8. Le classement des régions par rapport au prix au mètre carré des appartement de plus de 4 pièces.

SELECT gr.reg_nom AS region,
       ROUND(AVG(vf.valeur_fonciere / vf.surface_reelle_bati), 2) AS prix_m2_moyen
FROM valeurs_foncieres vf
JOIN ref_type_local rtl ON rtl.code_type_local = vf.code_type_local
JOIN geo_commune gc
  ON gc.dep_code = vf.code_departement
 AND gc.com_code = vf.code_commune
JOIN geo_departement gd ON gd.dep_code = gc.dep_code
JOIN geo_region gr ON gr.reg_code = gd.reg_code
WHERE rtl.type_local = 'Appartement'
  AND vf.nature_mutation = 'Vente'
  AND vf.nombre_pieces_principales > 4
  AND vf.valeur_fonciere IS NOT NULL
  AND vf.surface_reelle_bati IS NOT NULL
GROUP BY gr.reg_nom
ORDER BY prix_m2_moyen DESC;

-- 9. Liste des communes ayant eu au moins 50 ventes au 1er trimestre.

SELECT
  code_departement,
  code_commune,
  gc.com_nom AS commune,
  COUNT(*) AS nb_ventes
FROM valeurs_foncieres vf
JOIN geo_commune gc
  ON gc.dep_code = vf.code_departement
 AND gc.com_code = vf.code_commune
WHERE vf.date_mutation >= '2020/01/01'
  AND vf.date_mutation < '2020/04/01'
  AND vf.nature_mutation = 'Vente'
GROUP BY vf.code_departement, vf.code_commune, gc.com_nom
HAVING COUNT(*) >= 50
ORDER BY nb_ventes DESC;

-- 10. Différence en pourcentage du prix au mètre carré entre un appartement de 2 pièces et un appartement de 3 pièces.

WITH prix AS (
  SELECT vf.nombre_pieces_principales AS nb_pieces,
         AVG(vf.valeur_fonciere / vf.surface_reelle_bati) AS prix_m2_moyen
  FROM valeurs_foncieres vf
  JOIN ref_type_local rtl ON rtl.code_type_local = vf.code_type_local
  WHERE rtl.type_local = 'Appartement'
    AND vf.nature_mutation = 'Vente'
    AND vf.nombre_pieces_principales IN (2, 3)
    AND vf.valeur_fonciere IS NOT NULL
    AND vf.surface_reelle_bati IS NOT NULL
  GROUP BY vf.nombre_pieces_principales
)
SELECT t2.prix_m2_moyen AS prix_m2_t2,
       t3.prix_m2_moyen AS prix_m2_t3,
       ROUND((t3.prix_m2_moyen - t2.prix_m2_moyen) * 100.0 / t2.prix_m2_moyen, 2) AS ecart_pct_3p_vs_2p
FROM prix t2
JOIN prix t3
  ON t2.nb_pieces = 2
 AND t3.nb_pieces = 3;

-- 11. Les moyennes de valeurs foncières pour le top 3 des communes des départements 6, 13, 33, 59 et 69.

WITH stats AS (
  SELECT vf.code_departement,
         vf.code_commune,
         gc.com_nom AS commune,
         AVG(vf.valeur_fonciere) AS moyenne_valeur_fonciere
  FROM valeurs_foncieres vf
  JOIN geo_commune gc
    ON gc.dep_code = vf.code_departement
   AND gc.com_code = vf.code_commune
  WHERE vf.nature_mutation = 'Vente'
    AND vf.code_departement IN ('06', '13', '33', '59', '69')
    AND vf.valeur_fonciere IS NOT NULL
  GROUP BY vf.code_departement, vf.code_commune, gc.com_nom
),
ranked AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY code_departement
           ORDER BY moyenne_valeur_fonciere DESC
         ) AS rn
  FROM stats
)
SELECT code_departement,
       code_commune,
       commune,
       ROUND(moyenne_valeur_fonciere, 2) AS moyenne_valeur_fonciere
FROM ranked
WHERE rn <= 3
ORDER BY code_departement, moyenne_valeur_fonciere DESC;

-- 12. Les 20 communes avec le plus de transactions pour 1000 habitants pour les communes qui dépassent les 10 000 habitants.

SELECT cp.CODDEP AS code_departement,
       cp.CODCOM AS code_commune,
       cp.COM AS commune,
       cp.PTOT AS population_totale,
       COUNT(vf.rowid) AS nb_transactions,
       ROUND(COUNT(vf.rowid) * 1000.0 / cp.PTOT, 2) AS transactions_pour_1000_hab
FROM geo_commune_population cp
LEFT JOIN valeurs_foncieres vf
  ON vf.code_departement = cp.CODDEP
 AND vf.code_commune = cp.CODCOM
 AND vf.nature_mutation = 'Vente'
WHERE cp.PTOT > 10000
GROUP BY cp.CODDEP, cp.CODCOM, cp.COM, cp.PTOT
ORDER BY transactions_pour_1000_hab DESC
LIMIT 20;