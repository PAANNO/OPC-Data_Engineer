from __future__ import annotations

import re
from pathlib import Path

import pandas as pd


def _normalize_col(col: str) -> str:
    col = str(col).strip()
    col = re.sub(r"\s+", " ", col)
    return col


def _pick_first_sheet(xlsx_path: Path) -> str:
    xls = pd.ExcelFile(xlsx_path)
    if not xls.sheet_names:
        raise ValueError(f"No sheets found in {xlsx_path}")
    return xls.sheet_names[0]


def _read_template_columns(template_path: Path) -> list[str]:
    sheet = _pick_first_sheet(template_path)
    df = pd.read_excel(template_path, sheet_name=sheet)

    # If the template has unnamed columns because of formatting, try to recover the header row.
    if any(str(c).startswith("Unnamed:") for c in df.columns):
        raw = pd.read_excel(template_path, sheet_name=sheet, header=None)
        best_row = None
        best_score = -1
        for i in range(min(50, len(raw))):
            row = raw.iloc[i]
            non_null = row.notna().sum()
            strish = sum(1 for v in row.dropna() if isinstance(v, str) and v.strip())
            score = int(non_null) + int(strish)
            if score > best_score:
                best_score = score
                best_row = i
        if best_row is None:
            raise ValueError("Could not detect header row in template")
        header = [v if pd.notna(v) else "" for v in raw.iloc[best_row].tolist()]
        cols = [_normalize_col(c) for c in header if str(c).strip()]
        if cols:
            return cols

    cols = [_normalize_col(c) for c in df.columns.tolist()]
    return [c for c in cols if c]


def _infer_sql_type(series: pd.Series) -> tuple[str, str | None]:
    """Return (sql_type, length_str_or_None)."""
    s = series.dropna()
    if s.empty:
        return "VARCHAR", None

    # datetimes
    if pd.api.types.is_datetime64_any_dtype(s):
        return "DATE", None

    # numeric
    if pd.api.types.is_integer_dtype(s):
        return "INTEGER", None
    if pd.api.types.is_float_dtype(s):
        return "NUMERIC", None
    if pd.api.types.is_bool_dtype(s):
        return "BOOLEAN", None

    # default: text
    s_as_str = s.astype(str)
    max_len = int(s_as_str.str.len().max())
    if max_len <= 0:
        return "VARCHAR", None
    return "VARCHAR", str(max_len)


def _first_example(series: pd.Series) -> str:
    s = series.dropna()
    if s.empty:
        return ""
    v = s.iloc[0]
    if isinstance(v, (pd.Timestamp,)):
        return v.date().isoformat()
    return str(v)


def generate_dictionary(
    template_path: Path,
    referential_path: Path,
    output_csv_path: Path,
    delimiter: str = ";",
    encoding: str = "ISO-8859-1",
) -> None:
    template_cols = _read_template_columns(template_path)

    ref_sheet = _pick_first_sheet(referential_path)
    ref_df = pd.read_excel(referential_path, sheet_name=ref_sheet)

    # Build rows matching the template, best-effort mapping on common French column names.
    rows: list[dict[str, object]] = []

    for col_name in ref_df.columns:
        col_name_norm = _normalize_col(col_name)
        signification = col_name_norm.replace("_", " ")
        series = ref_df[col_name]
        sql_type, length = _infer_sql_type(series)
        nullable = "OUI" if series.isna().any() else "NON"
        example = _first_example(series)

        row: dict[str, object] = {c: "" for c in template_cols}

        def set_if_exists(keys: list[str], value: object) -> None:
            for k in keys:
                if k in row:
                    row[k] = value
                    return

        set_if_exists(
            [
                "CODE",
                "Code",
                "Nom du champ",
                "Nom du champ / variable",
                "Nom variable",
                "Champ",
                "Attribut",
            ],
            col_name_norm,
        )
        set_if_exists(
            [
                "SIGNIFICATION",
                "Signification",
                "Description",
                "Définition",
                "Libellé",
                "Commentaire",
            ],
            signification,
        )
        set_if_exists(["NATURE", "Nature"], "Élémentaire")
        set_if_exists(["TYPE", "Type"], sql_type)
        set_if_exists(
            [
                "LONGUEUR",
                "Longueur",
                "Taille",
                "Longueur (caractères)",
                "Taille (caractères)",
            ],
            length or "",
        )
        set_if_exists(
            [
                "REGLE DE GESTION",
                "Règle de gestion",
                "Null",
                "Nullable",
                "Nullabilité",
                "Obligatoire",
            ],
            "Obligatoire" if nullable == "NON" else "",
        )
        set_if_exists(["REGLE DE CALCUL", "Règle de calcul"], "")
        set_if_exists(["EXEMPLE", "Exemple", "Exemples"], example)
        set_if_exists(["SOURCE", "Source"], referential_path.name)

        rows.append(row)

    out_df = pd.DataFrame(rows, columns=template_cols)
    output_csv_path.parent.mkdir(parents=True, exist_ok=True)
    out_df.to_csv(output_csv_path, index=False, sep=delimiter, encoding=encoding)


def main() -> None:
    base = Path(__file__).resolve().parents[1]
    template_path = base / "docs" / "Template_dico_données+(2)+(1).xlsx"
    referential_path = base / "data" / "raw" / "fr-esr-referentiel-geographique.xlsx"
    output_csv_path = base / "docs" / "dico_données_ref_géo.csv"

    generate_dictionary(
        template_path=template_path,
        referential_path=referential_path,
        output_csv_path=output_csv_path,
        delimiter=";",
        encoding="ISO-8859-1",
    )

    print(f"Wrote: {output_csv_path}")


if __name__ == "__main__":
    main()
