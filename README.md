# {{ project_name }}

{{ project_description }}

## Overview

This project is a Python command-line tool built using a modern, production-ready template. It leverages Hatch for project management, uv for fast dependency installation, Typer for the CLI, and a comprehensive suite of tools for code quality and testing.

## Getting Started

### Prerequisites

- Python 3.8+
- [Hatch](https://hatch.pypa.io/latest/install/)
- [Make](https://www.gnu.org/software/make/) (optional, for convenience)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/{{ project_name | slugify }}
   cd {{ project_name | slugify }}
   ```
2. **Create the virtual environment and install dependencies:**
   This command uses Hatch to create a virtual environment (using uv as the installer) and install all project dependencies defined in `pyproject.toml`.
   ```bash
   make install
   ```
   Alternatively, you can run the Hatch command directly:
   ```bash
   hatch env create
   ```

## Development

This project uses a Makefile to provide simple, memorable commands for common development tasks. These commands are wrappers around Hatch scripts defined in `pyproject.toml`, ensuring a consistent experience between local development and CI.

### Development Command Reference

| make Command | Underlying Hatch Command | Description |
| --- | --- | --- |
| make install | `hatch env create` | Creates the virtual environment and installs dependencies. |
| make lint | `hatch run lint` | Formats and lints the codebase with Ruff. |
| make test | `hatch run test` | Runs the test suite with Pytest and reports coverage. |
| make security | `hatch run security` | Scans for security vulnerabilities with Bandit. |
| make check-all | `hatch run check-all` | Runs all checks in sequence (lint, type, security, test). |
| make run | `hatch run {{ project_name | slugify }} --` | Executes the CLI application with optional arguments. |
| make build | `hatch build` | Builds the source distribution and wheel. |
| make publish | `hatch build && twine upload dist/*` | Builds and publishes the package to PyPI. |

### Running the Application

To run the CLI application, use `make run`. You can pass arguments to your application using the `ARGS` variable.

```bash
make run ARGS="--name World"
# Expected output: Hello World

make run ARGS="--name Alice"
# Expected output: Hello Alice
```

## CI/CD

The project includes a GitHub Actions workflow defined in `.github/workflows/ci.yml`. It renders the template with Copier, installs dependencies through uv, and then runs formatting, linting, type checking, security scanning, and tests against Python 3.12 on every push to `main`, on each pull request, and via manual dispatch.
