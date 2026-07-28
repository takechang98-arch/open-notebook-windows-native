from pathlib import Path

from open_notebook.startup import resolve_command, resolve_compose_file


def test_resolve_command_uses_cmd_shim_on_windows():
    resolved = resolve_command("npm", "win32")
    assert resolved[0].endswith("npm.cmd") or resolved[0].endswith("npm.exe")


def test_resolve_compose_file_prefers_examples_dev(tmp_path: Path):
    examples_dir = tmp_path / "examples"
    examples_dir.mkdir()
    compose_file = examples_dir / "docker-compose-dev.yml"
    compose_file.write_text("services: {}\n", encoding="utf-8")

    assert resolve_compose_file(tmp_path) == compose_file
