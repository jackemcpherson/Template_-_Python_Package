# Development Guidelines & AI Agent Instructions

This document provides guidelines for development and AI assistant interactions for this Python CLI project.

## Project Overview

This is a modern Python CLI application built with:
- **Typer** for CLI framework
- **Rich** for terminal UI enhancements
- **uv** for dependency management
- **ruff** for linting and formatting
- **mypy** for type checking
- **pytest** for testing

## Code Standards

### General Principles

1. **Type Safety**: Use type hints everywhere. Enable mypy strict mode.
2. **Code Quality**: Follow ruff's recommendations. Use `select = ["ALL"]` with minimal ignores.
3. **Testing**: Maintain >80% test coverage. Write tests for all public APIs.
4. **Documentation**: Use Google-style docstrings for all public functions and classes.
5. **Security**: Run bandit security scans. Never commit secrets.

### Code Style

- **Formatting**: Use ruff format (compatible with Black)
- **Line length**: 88 characters
- **Imports**: Use isort-compatible import ordering via ruff
- **Quotes**: Double quotes preferred
- **Type hints**: Required for all function parameters and return values

### CLI Development

- **Framework**: Use Typer exclusively for CLI functionality
- **Output**: Use Rich Console for all output (no print statements)
- **Error Handling**: Raise exceptions with clear messages, let Typer handle exit codes
- **Commands**: Organize commands in submodules under `commands/`
- **Configuration**: Use TOML files with validation

### File Organization

```
src/{{ package_name }}/
├── __init__.py          # Package initialization, version info
├── __main__.py          # Entry point for `python -m package`
├── cli.py               # Main CLI application and global options
├── commands/            # Subcommand modules
│   ├── __init__.py      # Command registration
│   ├── config.py        # Configuration commands
│   └── data.py          # Data processing commands
├── core.py              # Business logic (pure functions)
├── config.py            # Configuration handling
├── utils.py             # Utility functions
└── py.typed             # Type checking marker
```

## Development Workflow

### Setting Up

1. Clone repository
2. Run `make install` to set up environment with uv
3. Run `make check-all` to verify setup

### Making Changes

1. Create feature branch from main
2. Make changes following code standards
3. Add/update tests
4. Run `make check-all` to verify quality
5. Commit with descriptive messages
6. Submit pull request

### Quality Gates

Before committing, ensure:
- [ ] `make lint` passes (ruff format + check, mypy)
- [ ] `make test` passes with >80% coverage
- [ ] `make security` passes (bandit scan)
- [ ] All new code has type hints
- [ ] All new public APIs have docstrings
- [ ] Tests cover new functionality

## AI Assistant Guidelines

When working with AI assistants on this project:

### Code Generation

- **Request type hints**: Always ask for complete type annotations
- **Specify framework**: Mention we use Typer for CLI, Rich for output
- **Testing focus**: Request tests for new functionality
- **Security awareness**: Remind about security best practices

### Code Review

- Check for type safety and mypy compliance
- Verify CLI commands use Typer patterns correctly
- Ensure Rich is used for output instead of print
- Validate error handling and exit codes
- Review test coverage and quality

### Common Patterns

#### CLI Command Structure
```python
import typer
from rich.console import Console
from typing import Annotated

console = Console()

def command_name(
    param: Annotated[str, typer.Argument(help="Description")],
    option: Annotated[bool, typer.Option("--flag", help="Description")] = False,
) -> None:
    """Command description.

    Args:
        param: Parameter description.
        option: Option description.
    """
    # Implementation here
    console.print("Success!", style="green")
```

#### Error Handling
```python
def process_data(file_path: str) -> dict[str, Any]:
    """Process data file.

    Args:
        file_path: Path to the data file.

    Returns:
        Processed data dictionary.

    Raises:
        FileNotFoundError: If file doesn't exist.
        ValueError: If file format is invalid.
    """
    if not Path(file_path).exists():
        raise FileNotFoundError(f"File not found: {file_path}")
    # Implementation here
```

#### Testing CLI Commands
```python
from typer.testing import CliRunner
from myapp.cli import app

def test_command():
    runner = CliRunner()
    result = runner.invoke(app, ["command", "arg"])
    assert result.exit_code == 0
    assert "expected output" in result.stdout
```

## Dependencies

### Core Dependencies
- `typer[all]` - CLI framework with all features
- `rich` - Terminal formatting and UI (optional based on template config)
- `toml` - Configuration file handling (optional based on template config)

### Development Dependencies
- `pytest` + `pytest-cov` - Testing framework with coverage
- `mypy` - Type checking
- `ruff` - Linting and formatting
- `bandit` - Security scanning
- `build` + `twine` - Package building and publishing

## Common Issues

### Type Checking
- Import types from `typing` or use built-in generics (Python 3.9+)
- Use `Annotated` with Typer for parameter documentation
- Add `# type: ignore` sparingly with explanation comments

### CLI Behavior
- Use `typer.Exit()` for clean exits
- Handle exceptions at the CLI layer, not in core logic
- Use Rich progressbars for long-running operations

### Testing
- Use temporary directories for file operations
- Mock external dependencies
- Test both success and error cases
- Use fixtures for common test data

## Release Process

1. Update version in `pyproject.toml`
2. Update `CHANGELOG.md` with release notes
3. Run `make check-all` to verify quality
4. Run `make build` to create distribution packages
5. Tag release with `git tag v<version>`
6. Push tags to trigger CI/CD
7. Run `make publish` to upload to PyPI (manual step)

## Resources

- [Typer Documentation](https://typer.tiangolo.com/)
- [Rich Documentation](https://rich.readthedocs.io/)
- [uv Documentation](https://docs.astral.sh/uv/)
- [Python Type Hints](https://docs.python.org/3/library/typing.html)
- [pytest Documentation](https://docs.pytest.org/)