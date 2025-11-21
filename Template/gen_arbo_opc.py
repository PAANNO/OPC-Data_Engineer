from pathlib import Path
import re
import sys
import subprocess


def create_structure(project_dir: Path, readme_template: str | None = None) -> None:
    # .vscode directory and settings.json
    vscode_dir = project_dir / ".vscode"
    vscode_dir.mkdir(exist_ok=True)
    (vscode_dir / "settings.json").touch(exist_ok=True)

    # data directory and subdirectories
    for sub in ("raw", "processed", "external"):
        (project_dir / "data" / sub).mkdir(parents=True, exist_ok=True)

    # docs, notebooks, tests
    for dir in ("docs", "notebooks", "tests"):
        (project_dir / dir).mkdir(exist_ok=True)
        if dir == "docs":
            (project_dir / dir / "Livrables").mkdir(parents=True, exist_ok=True)

    # src directory and __init__.py, config/, pipelines/
    src_dir = project_dir / "src"
    src_dir.mkdir(exist_ok=True)
    (src_dir / "config").mkdir(parents=True, exist_ok=True)
    (src_dir / "pipelines").mkdir(parents=True, exist_ok=True)

    init_file = src_dir / "__init__.py"
    if not init_file.exists():
        init_file.write_text(f'"""Package {project_dir.name}."""\n', encoding="utf-8")

    # Fichiers à la racine du projet
    for file in (".gitignore", "README.md", "LICENSE"):
        file_path = project_dir / file
        if not file_path.exists():
            file_path.touch(exist_ok=True)

    # README.md content
    readme_path = project_dir / "README.md"
    if not readme_path.exists() or readme_path.stat().st_size == 0:
        if readme_template:
            readme_path.write_text(readme_template, encoding="utf-8")
        else:
            readme_path.write_text(f"# {project_dir.name}\n", encoding="utf-8")


def load_readme_template(root_dir: Path) -> str | None:
    # Charger le template README.md s'il existe
    # Si le fichier n'existe pas, retourner None
    template_dir = root_dir / "template"

    if not template_dir.is_dir():
        print(f"Le répertoire des templates n'existe pas : {template_dir}")
        return None

    candidate = template_dir / "README.md"

    if candidate.is_file():
        print(f"Template README.md trouvé : {candidate}")
        return candidate.read_text(encoding="utf-8")

    # fallback : premier .md trouvé dans le template
    md_files = list(template_dir.glob("*.md"))
    if md_files:
        print(f"README modèle trouvé : {md_files[0]}")
        return md_files[0].read_text(encoding="utf-8")

    print("Aucun template README.md trouvé.")
    return None


def create_venv(project_dir: Path, python_executable: str | None = None) -> None:
    # Créer un environnement virtuel dans le répertoire de chaque projet si il n'existe pas déjà.

    if python_executable is None:
        python_executable = sys.executable  # Le Python qui exécute ce script

    venv_dir = project_dir / ".venv"
    if venv_dir.exists():
        print(f"L'environnement virtuel existe déjà dans {venv_dir}")
        return
    print(f"Création de l'environnement virtuel dans {venv_dir}...")
    try:
        subprocess.check_call([python_executable, "-m", "venv", str(venv_dir)])
        print(f"Environnement virtuel créé avec succès dans {venv_dir}.")
    except subprocess.CalledProcessError as e:
        print(
            f"Erreur lors de la création de l'environnement virtuel dans {venv_dir} : {e}"
        )


def main():
    # Dossier root de la formation
    root_dir = Path(__file__).resolve().parent.parent

    # Charger le template README.md
    readme_template = load_readme_template(root_dir)

    # Créer la structure pour chaque projet
    for project_dir in root_dir.iterdir():
        # on ne touche que les dossier qui commencent par "OPC"
        if project_dir.is_dir() and project_dir.name.upper().startswith("OPC"):
            print(f"Création de la structure pour le projet : {project_dir.name}")
            create_structure(project_dir, readme_template)
            create_venv(project_dir)

    print("Structure des projets créée avec succès.")


if __name__ == "__main__":
    main()
