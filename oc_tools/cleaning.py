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

def delete_high_missing_columns(df: pd.DataFrame, threshold: float) -> None:
    """Delete columns with a high percentage of missing values from a DataFrame."""
    try:
        nb_high_missing_col = (df.isnull().mean() > threshold).sum()
        if nb_high_missing_col > 0:
            missing_ratio = df.isnull().mean()
            cols_to_drop = missing_ratio[missing_ratio > threshold].index
            df.drop(columns=cols_to_drop, inplace=True)
        else:
            print("No columns with high missing values found.")
    except Exception as e:
        print(f"An error occurred while deleting high missing columns: {e}")

def first_steps_cleaning(df: pd.DataFrame, missing_threshold: float) -> None:
    """Perform first steps of cleaning on a DataFrame."""
    delete_duplicated_rows(df)
    delete_high_missing_columns(df, missing_threshold)