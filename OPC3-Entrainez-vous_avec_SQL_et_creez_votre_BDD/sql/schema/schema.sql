PRAGMA foreign_keys = ON;

-- ---------- STAGING ----------
DROP TABLE IF EXISTS stg_referentiel_geo;
DROP TABLE IF EXISTS stg_donnees_communes;
DROP TABLE IF EXISTS stg_valeurs_foncieres;

CREATE TABLE stg_referentiel_geo (
  regrgp_nom TEXT,
  reg_nom TEXT,
  reg_nom_old TEXT,
  aca_nom TEXT,
  dep_nom TEXT,
  com_code TEXT,
  com_code1 TEXT,
  com_code2 TEXT,
  com_id TEXT,
  com_nom_maj_court TEXT,
  com_nom_maj TEXT,
  com_nom TEXT,
  uu_code TEXT,
  uu_id TEXT,
  uucr_id TEXT,
  uucr_nom TEXT,
  ze_id TEXT,
  dep_code TEXT,
  dep_id TEXT,
  dep_nom_num TEXT,
  dep_num_nom TEXT,
  aca_code TEXT,
  aca_id TEXT,
  reg_code TEXT,
  reg_id TEXT,
  reg_code_old TEXT,
  reg_id_old TEXT,
  fd_id TEXT,
  fr_id TEXT,
  fe_id TEXT,
  uu_id_99 TEXT,
  au_code TEXT,
  au_id TEXT,
  auc_id TEXT,
  auc_nom TEXT,
  uu_id_10 TEXT,
  geolocalisation TEXT
);

CREATE TABLE stg_donnees_communes (
  CODREG TEXT,
  CODDEP TEXT,
  CODARR TEXT,
  CODCAN TEXT,
  CODCOM TEXT,
  COM TEXT,
  PMUN TEXT,
  PCAP TEXT,
  PTOT TEXT
);

CREATE TABLE stg_valeurs_foncieres (
  no_disposition TEXT,
  date_mutation TEXT,
  nature_mutation TEXT,
  valeur_fonciere TEXT,
  no_voie TEXT,
  btq TEXT,
  code_type_de_voie TEXT,
  type_de_voie TEXT,
  code_voie TEXT,
  voie TEXT,
  code_id_commune TEXT,
  code_postal TEXT,
  commune TEXT,
  code_departement TEXT,
  code_commune TEXT,
  prefixe_de_section TEXT,
  section TEXT,
  no_plan TEXT,
  lot_1 TEXT,
  surface_carrez_du_1er_lot TEXT,
  nombre_de_lots TEXT,
  code_type_local TEXT,
  type_local TEXT,
  surface_reelle_bati TEXT,
  nombre_pieces_principales TEXT,
  nature_culture TEXT,
  nature_culture_speciale TEXT,
  surface_terrain TEXT,
  nom_de_l_acquereur TEXT
);

-- ---------- FINAL TABLES ----------
DROP TABLE IF EXISTS valeurs_foncieres;
DROP TABLE IF EXISTS geo_commune_population;
DROP TABLE IF EXISTS geo_commune;
DROP TABLE IF EXISTS geo_departement;
DROP TABLE IF EXISTS geo_academie;
DROP TABLE IF EXISTS geo_region_old;
DROP TABLE IF EXISTS geo_region;
DROP TABLE IF EXISTS ref_type_local;
DROP TABLE IF EXISTS ref_type_voie;

CREATE TABLE ref_type_voie (
  code_type_de_voie INTEGER PRIMARY KEY,
  type_de_voie TEXT NOT NULL
);

CREATE TABLE ref_type_local (
  code_type_local INTEGER PRIMARY KEY,
  type_local TEXT NOT NULL
);

CREATE TABLE geo_region (
  reg_code INTEGER PRIMARY KEY,
  reg_id TEXT,
  reg_nom TEXT NOT NULL,
  regrgp_nom TEXT NOT NULL
);

CREATE TABLE geo_region_old (
  reg_code_old INTEGER PRIMARY KEY,
  reg_id_old TEXT,
  reg_nom_old TEXT NOT NULL
);

CREATE TABLE geo_academie (
  aca_code INTEGER PRIMARY KEY,
  aca_id TEXT,
  aca_nom TEXT NOT NULL
);

CREATE TABLE geo_departement (
  dep_code TEXT PRIMARY KEY,
  dep_id TEXT,
  dep_nom TEXT NOT NULL,
  dep_nom_num TEXT,
  dep_num_nom TEXT,
  reg_code INTEGER NOT NULL,
  reg_code_old INTEGER,
  FOREIGN KEY (reg_code) REFERENCES geo_region(reg_code),
  FOREIGN KEY (reg_code_old) REFERENCES geo_region_old(reg_code_old)
);

CREATE TABLE geo_commune (
  com_code TEXT,
  com_code1 TEXT,
  com_code2 TEXT,
  com_id TEXT,

  com_nom TEXT NOT NULL,
  com_nom_maj TEXT,
  com_nom_maj_court TEXT,

  dep_code TEXT NOT NULL,
  aca_code INTEGER,

  uu_code TEXT,
  uu_id TEXT,
  uucr_id TEXT,
  uucr_nom TEXT,
  ze_id TEXT,

  au_code INTEGER,
  au_id TEXT,
  auc_id TEXT,
  auc_nom TEXT,

  fd_id TEXT,
  fr_id TEXT,
  fe_id TEXT,

  uu_id_99 TEXT,
  uu_id_10 TEXT,

  latitude REAL,
  longitude REAL,

  PRIMARY KEY ( dep_code, com_code),

  FOREIGN KEY (dep_code) REFERENCES geo_departement(dep_code),
  FOREIGN KEY (aca_code) REFERENCES geo_academie(aca_code)
);

CREATE TABLE geo_commune_population (
  CODREG TEXT NOT NULL,
  CODDEP TEXT NOT NULL,
  CODARR INTEGER,
  CODCAN TEXT,
  CODCOM TEXT NOT NULL,
  COM TEXT NOT NULL,
  PMUN INTEGER NOT NULL,
  PCAP INTEGER NOT NULL,
  PTOT INTEGER NOT NULL,
  PRIMARY KEY (CODDEP, CODCOM),
  CHECK (PTOT = PMUN + PCAP),
  FOREIGN KEY (CODDEP, CODCOM) REFERENCES geo_commune(dep_code, com_code)
);

CREATE TABLE valeurs_foncieres (
  no_disposition INTEGER NOT NULL,
  date_mutation TEXT NOT NULL,
  nature_mutation TEXT,
  valeur_fonciere REAL,

  no_voie INTEGER,
  btq TEXT,
  code_type_de_voie INTEGER,
  code_voie TEXT,
  voie TEXT,

  code_id_commune INTEGER,
  code_postal TEXT,
  commune TEXT,

  code_departement TEXT NOT NULL,
  code_commune TEXT NOT NULL,

  prefixe_de_section TEXT,
  section TEXT,
  no_plan TEXT,

  lot_1 TEXT,
  surface_carrez_du_1er_lot REAL,
  nombre_de_lots INTEGER,

  code_type_local INTEGER,
  surface_reelle_bati REAL,
  nombre_pieces_principales INTEGER,

  nature_culture TEXT,
  nature_culture_speciale TEXT,
  surface_terrain REAL,

  nom_de_l_acquereur TEXT,

  PRIMARY KEY (date_mutation, no_disposition, code_departement, code_commune, prefixe_de_section, section, no_plan, no_voie, code_voie),

  FOREIGN KEY (code_type_de_voie) REFERENCES ref_type_voie(code_type_de_voie),
  FOREIGN KEY (code_type_local) REFERENCES ref_type_local(code_type_local),
  FOREIGN KEY (code_departement, code_commune) REFERENCES geo_commune(dep_code, com_code)
);