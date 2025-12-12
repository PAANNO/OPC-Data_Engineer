# oc_tools/load_save.py
import pandas as pd


def delete_duplicated_rows(df: pd.DataFrame) -> None:
    """Delete duplicated rows from each DataFrame."""
    try:
        nb_duplicates_init = df.duplicated().sum()
        if nb_duplicates_init > 0:
            df.drop_duplicates(inplace=True)
        else:
            print("No duplicated rows found.")
    except Exception as e:
        print(f"An error occurred while deleting duplicated rows: {e}")


def delete_empty_colums(df: pd.DataFrame) -> None:
    """Delete empty columns from a DataFrame."""
    try:
        empty_col = df.isnull().mean() == 1.0
        if empty_col.sum() > 0:
            df.drop(columns=df.columns[empty_col], inplace=True)
        else:
            print("No empty columns found.")
    except Exception as e:
        print(f"An error occurred while deleting empty columns: {e}")


def delete_high_missing_columns(df: pd.DataFrame, threshold: float) -> None:
    """Delete columns with a high percentage of missing values from a DataFrame."""
    try:
        high_missing_col = (df.isnull().mean() > threshold) & (df.dtypes != "float64")
        if high_missing_col.sum() > 0:
            df.drop(columns=df.columns[high_missing_col], inplace=True)
        else:
            print("No columns with high missing values found.")
    except Exception as e:
        print(f"An error occurred while deleting high missing columns: {e}")


def first_steps_cleaning(df: pd.DataFrame, missing_threshold: float) -> None:
    """Perform first steps of cleaning on a DataFrame."""
    delete_duplicated_rows(df)
    delete_empty_colums(df)
    delete_high_missing_columns(df, missing_threshold)
