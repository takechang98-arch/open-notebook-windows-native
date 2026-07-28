from __future__ import annotations

import os
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Iterable


def resolve_command(command: str, platform_name: str | None = None) -> list[str]:
    """Return a platform-appropriate command invocation for subprocess execution."""
    platform_name = platform_name or sys.platform
    if platform_name.startswith("win") and command not in {"python", "python3"}:
        candidates = [f"{command}.cmd", f"{command}.exe", command]
    else:
        candidates = [command]

    for candidate in candidates:
        resolved = shutil.which(candidate)
        if resolved:
            return [resolved]

    return [command]


def resolve_compose_file(repo_root: Path | None = None) -> Path:
    """Resolve the compose file to use for local development startup."""
    root = repo_root or Path(__file__).resolve().parent.parent
    candidates = [
        root / "examples" / "docker-compose-dev.yml",
        root / "docker-compose.yml",
    ]
    for candidate in candidates:
        if candidate.exists():
            return candidate
    raise FileNotFoundError("No docker compose file found for local startup")


def _run_command(command: Iterable[str], *, cwd: Path, env: dict[str, str] | None = None) -> subprocess.Popen[str]:
    merged_env = os.environ.copy()
    if env:
        merged_env.update(env)
    return subprocess.Popen(list(command), cwd=str(cwd), env=merged_env, stdout=None, stderr=None)


def launch_services(repo_root: Path | None = None) -> list[subprocess.Popen[str]]:
    root = repo_root or Path(__file__).resolve().parent.parent
    env = os.environ.copy()
    env.setdefault("OPEN_NOTEBOOK_WORKER_MAX_TASKS", "1")

    processes: list[subprocess.Popen[str]] = []

    compose_file = resolve_compose_file(root)
    print(f"Using compose file: {compose_file}")

    if shutil.which("docker"):
        processes.append(
            _run_command(
                ["docker", "compose", "-f", str(compose_file), "--project-directory", str(root), "up", "-d", "surrealdb"],
                cwd=root,
                env=env,
            )
        )
    elif shutil.which("surreal"):
        db_path = root / "surreal_data" / "mydatabase.db"
        db_path.parent.mkdir(parents=True, exist_ok=True)
        processes.append(
            _run_command(
                ["surreal", "start", "--user", "root", "--pass", "root", "--bind", "127.0.0.1:8000", f"rocksdb:{db_path}"],
                cwd=root,
                env=env,
            )
        )
    else:
        raise RuntimeError("Neither docker nor surreal is available on this machine")

    processes.append(
        _run_command(
            resolve_command("uv") + ["run", "--env-file", ".env", "run_api.py"],
            cwd=root,
            env={**env, "HOST": "0.0.0.0", "API_HOST": "0.0.0.0"},
        )
    )

    processes.append(
        _run_command(
            resolve_command("uv") + ["run", "--env-file", ".env", "surreal-commands-worker", "--import-modules", "commands", "--max-tasks", env.get("OPEN_NOTEBOOK_WORKER_MAX_TASKS", "1")],
            cwd=root,
            env=env,
        )
    )

    frontend_cmd = resolve_command("npm") + ["run", "dev"]
    processes.append(
        _run_command(frontend_cmd, cwd=root / "frontend", env=env)
    )

    return processes


if __name__ == "__main__":
    launch_services()
