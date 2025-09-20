

# **Production-Ready Python Package Copier Template**

This report presents the complete file-by-file structure and content for the requested Copier template. Each file has been meticulously crafted to integrate seamlessly, providing a robust and maintainable foundation for modern Python development.

## **Template Configuration**

### **copier.yml**

This file defines the user-facing prompts for generating a new project. It gathers essential metadata and provides sensible defaults to streamline the scaffolding process.1

YAML

\# copier.yml  
\# This file configures the prompts that Copier will present to the user  
\# when generating a new project from this template.

project\_name:  
  type: str  
  help: What is the name of your project (e.g., "My Awesome Tool")?

project\_description:  
  type: str  
  help: Provide a short description of the project.

author\_name:  
  type: str  
  help: What is your full name?

author\_email:  
  type: str  
  help: What is your email address?

initial\_version:  
  type: str  
  help: What is the initial version for the project?  
  default: "0.1.0"

## **Core Project Configuration**

### **pyproject.toml**

This file is the cornerstone of the modern Python project, centralizing all configuration for the build system, project metadata, dependency management, and developer tooling.3 This unified approach ensures consistency and simplifies both local development and CI/CD pipelines.

Ini, TOML

\# pyproject.toml

\# PEP 517: Specifies the build system for the project.  
\# Hatchling is a modern, standards-compliant build backend. \[3, 5\]  
\[build-system\]  
requires \= \["hatchling"\]  
build-backend \= "hatchling.build"

\# PEP 621: Core project metadata.  
\# This information is used by packaging tools and displayed on PyPI.  
\# Jinja2 templates are used here to insert values from copier.yml.  
\[project\]  
name \= "{{ project\_name | slugify }}"  
description \= "{{ project\_description }}"  
readme \= "README.md"  
requires-python \= "\>=3.8"  
license \= { file \= "LICENSE" }  
keywords \=  
authors \= \[  
  { name \= "{{ author\_name }}", email \= "{{ author\_email }}" },  
\]  
classifiers \=  
\# Runtime dependencies for the application.  
dependencies \= \[  
  "typer\[all\]\>=0.12.3",  
\]

\# Defines the command-line script entry point. \[4\]  
\# When the package is installed, a command named after the project will be  
\# available, which executes the \`app\` function in the \`cli\` module.  
\[project.scripts\]  
"{{ project\_name | slugify }}" \= "{{ project\_name | slugify }}.cli:app"

\# Project URLs to be displayed on PyPI.  
\[project.urls\]  
Homepage \= "https://github.com/your-username/{{ project\_name | slugify }}"  
"Bug Tracker" \= "https://github.com/your-username/{{ project\_name | slugify }}/issues"  
Repository \= "https://github.com/your-username/{{ project\_name | slugify }}"

\# \--- Hatch Configuration \---  
\# Hatch is used for project management, environment management, and task running.

\# Configures Hatch to source the project version from the package's \_\_init\_\_.py.  
\# This enables single-sourcing the version number. \[6\]  
\[tool.hatch.version\]  
path \= "src/{{ project\_name | slugify }}/\_\_init\_\_.py"

\# Configures the wheel build target to correctly handle the 'src' layout. \[5, 7\]  
\# It tells Hatchling where to find the importable package directory.  
\[tool.hatch.build.targets.wheel\]  
packages \= \["src/{{ project\_name | slugify }}"\]

\# Configuration for Hatch environments.  
\[tool.hatch.envs.default\]  
\# Specifies 'uv' as the installer for virtual environments. This significantly  
\# speeds up dependency installation and resolution. \[8, 9\]  
installer \= "uv"  
\# Dependencies required for development, linting, testing, etc.  
\# These are installed into the default Hatch environment.  
dependencies \= \[  
  "ruff",  
  "mypy",  
  "bandit",  
  "pytest",  
  "pytest-cov\[toml\]", \# \[toml\] extra needed for pyproject.toml coverage config  
\]

\# Defines runnable scripts within the Hatch environment. \[8, 10\]  
\# These scripts are the single source of truth for all quality checks.  
\[tool.hatch.envs.default.scripts\]  
\# Linter/Formatter scripts  
lint \= "ruff format src tests"  
lint-check \= "ruff check src tests"

\# Type checking script  
type-check \= "mypy."

\# Security analysis script  
security \= "bandit \-c pyproject.toml \-r src"

\# Testing script  
test \= "pytest"

\# Master script to run all checks in sequence.  
\# This is used by the Makefile and the CI pipeline to ensure consistency.  
check-all \= \[  
  "lint-check",  
  "type-check",  
  "security",  
  "test",  
\]

\# \--- Tool Configurations \---  
\# All tool configurations are centralized here for maintainability.

\# Ruff (Linter and Formatter) Configuration \[11, 12\]  
\[tool.ruff\]  
line-length \= 88  
target-version \= "py38"

\[tool.ruff.lint\]  
\# A strict selection of rules for high code quality.  
select \=  
ignore \=

\# Enforces Google-style docstrings, a non-negotiable requirement. \[13\]  
\[tool.ruff.lint.pydocstyle\]  
convention \= "google"

\[tool.ruff.format\]  
quote-style \= "double"

\# MyPy (Static Type Checker) Configuration \[14\]  
\[tool.mypy\]  
strict \= true  
ignore\_missing\_imports \= true  
\# Allow redefinition for typer callbacks/options which can look like redefinitions  
allow\_redefinition \= true  
\# Exclude virtual environment directories from checks  
exclude \= '(\\.venv|\\.hatch)'

\# Bandit (Security Scanner) Configuration \[15\]  
\[tool.bandit\]  
exclude\_dirs \= \["tests"\]  
skips \= \# Skip assert\_used check, common in tests

\# Pytest Configuration \[16\]  
\[tool.pytest.ini\_options\]  
minversion \= "6.0"  
\# Default arguments for pytest.  
\# \-ra: show extra test summary info  
\# \-q: quiet mode  
\# \--cov: enable coverage reporting for the specified package  
\# \--cov-report: specify coverage report format  
\# \--cov-fail-under: fail the test run if coverage is below the threshold  
addopts \= "-ra \-q \--cov={{ project\_name | slugify }} \--cov-report=term-missing \--cov-fail-under=80"  
testpaths \= \[  
    "tests",  
\]

\# Coverage.py Configuration \[17, 18\]  
\[tool.coverage.run\]  
source \= \["{{ project\_name | slugify }}"\]  
\# Omit test files from the coverage source to avoid skewing results.  
omit \= \["tests/\*"\]

\[tool.coverage.report\]  
\# Fail if coverage is below 80%. This value is duplicated from addopts  
\# to ensure it's respected by \`coverage report\` commands as well.  
fail\_under \= 80  
exclude\_lines \=

## **Developer Experience**

### **Makefile**

This file provides a simple, memorable, and stable command-line interface for common development tasks. It acts as a wrapper around the more verbose hatch commands, improving developer ergonomics and onboarding.

Makefile

\# Makefile  
\# Provides a convenient interface for common development tasks.

\# Use.PHONY to ensure these targets run even if files with the same name exist.  
.PHONY: help install lint test security check-all run build publish

\# Default target when 'make' is run without arguments.  
help:  
	@echo "Available commands:"  
	@echo "  install      Create virtual environment and install dependencies"  
	@echo "  lint         Format and lint the codebase with Ruff"  
	@echo "  test         Run tests with Pytest and report coverage"  
	@echo "  security     Scan for security vulnerabilities with Bandit"  
	@echo "  check-all    Run all checks (lint, type, security, test)"  
	@echo "  run          Run the CLI application (pass args with ARGS=\\"...\\")"  
	@echo "  build        Build the package wheels and sdist"  
	@echo "  publish      Publish the package to PyPI"

\# Creates the Hatch-managed virtual environment and installs all dependencies.  
install:  
	hatch env create

\# Formats and lints the codebase using the 'lint' script defined in pyproject.toml.  
lint:  
	hatch run lint

\# Runs the test suite using the 'test' script defined in pyproject.toml.  
test:  
	hatch run test

\# Runs the security scan using the 'security' script defined in pyproject.toml.  
security:  
	hatch run security

\# Runs all checks sequentially using the 'check-all' script. This is the same  
\# command that the CI pipeline executes.  
check-all:  
	hatch run check-all

\# Runs the CLI application. Arguments can be passed via the ARGS variable.  
\# Example: make run ARGS="--name Alice"  
run:  
	hatch run {{ project\_name | slugify }} \-- $(ARGS)

\# Builds the source distribution (sdist) and wheel for the package.  
build:  
	hatch build

\# Publishes the built distributions to PyPI using twine.  
\# Requires twine to be installed and PyPI credentials to be configured.  
publish: build  
	twine upload dist/\*

## **Documentation and Project Files**

### **README.md**

A comprehensive, templated guide that serves as the primary entry point for developers. It explains the project's purpose, setup, and how to use the provided development commands.

# **{{ project\_name }}**

{{ project\_description }}

## **Overview**

This project is a Python command-line tool built using a modern, production-ready template. It leverages hatch for project management, uv for fast dependency installation, typer for the CLI, and a comprehensive suite of tools for code quality and testing.

## **Getting Started**

### **Prerequisites**

* Python 3.8+  
* [Hatch](https://hatch.pypa.io/latest/install/)  
* [Make](https://www.gnu.org/software/make/) (optional, for convenience)

### **Installation**

1. \*\*Clone the repository:\*\*bash  
   git clone https://github.com/your-username/{{ project\_name | slugify }}  
   cd {{ project\_name | slugify }}

2. **Create the virtual environment and install dependencies:**  
   This command uses hatch to create a virtual environment (using uv as the installer) and install all project dependencies defined in pyproject.toml.  
   Bash  
   make install

   Alternatively, you can run the hatch command directly:  
   Bash  
   hatch env create

## **Development**

This project uses a Makefile to provide simple, memorable commands for common development tasks. These commands are wrappers around hatch scripts defined in pyproject.toml, ensuring a consistent experience between local development and CI.

### **Development Command Reference**

The following table maps the simplified make commands to their underlying hatch implementations and provides a brief description.

| make Command | Underlying hatch Command | Description |
| :---- | :---- | :---- |
| make install | hatch env create | Creates the virtual environment and installs dependencies. |
| make lint | hatch run lint | Formats and lints the codebase with Ruff. |
| make test | hatch run test | Runs the test suite with Pytest and reports coverage. |
| make security | hatch run security | Scans for security vulnerabilities with Bandit. |
| make check-all | hatch run check-all | Runs all checks in sequence (lint, type, security, test). |
| make run | \`hatch run {{ project\_name | slugify }} \--\` |
| make build | hatch build | Builds the source distribution and wheel. |
| make publish | hatch build && twine upload dist/\* | Builds and publishes the package to PyPI. |

### **Running the Application**

To run the CLI application, use the make run command. You can pass arguments to your application using the ARGS variable.

Bash

make run ARGS="--name World"  
\# Expected output: Hello World

make run ARGS="--name Alice"  
\# Expected output: Hello Alice

## **CI/CD**

The project includes a GitHub Actions workflow defined in .github/workflows/ci.yml. This workflow automatically runs all quality checks (lint, type-check, security, test) and builds the package on every push to main and on every pull request.

\#\#\#.gitignore

A standard, thorough \`.gitignore\` file for Python projects to prevent common build artifacts, caches, and environment files from being committed to version control.\[19, 20\]

\`\`\`gitignore  
\#.gitignore

\# Byte-compiled / optimized / DLL files  
\_\_pycache\_\_/  
\*.py\[cod\]  
\*$py.class

\# C extensions  
\*.so

\# Distribution / packaging  
.Python  
build/  
develop-eggs/  
dist/  
downloads/  
eggs/  
.eggs/  
lib/  
lib64/  
parts/  
sdist/  
var/  
wheels/  
\*.egg-info/  
.installed.cfg  
\*.egg  
\*.manifest  
\*.spec

\# Hatch  
.hatch/

\# PyInstaller  
\# Usually these files are created by pyinstaller, if you are using it.  
\*.manifest  
\*.spec

\# Installer logs  
pip-log.txt  
pip-delete-this-directory.txt

\# Unit test / coverage reports  
htmlcov/  
.tox/  
.nox/  
.coverage  
.coverage.\*  
.cache  
nosetests.xml  
coverage.xml  
\*.cover  
\*.py,cover  
.hypothesis/  
.pytest\_cache/

\# Translations  
\*.mo  
\*.pot

\# Django stuff:  
\*.log  
local\_settings.py  
db.sqlite3  
db.sqlite3-journal

\# Flask stuff:  
instance/  
.webassets-cache

\# Scrapy stuff:  
.scrapy

\# Sphinx documentation  
docs/\_build/

\# PyBuilder  
target/

\# Jupyter Notebook  
.ipynb\_checkpoints

\# IPython  
profile\_default/  
ipython\_config.py

\# pyenv  
.python-version

\# poetry  
poetry.lock

\# pdm  
pdm.lock  
.pdm.toml

\# PEP 582; used by PDM.  
\_\_pypackages\_\_/

\# Celery stuff  
celerybeat-schedule  
celerybeat.pid

\# SageMath parsed files  
\*.sage.py

\# Environments  
.env  
.venv  
env/  
venv/  
ENV/  
env.bak/  
venv.bak/

\# Spyder project settings  
.spyderproject  
.spyderworkspace

\# Rope project settings  
.ropeproject

\# mkdocs documentation  
/site

\# mypy  
.mypy\_cache/  
.dmypy.json  
dmypy.json

\# Pyre type checker  
.pyre/

\# pytype  
.pytype/

\# Cython debug symbols  
cython\_debug/

\# VSCode  
.vscode/  
.history/

### **LICENSE**

A templated MIT License file, a permissive and widely used open-source license.21

MIT License

Copyright (c) {% now 'utc', '%Y' %} {{ author\_name }}

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  
SOFTWARE.

## **Automation (CI/CD)**

\#\#\#.github/workflows/ci.yml  
A single, reusable GitHub Actions workflow that automates linting, testing, and building. It leverages the astral-sh/setup-uv action for high-performance environment setup and relies on the centralized scripts in pyproject.toml to execute checks.22

YAML

\#.github/workflows/ci.yml

name: Lint, Test, and Build

on:  
  push:  
    branches: \[ "main" \]  
  pull\_request:  
  workflow\_dispatch:

jobs:  
  lint\_and\_test:  
    name: Lint & Test  
    runs-on: ubuntu-latest  
    steps:  
      \- name: Checkout repository  
        uses: actions/checkout@v4

      \- name: Set up Python, uv, and Hatch  
        uses: astral-sh/setup-uv@v1  
        with:  
          \# Use a specific Python version for consistency  
          python-version: '3.11'

      \- name: Install Hatch  
        run: uv pip install hatch

      \- name: Install dependencies  
        run: hatch env create

      \- name: Run all checks  
        \# This single command executes the 'check-all' script defined in pyproject.toml,  
        \# ensuring that the CI pipeline is an exact mirror of the local development checks.  
        run: hatch run check-all

  build:  
    name: Build Package  
    needs: lint\_and\_test  
    runs-on: ubuntu-latest  
    steps:  
      \- name: Checkout repository  
        uses: actions/checkout@v4

      \- name: Set up Python, uv, and Hatch  
        uses: astral-sh/setup-uv@v1  
        with:  
          python-version: '3.11'

      \- name: Install Hatch  
        run: uv pip install hatch

      \- name: Build package  
        run: hatch build

## **Application Source Code**

### **src/{{ project\_name | slugify }}/init.py**

This file establishes the directory as a Python package and provides the single source of truth for the project's version, which is read by hatch during the build process.

Python

\# src/{{ project\_name | slugify }}/\_\_init\_\_.py  
"""{{ project\_description }}"""

\_\_version\_\_ \= "{{ initial\_version }}"

### **src/{{ project\_name | slugify }}/cli.py**

A functional "hello world" style CLI application using typer. This provides a working example that is immediately runnable and testable, demonstrating best practices for command and option creation.24

Python

\# src/{{ project\_name | slugify }}/cli.py  
"""Command-line interface for the {{ project\_name }} package."""

from typing\_extensions import Annotated

import typer

from {{ project\_name | slugify }} import \_\_version\_\_

app \= typer.Typer()

def version\_callback(value: bool) \-\> None:  
    """Prints the version of the package."""  
    if value:  
        print(f"{{ project\_name }} Version: {\_\_version\_\_}")  
        raise typer.Exit()

@app.command()  
def main(  
    name: Annotated \= "World",  
    version: Annotated \= False,  
) \-\> None:  
    """  
    A simple "hello world" CLI application.

    Args:  
        name: The name to greet.  
        version: A flag to show the application's version and exit.  
    """  
    print(f"Hello {name}")

if \_\_name\_\_ \== "\_\_main\_\_":  
    app()

## **Testing**

### **tests/init.py**

An empty file to ensure the tests directory is treated as a package, which can be important for some test discovery configurations.

Python

\# tests/\_\_init\_\_.py  
"""Test suite for the {{ project\_name }} package."""

### **tests/test\_cli.py**

A sample test file using pytest and typer.testing.CliRunner to verify the basic functionality of the CLI application. This ensures the template is fully functional out of the box.26

Python

\# tests/test\_cli.py  
"""Tests for the CLI application."""

from typer.testing import CliRunner

from {{ project\_name | slugify }} import \_\_version\_\_  
from {{ project\_name | slugify }}.cli import app

runner \= CliRunner()

def test\_app\_version() \-\> None:  
    """Test the \--version option."""  
    result \= runner.invoke(app, \["--version"\])  
    assert result.exit\_code \== 0  
    assert f"{{ project\_name }} Version: {\_\_version\_\_}" in result.stdout

def test\_app\_default\_greeting() \-\> None:  
    """Test the default greeting."""  
    result \= runner.invoke(app)  
    assert result.exit\_code \== 0  
    assert "Hello World" in result.stdout

def test\_app\_custom\_greeting() \-\> None:  
    """Test greeting with a custom name."""  
    result \= runner.invoke(app, \["--name", "Alice"\])  
    assert result.exit\_code \== 0  
    assert "Hello Alice" in result.stdout

#### **Works cited**

1. copier \- The Blue Book, accessed on September 20, 2025, [https://lyz-code.github.io/blue-book/copier/](https://lyz-code.github.io/blue-book/copier/)  
2. Effective Repository Templates with Copier \- Brownian Tech, accessed on September 20, 2025, [https://chrisb.dchidell.com/blog/post/Effective-Repository-Templates-with-Copier](https://chrisb.dchidell.com/blog/post/Effective-Repository-Templates-with-Copier)  
3. Writing your pyproject.toml \- Python Packaging User Guide, accessed on September 20, 2025, [https://packaging.python.org/en/latest/guides/writing-pyproject-toml/](https://packaging.python.org/en/latest/guides/writing-pyproject-toml/)  
4. How to Manage Python Projects With pyproject.toml, accessed on September 20, 2025, [https://realpython.com/python-pyproject-toml/](https://realpython.com/python-pyproject-toml/)  
5. en.wikipedia.org, accessed on September 20, 2025, [https://en.wikipedia.org/wiki/MIT\_License](https://en.wikipedia.org/wiki/MIT_License)  
6. astral-sh/setup-uv · Actions · GitHub Marketplace, accessed on September 20, 2025, [https://github.com/marketplace/actions/astral-sh-setup-uv](https://github.com/marketplace/actions/astral-sh-setup-uv)  
7. Building and publishing a package | uv \- Astral Docs, accessed on September 20, 2025, [https://docs.astral.sh/uv/guides/package/](https://docs.astral.sh/uv/guides/package/)  
8. Python Typer Module \- GeeksforGeeks, accessed on September 20, 2025, [https://www.geeksforgeeks.org/python/python-typer-module/](https://www.geeksforgeeks.org/python/python-typer-module/)  
9. CLI Option autocompletion \- Typer, accessed on September 20, 2025, [https://typer.tiangolo.com/tutorial/options-autocompletion/](https://typer.tiangolo.com/tutorial/options-autocompletion/)  
10. Good Integration Practices \- pytest documentation, accessed on September 20, 2025, [https://docs.pytest.org/en/stable/explanation/goodpractices.html](https://docs.pytest.org/en/stable/explanation/goodpractices.html)