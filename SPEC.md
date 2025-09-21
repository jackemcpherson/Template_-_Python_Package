# SPEC.md - Python Package Copier Template Specification

## 1. Project Overview

### 1.1 Purpose
This specification defines a Copier template for generating modern, production-ready Python packages and command-line tools. The template prioritizes developer experience, code quality, and maintainability while showcasing best practices for CLI development using Typer.

### 1.2 Core Principles
- **Consistency with Web App Template**: Mirror the tooling and workflow patterns from the FastAPI/FastHTML template
- **Modern Toolchain**: Use uv exclusively for dependency management and task running
- **Rich CLI Experience**: Demonstrate Typer's full capabilities including subcommands, rich output, and configuration handling
- **Production Ready**: Include all necessary quality gates, testing infrastructure, and publishing capabilities
- **Minimal Configuration**: Sensible defaults with clear extension points

## 2. Technical Stack

### 2.1 Required Technologies
- **Python**: 3.12+ (consistent with web app template)
- **CLI Framework**: Typer with all extras
- **Terminal UI**: Rich for tables, progress bars, and formatted output
- **Package Management**: uv (Rust-powered, 10-100x faster than pip)
- **Code Quality**: ruff (formatting + linting), mypy (strict mode), bandit (security)
- **Testing**: pytest with coverage reporting
- **Build System**: setuptools with wheel support
- **Publishing**: twine for PyPI uploads

### 2.2 Optional Dependencies
- **Configuration**: toml for config file handling
- **Data Formats**: Support for JSON, YAML, CSV via optional extras
- **HTTP Client**: httpx for API interactions (demonstration purposes)

## 3. Template Structure

### 3.1 Directory Layout
```
Template_-_Python_Package/
├── README.md                 # Template documentation (excluded from generation)
├── SPEC.md                  # This specification (excluded from generation)
├── copier.yml               # Copier configuration
├── README.md.jinja          # Generated project README
├── AGENTS.md                # Repository guidelines
├── CLAUDE.md                # AI assistant context
├── LICENSE.jinja            # MIT license template
├── Makefile.jinja           # Developer workflow commands
├── pyproject.toml.jinja     # Package configuration
├── .gitignore.jinja         # Git exclusions
├── src/
│   └── {{ package_name }}/
│       ├── __init__.py.jinja
│       ├── __main__.py.jinja    # Entry point for `python -m package`
│       ├── cli.py.jinja         # Main CLI application
│       ├── commands/            # Subcommand modules
│       │   ├── __init__.py.jinja
│       │   ├── config.py.jinja  # Configuration commands
│       │   └── data.py.jinja    # Data processing commands
│       ├── core.py.jinja        # Business logic
│       ├── config.py.jinja      # Configuration handling
│       ├── utils.py.jinja       # Utility functions
│       └── py.typed.jinja       # Type checking marker
├── tests/
│   ├── __init__.py.jinja
│   ├── conftest.py.jinja        # Shared fixtures
│   ├── test_cli.py.jinja        # CLI tests
│   ├── test_commands.py.jinja   # Subcommand tests
│   └── test_core.py.jinja       # Core logic tests
└── .github/
    └── workflows/
        ├── ci.yml               # Template validation
        └── release.yml.jinja    # PyPI publishing workflow
```

## 4. Template Variables

### 4.1 User Prompts
| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `project_name` | str | "My Awesome CLI" | Human-readable project name |
| `project_description` | str | Required | One-line description |
| `author_name` | str | Required | Full name of the author |
| `author_email` | str | Required | Contact email |
| `github_username` | str | Required | GitHub username/org |
| `initial_version` | str | "0.1.0" | Starting version |
| `python_version` | str | "3.12" | Minimum Python version |
| `include_rich_output` | bool | true | Include Rich for terminal UI |
| `include_config` | bool | true | Include configuration handling |

### 4.2 Computed Variables
| Variable | Derivation | Purpose |
|----------|------------|---------|
| `package_name` | `project_name.lower().replace(...)` | Python package name |
| `project_slug` | `project_name.lower().replace(...)` | URL-safe name |
| `copyright_year` | Current year | License copyright |

## 5. Feature Requirements

### 5.1 CLI Architecture
The generated CLI must demonstrate:
- **Main application with callback** for global options (version, config)
- **Subcommand groups** using Typer's app.add_typer()
- **Rich output** including tables, progress bars, and formatted text
- **Configuration management** with init, show, edit commands
- **Data processing** commands showcasing file I/O patterns
- **Error handling** with informative messages and exit codes

### 5.2 Makefile Commands
Maintain parity with the web app template:
```makefile
make help        # Show available commands
make install     # Set up environment with uv
make lint        # Format and lint with ruff
make test        # Run pytest with coverage
make security    # Scan with bandit
make check-all   # Run all quality checks
make run         # Execute the CLI (with ARGS support)
make build       # Build sdist and wheel
make publish     # Upload to PyPI
make clean       # Remove build artifacts
```

### 5.3 Testing Infrastructure
- **CLI testing** using typer.testing.CliRunner
- **Fixtures** for temporary files, mock configurations
- **Coverage requirements**: Minimum 80% with HTML reports
- **Test organization**: Separate files for CLI, commands, and core logic
- **Integration tests**: Test full command workflows

### 5.4 Documentation
Each generated project must include:
- **README.md**: Quick start, installation, usage examples
- **AGENTS.md**: Development guidelines, conventions
- **CLAUDE.md**: AI assistant context for the project
- **Inline documentation**: Comprehensive docstrings (Google style)
- **Type hints**: Complete type annotations for all public APIs

## 6. Implementation Details

### 6.1 Main CLI Module (`cli.py`)
```python
# Key requirements:
- Use typer.Typer() with help text and no completion by default
- Implement version callback using --version flag
- Create subcommand groups for logical command organization
- Use Rich Console for all output (no print statements)
- Handle errors gracefully with proper exit codes
```

### 6.2 Configuration Handling
```python
# Requirements:
- Support TOML configuration files
- Default location: ~/.{package_name}/config.toml
- Commands: init, show, edit, validate
- Schema validation using pydantic (optional)
```

### 6.3 Core Business Logic
```python
# Separate from CLI concerns:
- Pure functions where possible
- Comprehensive type hints
- No direct I/O or console output
- Raise exceptions for error conditions
```

## 7. Quality Standards

### 7.1 Code Quality
- **Ruff configuration**: select = ["ALL"] with minimal, justified ignores
- **Type checking**: mypy strict mode with no implicit Any
- **Security**: Bandit scans on src/ directory
- **Test coverage**: Minimum 80%, with branch coverage

### 7.2 CI/CD Pipeline

#### Template Repository CI (`/.github/workflows/ci.yml`)
The template repository's CI workflow **MUST** validate the template by generating a sample project and running all quality checks on the generated output. This follows the same pattern as the web app template:

```yaml
name: Lint and Test

on:
  push:
    branches: [ "main" ]
  pull_request:
  workflow_dispatch:

jobs:
  validate-template:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.12"]
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      
      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      
      - name: Install uv
        uses: astral-sh/setup-uv@v1
      
      - name: Generate project from template
        run: |
          uvx --from copier copier copy --trust --force \
            -d project_name="CI Test Package" \
            -d project_description="Generated during CI to validate the template." \
            -d author_name="CI Bot" \
            -d author_email="ci@example.com" \
            -d initial_version="0.1.0" \
            -d github_username="ci-bot" \
            . generated
      
      - name: Install dependencies
        working-directory: generated
        run: uv sync --all-extras
      
      - name: Check formatting with ruff
        working-directory: generated
        run: uv run ruff format --check .
      
      - name: Lint with ruff
        working-directory: generated
        run: uv run ruff check .
      
      - name: Type check with mypy
        working-directory: generated
        run: uv run mypy
      
      - name: Scan for security vulnerabilities with bandit
        working-directory: generated
        run: uv run bandit -r src
      
      - name: Run tests with pytest
        working-directory: generated
        run: uv run pytest
      
      - name: Build package
        working-directory: generated
        run: uv run python -m build
      
      - name: Validate CLI execution
        working-directory: generated
        run: |
          uv run python -m ci_test_package --version
          uv run python -m ci_test_package --help
```

**Critical Requirements:**
- The CI **MUST NOT** attempt to run Python tests directly on the template repository
- All validation occurs on the `generated/` directory created by Copier
- The workflow must test all quality gates that the generated project will use
- Add a CLI execution test to verify the package entry points work correctly

#### Generated Project CI (`.github/workflows/ci.yml.jinja`)
Generated projects should include their own CI workflow for ongoing development.

### 7.3 Performance Requirements
- **Startup time**: CLI should respond to --help in <100ms
- **Import optimization**: Lazy imports for heavy dependencies
- **Progress feedback**: Use spinners/bars for operations >1s

## 8. Example Generated Application

The template should generate a functional CLI demonstrating:
```bash
# Basic usage
$ myapp --version
myapp version 0.1.0

$ myapp --help
Usage: myapp [OPTIONS] COMMAND [ARGS]...

# Subcommands
$ myapp config init
✓ Configuration initialized at ~/.myapp/config.toml

$ myapp data process input.csv --format json
Processing... ✓
Output: {"processed": true, "rows": 100}

$ myapp data list ./data
╭─────────────────────────────────────╮
│ Files in ./data                     │
├──────────────┬──────────┬───────────┤
│ Name         │ Size     │ Modified  │
├──────────────┼──────────┼───────────┤
│ dataset.csv  │ 1,234 KB │ 2025-01-01│
╰──────────────┴──────────┴───────────╯
```

## 9. Migration Path

For users migrating from the current template:
1. Preserve all existing Makefile commands
2. Maintain backward compatibility for basic CLI structure
3. New features should be opt-in via template variables
4. Provide migration guide in documentation

## 10. Success Criteria

The template is considered complete when:
- [ ] Template CI generates a project and validates it (not the template itself)
- [ ] All Makefile commands work identically to web app template
- [ ] Generated CLIs showcase Typer's advanced features
- [ ] CI successfully generates and validates projects
- [ ] Documentation is comprehensive and follows team standards
- [ ] Template produces publication-ready packages
- [ ] Rich output enhances user experience
- [ ] Configuration handling is intuitive
- [ ] Test coverage exceeds 80% for generated projects

## 11. Future Considerations

Potential enhancements (not in initial scope):
- Plugin system using entry points
- Async command support
- Shell completion customization
- Internationalization support
- Telemetry/analytics integration
- Update checking mechanism
- Self-documenting API client generation

## 12. References

- [Typer Documentation](https://typer.tiangolo.com/)
- [Rich Documentation](https://rich.readthedocs.io/)
- [uv Documentation](https://github.com/astral-sh/uv)
- [Copier Documentation](https://copier.readthedocs.io/)
- Web App Template: `gh:jackemcpherson/Template_-_Python_Web_App`
