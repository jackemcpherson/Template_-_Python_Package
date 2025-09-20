# Repository Guidelines

## Project Structure & Module Organization
The template root holds `copier.yml` for prompts, `pyproject.toml` for build metadata, and `README.md` for contributor messaging. Source modules live under `src/[[ project_slug ]]/`, exposing `__init__.py` for versioning and `cli.py` as the Typer entry point. Tests reside in `tests/`, mirroring the src layout (`tests/test_cli.py` exercises the CLI). Continuous integration lives in `.github/workflows/ci.yml`, which renders the template during CI before running checks.

## Build, Test, and Development Commands
Use Hatch with uv to manage environments. Run `hatch env create` once to provision dependencies. Key workflows:
- `hatch run lint`: applies Ruff formatting to `src` and `tests`.
- `hatch run lint-check`: executes static linting without modifying files.
- `hatch run type-check`: runs mypy across the project for typing regressions.
- `hatch run security`: scans with Bandit.
- `hatch run test`: executes pytest; add `--cov` for coverage reports.
- `hatch build`: produces sdist and wheel artifacts in `dist/`.

## Coding Style & Naming Conventions
Follow PEP 8 with 4-space indentation and 88-character soft limits enforced by Ruff. Name packages with lowercase, underscore-only slugs; modules use snake_case and classes use CapWords. CLI commands and options should read naturally, as seen in `cli.py`. Keep docstrings narrative and prefer Typer’s Annotated hints for argument metadata. Run `ruff format` before commits and avoid manual whitespace tweaks that differ from tooling output.

## Testing Guidelines
Tests use pytest with typer.testing’s `CliRunner`. Place files under `tests/` and name them `test_<feature>.py`. Target high coverage on CLI behaviors; enforce at least 90% by passing `--cov=[[ project_slug ]]` locally and in CI when suites expand. Prefer deterministic fixtures so Copier-generated runs remain reproducible.

## CI Pipeline Expectations
The workflow generates a sample project with Copier, installs dependencies via `uv pip sync --all-extras`, then runs `uv run` for Ruff formatting checks, linting, MyPy, Bandit, and pytest on Python 3.12. Keep template files render-safe (no interactive prompts) and ensure required tooling stays listed under `project.optional-dependencies.dev` so CI environments provision correctly.

## Commit & Pull Request Guidelines
Adopt Conventional Commit prefixes (`feat:`, `fix:`, `chore:`). Each commit should be focused and pass Hatch scripts locally. Pull requests must capture motivation, summarize functional changes, and list verification steps (commands run, tests added). Link related issues or template prompts, and include screenshots or CLI transcripts when they clarify user-facing behavior.
