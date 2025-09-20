# Repository Guidelines

## Project Structure & Module Organization
The template root holds `copier.yml` for prompts, `pyproject.toml.jinja` for packaging metadata, and `README.md` describing the template itself. Generated sources live under `src/{{ package_name }}/`, populated from `.jinja` files such as `cli.py.jinja`. Tests mirror that layout in `tests/`, and each Jinja file becomes a concrete Python module when Copier renders a project. GitHub Actions automation resides in `.github/workflows/ci.yml`.

## Build, Test, and Development Commands
Use uv exclusively in generated projects. After rendering, run `make install` (backed by `uv sync`) to provision dependencies. Key commands provided by the template `Makefile`:
- `make lint` – runs `uv run ruff format` and `uv run ruff check`.
- `make test` – executes pytest with coverage through `uv run pytest`.
- `make security` – runs `uv run bandit -r src`.
- `make check-all` – chains lint, test, and security checks.
- `make run` – launches the Typer CLI (`ARGS="--name Alice"` forwards options).
- `make build` – invokes `uv run python -m build` to produce sdist/wheel artifacts.

## Coding Style & Naming Conventions
Generated packages derive `package_name` by slugifying `project_name` into underscores (PEP 503 safe). Modules use snake_case; Typer commands should keep human-friendly option names. Ruff enforces 88-character lines and Google-style docstrings while ignoring assert usage in tests. Avoid reintroducing hatch scripts or alternative tooling in template files.

## Testing Guidelines
Tests rely on pytest and `typer.testing.CliRunner`. Store them under `tests/` (Copier will render from `test_*.py.jinja`). Coverage is enabled by default via pytest configuration in `pyproject.toml.jinja` (`--cov={{ package_name }}`). When extending the template, ensure new utilities remain testable without network access and prefer deterministic CLI outputs.

## CI Pipeline Expectations
`.github/workflows/ci.yml` renders the template into `generated/`, runs `uv sync --all-extras`, and executes linting, typing, security, tests, and a build step using `uv run`. Maintain parity with the Dockerized web app template so contributors experience the same tooling across repositories.

## Commit & Pull Request Guidelines
Use Conventional Commit prefixes (`feat:`, `fix:`, `chore:`) and keep changes focused. Before pushing, run `make check-all` inside a rendered project when you alter template logic. Pull requests should document the generated project settings used for validation and link related tickets or templates when applicable.
