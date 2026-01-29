# oc_tools/load_save.py
from pathlib import Path
import pandas as pd


def list_raw_data_files(raw_path: Path) -> list[str]:
    """List all CSV files in the raw data directory."""
    files_list = list(raw_path.glob("*.csv"))
    return [file.name for file in files_list]


def load_all_raw_data(files: list[str], raw_path: Path) -> dict[str, pd.DataFrame]:
    """Load raw data CSV files into a dictionary of DataFrames."""
    dfs = {}
    for file in files:
        df = pd.read_csv(raw_path / file)
        dfs[str(file)] = df
    return dfs
