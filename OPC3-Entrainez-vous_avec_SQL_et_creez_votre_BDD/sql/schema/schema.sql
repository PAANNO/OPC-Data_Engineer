BEGIN;

-- === Référentiels valeurs foncieres
CREATE TABLE ref_type_voie (
  code_type_de_voie SMALLINT PRIMARY KEY,
  type_de_voie      VARCHAR(10) NOT NULL
);

CREATE TABLE ref_type_local (
  code_type_local SMALLINT PRIMARY KEY,
  type_local      VARCHAR(60) NOT NULL
);

-- === Géographie
CREATE TABLE geo_region (
  reg_code    SMALLINT PRIMARY KEY,
  reg_id      VARCHAR(10),
  reg_nom     VARCHAR(100) NOT NULL,
  regrgp_nom  VARCHAR(20)  NOT NULL
);

CREATE TABLE geo_region_old (
  reg_code_old SMALLINT PRIMARY KEY,
  reg_id_old   VARCHAR(10),
  reg_nom_old  VARCHAR(100) NOT NULL
);

CREATE TABLE geo_academie (
  aca_code SMALLINT PRIMARY KEY,
  aca_id   VARCHAR(10),
  aca_nom  VARCHAR(100) NOT NULL
);

CREATE TABLE geo_departement (
  dep_code     VARCHAR(3) PRIMARY KEY,
  dep_id       VARCHAR(10),
  dep_nom      VARCHAR(100) NOT NULL,
  dep_nom_num  VARCHAR(200),
  dep_num_nom  VARCHAR(200),
  reg_code     SMALLINT NOT NULL REFERENCES geo_region(reg_code),
  reg_code_old SMALLINT REFERENCES geo_region_old(reg_code_old)
);

CREATE TABLE geo_commune (
  com_code          VARCHAR(6) PRIMARY KEY,
  com_code1         VARCHAR(3),
  com_code2         VARCHAR(3),
  com_id            VARCHAR(10),

  com_nom           VARCHAR(200) NOT NULL,
  com_nom_maj       VARCHAR(200),
  com_nom_maj_court VARCHAR(200),

  dep_code          VARCHAR(3) NOT NULL REFERENCES geo_departement(dep_code),
  aca_code          SMALLINT REFERENCES geo_academie(aca_code),

  uu_code   VARCHAR(10),
  uu_id     VARCHAR(10),
  uu_id_99  VARCHAR(10),
  uu_id_10  VARCHAR(10),

  uucr_id   VARCHAR(10),
  uucr_nom  VARCHAR(200),

  ze_id     VARCHAR(10),

  au_code   INTEGER,
  au_id     VARCHAR(10),
  auc_id    VARCHAR(10),
  auc_nom   VARCHAR(200),

  fd_id     VARCHAR(10),
  fr_id     VARCHAR(10),
  fe_id     VARCHAR(10),

  geolocalisation VARCHAR(50),
  latitude        NUMERIC(9,6),
  longitude       NUMERIC(9,6),

  CONSTRAINT uq_commune_dep_com UNIQUE (dep_code, com_code2)
);

-- === Population
CREATE TABLE geo_commune_population (
  codreg VARCHAR(2) NOT NULL,
  coddep VARCHAR(3) NOT NULL,
  codarr SMALLINT,
  codcan VARCHAR(5),
  codcom VARCHAR(3) NOT NULL,
  com    VARCHAR(100) NOT NULL,
  pmun   INTEGER NOT NULL,
  pcap   INTEGER NOT NULL,
  ptot   INTEGER NOT NULL,

  PRIMARY KEY (coddep, codcom),
  CONSTRAINT chk_ptot_calc CHECK (ptot = (pmun + pcap)),
  CONSTRAINT fk_pop_commune
    FOREIGN KEY (coddep, codcom)
    REFERENCES geo_commune(dep_code, com_code2)
);

-- === Valeurs foncières (vente / disposition)
CREATE TABLE vf_vente (
  no_disposition INTEGER NOT NULL,
  date_mutation  DATE    NOT NULL,
  nature_mutation VARCHAR(50),
  valeur_fonciere NUMERIC(15,2),

  no_voie INTEGER,
  btq    CHAR(1),
  code_type_de_voie SMALLINT REFERENCES ref_type_voie(code_type_de_voie),
  code_voie VARCHAR(4),
  voie      VARCHAR(200),

  code_id_commune INTEGER,
  code_postal VARCHAR(5),
  commune     VARCHAR(200),

  code_departement VARCHAR(3) NOT NULL,
  code_commune     VARCHAR(3) NOT NULL,

  prefixe_de_section VARCHAR(5),
  section            VARCHAR(5),
  no_plan            VARCHAR(10),

  lot_1 VARCHAR(50),
  surface_carrez_du_1er_lot NUMERIC(10,2),
  nombre_de_lots INTEGER,

  code_type_local SMALLINT REFERENCES ref_type_local(code_type_local),
  surface_reelle_bati NUMERIC(10,2),
  nombre_pieces_principales INTEGER,

  nature_culture VARCHAR(50),
  nature_culture_speciale VARCHAR(50),
  surface_terrain NUMERIC(12,2),

  nom_de_l_acquereur VARCHAR(255),

  CONSTRAINT fk_vente_commune
    FOREIGN KEY (code_departement, code_commune)
    REFERENCES geo_commune(dep_code, com_code2),

  CONSTRAINT pk_dvf_vente PRIMARY KEY
    (date_mutation, no_disposition, code_departement, code_commune, prefixe_de_section, section, no_plan, no_voie, code_voie)
);

COMMIT;
