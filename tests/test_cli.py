"""Tests for the CLI application."""

from typer.testing import CliRunner

from [[ project_slug ]] import __version__
from [[ project_slug ]].cli import app

runner = CliRunner()


def test_app_version() -> None:
    """Test the --version option."""
    result = runner.invoke(app, ["--version"])
    assert result.exit_code == 0
    assert f"[[ project_name ]] Version: {__version__}" in result.stdout


def test_app_default_greeting() -> None:
    """Test the default greeting."""
    result = runner.invoke(app)
    assert result.exit_code == 0
    assert "Hello World" in result.stdout


def test_app_custom_greeting() -> None:
    """Test greeting with a custom name."""
    result = runner.invoke(app, ["--name", "Alice"])
    assert result.exit_code == 0
    assert "Hello Alice" in result.stdout
