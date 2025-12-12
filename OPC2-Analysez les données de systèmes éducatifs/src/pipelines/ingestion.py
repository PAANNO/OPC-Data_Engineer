from pathlib import Path
import sys

current_file = Path(__file__).resolve()
repo_root = current_file.parents[3]
project_root = current_file.parents[2]
if str(repo_root) not in sys.path:
    sys.path.insert(0, str(repo_root))
import pandas as pd
from oc_tools import cleaning as cln
from oc_tools import exploration as exp
from oc_tools import load_save as ls


RAW_DATA_DIR = project_root / "data" / "raw"
print(f"Raw data directory set to: {RAW_DATA_DIR}")


def list_raw_data_files(raw_path: Path) -> list[str]:
    """List all CSV files in the raw data directory."""
    files_list = list(raw_path.glob("*.csv"))
    print(f"Found {len(files_list)} raw data files.")
    return [file.name for file in files_list]


def load_raw_data(files: list[str], raw_path: Path) -> dict[str, pd.DataFrame]:
    """Load raw data CSV files into a dictionary of DataFrames."""
    dataframes = {}
    for file in files:
        df = pd.read_csv(raw_path / file)
        dataframes[str(file)] = df
    print(f"Loaded {len(dataframes)} DataFrames from raw data files.")
    return dataframes


def print_dfs_head(dataframes: dict[str, pd.DataFrame]) -> None:
    """Print the first 5 rows of each DataFrame in the dictionary."""
    for file_name, df in dataframes.items():
        print(f"First 5 rows of {file_name}:")
        print(df.head())
        print("\n")
    print("Displayed head of all DataFrames.")


def display_dfs_info(dataframes: dict[str, pd.DataFrame]) -> None:
    """Display info of each DataFrame in the dictionary."""
    for file_name, df in dataframes.items():
        print(f"Info of {file_name}:")
        collect_basic_info(df)
        print("\n")
    print("Displayed info of all DataFrames.")


def delete_empty_colums(dataframe: pd.DataFrame) -> None:
    """Delete empty columns from a DataFrame."""
    empty_col = dataframe.isnull().mean() == 1.0
    dataframe.drop(columns=dataframe.columns[empty_col], inplace=True)


def delete_duplicated_rows(dataframes: dict[str, pd.DataFrame]) -> None:
    """Delete duplicated rows from each DataFrame."""
    for file_name, df in dataframes.items():
        initial_count = df.shape[0]
        df.drop_duplicates(inplace=True)
        print(
            f"Deleted {initial_count - df.shape[0]} duplicated rows from {file_name}."
        )


def collect_basic_info(dataframe: pd.DataFrame) -> None:
    """Collect and print basic info of a DataFrame."""
    nb_rows, nb_columns = dataframe.shape
    print(f"{dataframe.index} has {nb_rows} rows and {nb_columns} columns.")

    # Search and delete duplicated rows
    nb_duplicates_init = dataframe.duplicated().sum()
    print(f"Number of duplicated rows: {nb_duplicates_init}")
    if nb_duplicates_init > 0:
        dataframe.drop_duplicates(inplace=True)
        nb_duplicates_final = dataframe.duplicated().sum()
        print(f"Number of duplicated rows after deletion: {nb_duplicates_final}")

    # Search and delete empty columns
    nb_empty_columns_init = (dataframe.isnull().mean() == 1.0).sum()
    print(f"Number of empty columns: {nb_empty_columns_init}")
    if nb_empty_columns_init > 0:
        delete_empty_colums(dataframe)
        nb_empty_columns_final = (dataframe.isnull().mean() == 1.0).sum()
        print(f"Number of empty columns after deletion: {nb_empty_columns_final}")

    # Search for numeric columns
    nb_numeric_columns = dataframe.select_dtypes(include=["number"]).shape[1]
    print(f"Number of numeric columns: {nb_numeric_columns}")
    if nb_numeric_columns > 0:
        numeric_cols = dataframe.select_dtypes(include=["number"]).columns.tolist()
        dataframe[numeric_cols].describe()

    # Search for categorical columns
    nb_categorical_columns = dataframe.select_dtypes(
        include=["object", "category"]
    ).shape[1]
    print(f"Number of categorical columns: {nb_categorical_columns}")
    if nb_categorical_columns > 0:
        categorical_cols = dataframe.select_dtypes(
            include=["object", "category"]
        ).columns.tolist()
        for col in categorical_cols:
            print(f"Column '{col}' value counts:\n{dataframe[col].value_counts()}\n")


if __name__ == "__main__":
    files = ls.list_raw_data_files(RAW_DATA_DIR)
    dataframes = ls.load_all_raw_data(files, RAW_DATA_DIR)
    for df in dataframes.values():
        df.info()
    # print_dfs_head(dataframes)
    """for df in dataframes.values():
        collect_basic_info(df)"""
    # cln.first_steps_cleaning(dataframes["EdStatsCountry-Series.csv"], 0.8)
    # exp.collect_basic_info(dataframes["EdStatsCountry-Series.csv"])
