"""Command-line interface for the [[ project_name ]] package."""

from typing_extensions import Annotated

import typer

from [[ project_slug ]] import __version__

app = typer.Typer()


def version_callback(value: bool) -> None:
    """Prints the version of the package."""
    if value:
        typer.echo(f"[[ project_name ]] Version: {__version__}")
        raise typer.Exit()


@app.command()
def main(
    name: Annotated[str, typer.Option("--name", "-n", help="Name to greet.")] = "World",
    version: Annotated[
        bool,
        typer.Option(
            "--version",
            callback=version_callback,
            is_eager=True,
            help="Show the application's version and exit.",
        ),
    ] = False,
) -> None:
    """
    A simple "hello world" CLI application.

    Args:
        name: The name to greet.
        version: A flag to show the application's version and exit.
    """
    typer.echo(f"Hello {name}")


if __name__ == "__main__":
    app()
