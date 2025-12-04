from pathlib import Path
from IPython.display import display
import pandas as pd


RAW_DATA_DIR = Path().resolve() / "data" / "raw"
print(f"Raw data directory set to: {RAW_DATA_DIR}")


def list_raw_data_files() -> list[str]:
    """List all CSV files in the raw data directory."""
    files_list = list(RAW_DATA_DIR.glob("*.csv"))
    print(f"Found {len(files_list)} raw data files.")
    return [file.name for file in files_list]


def load_raw_data(files: list[str]) -> dict[str, pd.DataFrame]:
    """Load raw data CSV files into a dictionary of DataFrames."""
    dataframes = {}
    for file in files:
        df = pd.read_csv(RAW_DATA_DIR / file)
        dataframes[str(file)] = df
    print(f"Loaded {len(dataframes)} DataFrames from raw data files.")
    return dataframes


def print_dfs_head(dataframes: dict[str, pd.DataFrame]) -> None:
    """Print the first n rows of each DataFrame in the dictionary."""
    for file_name, df in dataframes.items():
        print(f"First 5 rows of {file_name}:")
        display(df.head())
        print("\n")
    print("Displayed head of all DataFrames.")


def display_dfs_info(dataframes: dict[str, pd.DataFrame]) -> None:
    """Display info of each DataFrame in the dictionary."""
    for file_name, df in dataframes.items():
        print(f"Info of {file_name}:")
        print(f"number of rows: {df.shape[0]}")
        print(f"number of columns: {df.shape[1]}")
        print(f"duplicated rows: {df.duplicated().sum()}")
        print(f"missing values per column:\n{df.isnull().sum()}")
        print("\n")
    print("Displayed info of all DataFrames.")


def delete_last_unnamed_column(dataframes: dict[str, pd.DataFrame]) -> None:
    """Delete the last unnamed column from each DataFrame if it exists."""
    for file_name, df in dataframes.items():
        if df.columns[-1].startswith("Unnamed"):
            df.drop(columns=[df.columns[-1]], inplace=True)
            print(f"Deleted last unnamed column from {file_name}.")


def delete_duplicated_rows(dataframes: dict[str, pd.DataFrame]) -> None:
    """Delete duplicated rows from each DataFrame."""
    for file_name, df in dataframes.items():
        initial_count = df.shape[0]
        df.drop_duplicates(inplace=True)
        print(
            f"Deleted {initial_count - df.shape[0]} duplicated rows from {file_name}."
        )


if __name__ == "__main__":
    files = list_raw_data_files()
    dataframes = load_raw_data(files)
    # print_dfs_head(dataframes)
    delete_last_unnamed_column(dataframes)
    display_dfs_info(dataframes)
    delete_duplicated_rows(dataframes)
    display_dfs_info(dataframes)
