"""Helper functions to load and filter the World Bank EdStats extracts."""


from pathlib import Path

import pandas as pd


RAW_DATA_DIR = Path(__file__).resolve().parents[1] / "data" / "raw"


def _csv_path(name: str) -> Path:
    """Return the absolute path to a CSV sitting under data/raw."""

    return RAW_DATA_DIR / name


def load_countries() -> pd.DataFrame:
    """Load the EdStatsCountry table as-is."""

    return pd.read_csv(_csv_path("EdStatsCountry.csv"))


def load_country_series() -> pd.DataFrame:
    """Load the EdStatsCountry-Series table as-is."""

    return pd.read_csv(_csv_path("EdStatsCountry-Series.csv"))


def load_data() -> pd.DataFrame:
    """Load the EdStatsData fact table as-is."""

    return pd.read_csv(_csv_path("EdStatsData.csv"))


def load_footnotes() -> pd.DataFrame:
    """Load the EdStatsFootNote table as-is."""

    return pd.read_csv(_csv_path("EdStatsFootNote.csv"))


def load_series() -> pd.DataFrame:
    """Load the EdStatsSeries table as-is."""

    return pd.read_csv(_csv_path("EdStatsSeries.csv"))


def filter_countries(country_df: pd.DataFrame) -> pd.DataFrame:
    """Keep rows whose Region value is filled (heuristic for real countries)."""

    region = country_df.get("Region")
    if region is None:
        return country_df.copy()
    mask = region.notna() & (region != "")
    return country_df.loc[mask].copy()


def get_valid_country_codes(country_df: pd.DataFrame) -> pd.Index:
    """Return the list of country codes present after filtering."""

    codes = filter_countries(country_df)["Country Code"].dropna().unique()
    return pd.Index(codes)


def filter_country_series(
    country_series_df: pd.DataFrame, valid_codes: pd.Index
) -> pd.DataFrame:
    """Keep only rows with a CountryCode present in valid_codes."""

    mask = country_series_df["CountryCode"].isin(valid_codes)
    return country_series_df.loc[mask].copy()


def filter_footnotes(footnote_df: pd.DataFrame, valid_codes: pd.Index) -> pd.DataFrame:
    """Keep footnotes that reference real countries."""

    mask = footnote_df["CountryCode"].isin(valid_codes)
    return footnote_df.loc[mask].copy()


def filter_data(data_df: pd.DataFrame, valid_codes: pd.Index) -> pd.DataFrame:
    """Keep fact rows tied to real countries."""

    mask = data_df["CountryCode"].isin(valid_codes)
    return data_df.loc[mask].copy()
