# oc_tools/load_save.py
import pandas as pd


def delete_duplicated_rows(df: pd.DataFrame) -> pd.DataFrame:
    """Delete duplicated rows from each DataFrame."""
    try:
        nb_duplicates_init = df.duplicated().sum()
        if nb_duplicates_init > 0:
            df.drop_duplicates(inplace=True)
        else:
            print("No duplicated rows found.")
    except Exception as e:
        print(f"An error occurred while deleting duplicated rows: {e}")
    return df


def delete_high_missing_columns(
    df: pd.DataFrame, threshold: float = 0.3
) -> pd.DataFrame:
    """Delete columns with a high percentage of missing values from a DataFrame."""
    try:
        high_missing_col_obj = (df.isnull().mean() > threshold) & (
            df.dtypes != "float64"
        )
        empty_num_col = (df.isnull().mean() == 1.0) & (df.dtypes == "float64")
        if high_missing_col_obj.sum() > 0:
            df.drop(columns=df.columns[high_missing_col_obj], inplace=True)
        else:
            print(f"No high missing object columns found in {df}.")
        if empty_num_col.sum() > 0:
            df.drop(columns=df.columns[empty_num_col], inplace=True)
        else:
            print(f"No empty numeric columns found in {df}.")
    except Exception as e:
        print(f"An error occurred while deleting high missing columns: {e}")
    return df


def first_steps_cleaning(df: pd.DataFrame, missing_threshold: float) -> pd.DataFrame:
    """Perform first steps of cleaning on a DataFrame."""
    df = delete_duplicated_rows(df)
    df = delete_high_missing_columns(df, missing_threshold)
    return df
