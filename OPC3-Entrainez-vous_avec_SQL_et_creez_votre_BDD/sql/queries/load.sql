PRAGMA foreign_keys = ON;

-- Ref DVF
INSERT OR IGNORE INTO ref_type_voie(code_type_de_voie, type_de_voie)
SELECT DISTINCT CAST(NULLIF(code_type_de_voie,'') AS INTEGER), type_de_voie
FROM stg_valeurs_foncieres
WHERE NULLIF(code_type_de_voie,'') IS NOT NULL;

INSERT OR IGNORE INTO ref_type_local(code_type_local, type_local)
SELECT DISTINCT CAST(NULLIF(code_type_local,'') AS INTEGER), type_local
FROM stg_valeurs_foncieres
WHERE NULLIF(code_type_local,'') IS NOT NULL;

-- Geo
INSERT OR IGNORE INTO geo_region(reg_code, reg_id, reg_nom, regrgp_nom)
SELECT DISTINCT CAST(NULLIF(reg_code,'') AS INTEGER), NULLIF(reg_id,''), reg_nom, regrgp_nom
FROM stg_referentiel_geo
WHERE NULLIF(reg_code,'') IS NOT NULL;

INSERT OR IGNORE INTO geo_region_old(reg_code_old, reg_id_old, reg_nom_old)
SELECT DISTINCT CAST(NULLIF(reg_code_old,'') AS INTEGER), NULLIF(reg_id_old,''), reg_nom_old
FROM stg_referentiel_geo
WHERE NULLIF(reg_code_old,'') IS NOT NULL;

INSERT OR IGNORE INTO geo_academie(aca_code, aca_id, aca_nom)
SELECT DISTINCT CAST(NULLIF(aca_code,'') AS INTEGER), NULLIF(aca_id,''), aca_nom
FROM stg_referentiel_geo
WHERE NULLIF(aca_code,'') IS NOT NULL;

INSERT OR IGNORE INTO geo_departement(dep_code, dep_id, dep_nom, dep_nom_num, dep_num_nom, reg_code, reg_code_old)
SELECT DISTINCT
  CASE
    WHEN dep_code GLOB '*[^0-9]*' THEN dep_code              -- ex: 2A, 2B
    WHEN length(dep_code) = 1 THEN printf('%02d', CAST(dep_code AS INTEGER))  -- 1 -> 01
    ELSE dep_code
  END AS dep_code,
  NULLIF(dep_id,''),
  dep_nom,
  NULLIF(dep_nom_num,''),
  NULLIF(dep_num_nom,''),
  CAST(NULLIF(reg_code,'') AS INTEGER),
  CAST(NULLIF(reg_code_old,'') AS INTEGER)
FROM stg_referentiel_geo
WHERE NULLIF(dep_code,'') IS NOT NULL;

INSERT OR IGNORE INTO geo_commune(
  com_code, com_code1, com_code2, com_id,
  com_nom, com_nom_maj, com_nom_maj_court,
  dep_code, aca_code,
  uu_code, uu_id, uucr_id, uucr_nom, ze_id,
  au_code, au_id, auc_id, auc_nom,
  fd_id, fr_id, fe_id,
  uu_id_99, uu_id_10,
  latitude, longitude
)
SELECT DISTINCT
  substr(com_code, length(com_code) - 2, 3) AS com_code,
  com_code1, com_code2, com_id,
  com_nom, com_nom_maj, com_nom_maj_court,
  CASE
    WHEN dep_code GLOB '*[^0-9]*' THEN dep_code              -- ex: 2A, 2B
    WHEN length(dep_code) = 1 THEN printf('%02d', CAST(dep_code AS INTEGER))  -- 1 -> 01
    ELSE dep_code
  END AS dep_code,
  CAST(NULLIF(aca_code,'') AS INTEGER),
  NULLIF(uu_code,''), NULLIF(uu_id,''), NULLIF(uucr_id,''), NULLIF(uucr_nom,''), NULLIF(ze_id,''),
  CAST(NULLIF(au_code,'') AS INTEGER), NULLIF(au_id,''), NULLIF(auc_id,''), NULLIF(auc_nom,''),
  NULLIF(fd_id,''), NULLIF(fr_id,''), NULLIF(fe_id,''),
  NULLIF(uu_id_99,''), NULLIF(uu_id_10,''),
  -- latitude = avant la virgule
  CASE
    WHEN geolocalisation IS NULL OR geolocalisation = '' OR instr(geolocalisation, ',') = 0 THEN NULL
    ELSE CAST(trim(substr(geolocalisation, instr(geolocalisation, ',') - 1)) AS REAL)
  END,
  -- longitude = après la virgule
  CASE
    WHEN geolocalisation IS NULL OR geolocalisation = '' OR instr(geolocalisation, ',') = 0 THEN NULL
    ELSE CAST(trim(substr(geolocalisation, 1, instr(geolocalisation, ',') + 1)) AS REAL)
  END
FROM stg_referentiel_geo
WHERE NULLIF(com_code,'') IS NOT NULL;

-- Population
INSERT OR IGNORE INTO geo_commune_population(CODREG, CODDEP, CODARR, CODCAN, CODCOM, COM, PMUN, PCAP, PTOT)
SELECT
  CODREG,
  CODDEP,
  CAST(NULLIF(CODARR,'') AS INTEGER),
  NULLIF(CODCAN,''),
  CASE
    WHEN CODCOM GLOB '*[^0-9]*' THEN CODCOM
    ELSE printf('%03d', CAST(CODCOM AS INTEGER))
  END,
  COM,
  CAST(NULLIF(PMUN,'') AS INTEGER),
  CAST(NULLIF(PCAP,'') AS INTEGER),
  CAST(NULLIF(PTOT,'') AS INTEGER)
FROM stg_donnees_communes;

-- Valeurs foncières (code_commune sur 3 caractères si numérique)
INSERT OR IGNORE INTO valeurs_foncieres(
  no_disposition, date_mutation, nature_mutation, valeur_fonciere,
  no_voie, btq, code_type_de_voie, code_voie, voie,
  code_id_commune, code_postal, commune,
  code_departement, code_commune,
  prefixe_de_section, section, no_plan,
  lot_1, surface_carrez_du_1er_lot, nombre_de_lots,
  code_type_local, surface_reelle_bati, nombre_pieces_principales,
  nature_culture, nature_culture_speciale, surface_terrain,
  nom_de_l_acquereur
)
SELECT
  CAST(NULLIF(no_disposition,'') AS INTEGER),
  date_mutation,
  nature_mutation,
  CAST(NULLIF(valeur_fonciere,'') AS REAL),
  CAST(NULLIF(no_voie,'') AS INTEGER),
  NULLIF(btq,''),
  CAST(NULLIF(code_type_de_voie,'') AS INTEGER),
  NULLIF(code_voie,''),
  NULLIF(voie,''),
  CAST(NULLIF(code_id_commune,'') AS INTEGER),
  NULLIF(code_postal,''),
  NULLIF(commune,''),
  NULLIF(code_departement,''),
  CASE
    WHEN code_commune GLOB '*[^0-9]*' THEN code_commune
    ELSE printf('%03d', CAST(code_commune AS INTEGER))
  END,
  NULLIF(prefixe_de_section,''),
  NULLIF(section,''),
  NULLIF(no_plan,''),
  NULLIF(lot_1,''),
  CAST(NULLIF(surface_carrez_du_1er_lot,'') AS REAL),
  CAST(NULLIF(nombre_de_lots,'') AS INTEGER),
  CAST(NULLIF(code_type_local,'') AS INTEGER),
  CAST(NULLIF(surface_reelle_bati,'') AS REAL),
  CAST(NULLIF(nombre_pieces_principales,'') AS INTEGER),
  NULLIF(nature_culture,''),
  NULLIF(nature_culture_speciale,''),
  CAST(NULLIF(surface_terrain,'') AS REAL),
  NULLIF(nom_de_l_acquereur,'')
FROM stg_valeurs_foncieres;