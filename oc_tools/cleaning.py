# oc_tools/cleaning.py
import logging
import os
from pathlib import Path

import pandas as pd

logger = logging.getLogger(__name__)


def _configure_logger() -> None:
    """Configure un logger fichier dans ./logs ou dans OC_TOOLS_LOG_DIR."""
    if logger.handlers:
        return

    log_dir = Path(os.getenv("OC_TOOLS_LOG_DIR", Path.cwd() / "logs"))
    log_dir.mkdir(parents=True, exist_ok=True)
    log_file = log_dir / "OPC2.log"

    handler = logging.FileHandler(log_file, encoding="utf-8")
    formatter = logging.Formatter(
        "%(asctime)s %(levelname)s [%(module)s.%(funcName)s:%(lineno)d] %(message)s"
    )
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)


_configure_logger()


def uniformize_column_names(name: str, df: pd.DataFrame) -> pd.DataFrame:
    """Uniformise les noms des colonnes (espaces, IndicatorCode -> SeriesCode)."""
    try:
        original_columns = df.columns.tolist()
        df.columns = df.columns.str.replace(" ", "")
        renamed_indicator = False
        if "IndicatorCode" in df.columns:
            df.rename(columns={"IndicatorCode": "SeriesCode"}, inplace=True)
            renamed_indicator = True

        if original_columns != df.columns.tolist():
            logger.info(
                "Colonnes de %s uniformisées (espaces supprimés%s).",
                name,
                " et IndicatorCode renommé en SeriesCode" if renamed_indicator else "",
            )
        else:
            logger.info("Aucune modification de colonnes nécessaire dans %s.", name)
    except Exception as e:
        logger.error("Erreur lors de l'uniformisation des colonnes de %s: %s", name, e)
    return df


def delete_duplicated_rows(
    name: str, df: pd.DataFrame, subset: tuple | list | None = None
) -> pd.DataFrame:
    """Supprime les doublons d'un DataFrame (optionnellement sur un sous-ensemble de colonnes)."""
    try:
        subset_cols = (
            list(subset)
            if subset and all(col in df.columns for col in subset)
            else None
        )
        if subset_cols and name == "footnote":
            subset_cols.append("Year")
        nb_rows_init = df.shape[0]
        nb_duplicates = df.duplicated(subset=subset_cols).sum()
        if nb_duplicates > 0:
            df.drop_duplicates(subset=subset_cols, inplace=True)
            logger.info(
                "Suppression de %s doublons dans %s.", nb_rows_init - df.shape[0], name
            )
        else:
            logger.info("Aucun doublon trouve dans %s.", name)
    except Exception as e:
        logger.error("Erreur lors de la suppression des doublons dans %s: %s", name, e)
    return df


def delete_high_missing_columns(
    name: str, df: pd.DataFrame, threshold: float = 0.7
) -> pd.DataFrame:
    """Supprime les colonnes trop manquantes ou vides selon un seuil."""
    try:
        high_missing_mask = (df.isnull().mean() >= threshold) & (
            ~df.dtypes.apply(pd.api.types.is_numeric_dtype)
        )
        empty_mask = df.isnull().mean() == 1.0

        cols_high_missing = df.columns[high_missing_mask].tolist()
        cols_empty = df.columns[empty_mask].tolist()
        cols_to_drop = cols_high_missing + cols_empty
        cols_to_drop = list(dict.fromkeys(cols_to_drop))
        if cols_to_drop:
            df.drop(columns=cols_to_drop, inplace=True)
            logger.info(
                "Suppression de %s colonnes (trop manquantes ou vides) dans %s.",
                len(cols_to_drop),
                name,
            )
        else:
            logger.info("Aucune colonne a supprimer dans %s.", name)
    except Exception as e:
        logger.error(
            "Erreur lors de la suppression des colonnes trop manquantes ou vides dans %s: %s",
            name,
            e,
        )
    return df


def delete_empty_row(name: str, df: pd.DataFrame) -> pd.DataFrame:
    """Supprime les lignes vides dans les colonnes des années."""
    try:
        year_col = [col for col in df.columns if col.isdigit()]
        if year_col:
            empty_rows = df[year_col].isna().all(axis=1)
            removed = empty_rows.sum()
            if removed > 0:
                df.drop(index=df[empty_rows].index, inplace=True)
                logger.info("Suppression de %s lignes vides dans %s.", removed, name)
            else:
                logger.info("Aucune ligne vide trouvee dans %s.", name)
        else:
            logger.info("Aucune colonne numerique presente dans %s.", name)
    except Exception as e:
        logger.error(
            "Erreur lors de la suppression des lignes vides dans %s: %s", name, e
        )
    return df


def first_steps_cleaning(
    name: str,
    df: pd.DataFrame,
    missing_threshold: float = 0.3,
    dedup_subset: tuple | list | None = None,
) -> pd.DataFrame:
    """Nettoyage de base : doublons puis colonnes trop manquantes."""
    df = delete_duplicated_rows(name, df, subset=dedup_subset)
    df = delete_high_missing_columns(name, df, missing_threshold)
    df = delete_empty_row(name, df)
    return df
