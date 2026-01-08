# oc_tools/load_save.py
import pandas as pd
import numpy as np


def describe_numeric_columns(dataframe: pd.DataFrame) -> None:
    """Print descriptive statistics of numeric columns in a DataFrame."""
    try:
        numeric_cols = dataframe.select_dtypes(include=["number"]).columns.tolist()
        if numeric_cols:
            print("Descriptive statistics for numeric columns:")
            print(dataframe[numeric_cols].describe())
        else:
            print("No numeric columns found.")
    except Exception as e:
        print(f"An error occurred while describing numeric columns: {e}")


def describe_categorical_columns(dataframe: pd.DataFrame) -> None:
    """Print descriptive statistics of categorical columns in a DataFrame."""
    try:
        categorical_cols = dataframe.select_dtypes(
            include=["object", "category"]
        ).columns.tolist()
        if categorical_cols:
            print("Descriptive statistics for categorical columns:")
            for col in categorical_cols:
                print(
                    f"Column '{col}' value counts:\n{dataframe[col].value_counts()}\n"
                )
        else:
            print("No categorical columns found.")
    except Exception as e:
        print(f"An error occurred while describing categorical columns: {e}")


def collect_basic_info(dataframe: pd.DataFrame) -> None:
    """Print basic info of a DataFrame."""
    try:
        nb_rows, nb_columns = dataframe.shape
        print(f"This dataframe has {nb_rows} rows and {nb_columns} columns.")

        # Describe numeric columns
        describe_numeric_columns(dataframe)

        # Describe categorical columns
        describe_categorical_columns(dataframe)
    except Exception as e:
        print(f"An error occurred while collecting basic info: {e}")


def corr_pearson(dataframe: pd.DataFrame):
    """Calculate and return the Pearson correlation matrix of a DataFrame."""
    try:

        correlation_matrix = dataframe.corr(method="pearson")
        return correlation_matrix
    except Exception as e:
        print(f"An error occurred while calculating Pearson correlation: {e}")


def weighted_recent_mean(g, half_life=5):
    """Calculate the weighted recent mean of 'Value' in DataFrame g, where weights decrease exponentially with age based on the specified half-life."""
    try:
        g = g.dropna(subset=["Value"]).sort_values("Year")
        g["Year"] = pd.to_numeric(g["Year"], errors="coerce")
        if g.empty:
            return np.nan
        ymax = g["Year"].iloc[-1]
        age = (ymax - g["Year"]).to_numpy()
        w = 0.5 ** (age / half_life)
        return np.average(g["Value"].to_numpy(), weights=w)
    except Exception as e:
        print(f"An error occurred while calculating weighted recent mean: {e}")
        return np.nan
