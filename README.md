# Modern Python Package Copier Template

This repository hosts an opinionated [Copier](https://copier.readthedocs.io/) template for bootstrapping high-performance Python packages and command-line tools. The generated projects use **Typer** for a best-in-class CLI experience and lean on **uv** as the single, consistent toolchain for dependency management and reproducible builds.

The template bakes in strict linting, type checking, security scanning, and a CI/CD pipeline so new packages can focus on functionality instead of boilerplate.

## Highlights
- **Modern Stack**: Typer for the CLI, uv for environments, and Python 3.12 targeting.
- **Rust-Powered Tooling**: `uv` for lightning-fast dependency management and task running, `ruff` for linting/formatting, and `mypy` for strict type checking.
- **Production Ready**: Includes configurations for `pytest` with coverage, `bandit` for security scanning, and a consistent `Makefile` for developer experience.
- **Publishing Ready**: Comes with a `make publish` command that builds the package and uploads it to PyPI using Twine.
- **Consistent DX**: The `Makefile` and `uv`-based script running mirror our Dockerized web app template, ensuring a unified workflow across project types.
- **CI/CD Integrated**: A GitHub Actions workflow validates the template on every push by generating a project and running all quality checks.

## Getting Started

Install Copier (if you haven’t already):

```bash
uv tool install copier
```

Generate a new project:

```bash
copier copy gh:jackemcpherson/Template_-_Python_Package my-awesome-cli
```

Follow the prompts, then jump into the generated project and run `make install`.
