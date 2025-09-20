# Makefile
# Provides a convenient interface for common development tasks.

# Use .PHONY to ensure these targets run even if files with the same name exist.
.PHONY: help install lint test security check-all run build publish

# Default target when 'make' is run without arguments.
help:
	@echo "Available commands:"
	@echo "  install      Create virtual environment and install dependencies"
	@echo "  lint         Format and lint the codebase with Ruff"
	@echo "  test         Run tests with Pytest and report coverage"
	@echo "  security     Scan for security vulnerabilities with Bandit"
	@echo "  check-all    Run all checks (lint, type, security, test)"
	@echo "  run          Run the CLI application (pass args with ARGS="...")"
	@echo "  build        Build the package wheels and sdist"
	@echo "  publish      Publish the package to PyPI"

# Creates the Hatch-managed virtual environment and installs all dependencies.
install:
	hatch env create

# Formats and lints the codebase using the 'lint' script defined in pyproject.toml.
lint:
	hatch run lint

# Runs the test suite using the 'test' script defined in pyproject.toml.
test:
	hatch run test

# Runs the security scan using the 'security' script defined in pyproject.toml.
security:
	hatch run security

# Runs all checks sequentially using the 'check-all' script. This is the same
# command that the CI pipeline executes.
check-all:
	hatch run check-all

# Runs the CLI application. Arguments can be passed via the ARGS variable.
# Example: make run ARGS="--name Alice"
run:
	hatch run [[ project_slug ]] -- $(ARGS)

# Builds the source distribution (sdist) and wheel for the package.
build:
	hatch build

# Publishes the built distributions to PyPI using twine.
# Requires twine to be installed and PyPI credentials to be configured.
publish: build
	twine upload dist/*
