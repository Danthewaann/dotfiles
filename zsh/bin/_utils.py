from __future__ import annotations

import argparse
import json
import os
import pathlib
import platform
import re
import subprocess
import sys
import textwrap
from typing import TYPE_CHECKING, Any, Literal

if TYPE_CHECKING:
    from _typeshed import StrPath


WHITE_BOLD = "\033[1m"
GREEN_BOLD = "\033[1;32m"
BLUE_BOLD = "\033[1;34m"
RED_BOLD = "\033[1;31m"
YELLOW_BOLD = "\033[1;33m"
YELLOW = "\033[0;33m"
NC = "\033[0m"
RED = "\033[0;31m"


class Parser(argparse.ArgumentParser):
    def parse_args(self, args: Any | None = None, namespace: Any | None = None) -> Any:
        class Arguments:
            colour: Literal["yes", "no", "auto"]

        parsed_args = super().parse_args(args, namespace=Arguments())
        load_colours(parsed_args.colour)
        return parsed_args


def create_parser(prog: str | None = None) -> Parser:
    parser = Parser(prog=prog)
    parser.add_argument(
        "--colour",
        help='colour terminal output, defaults to "%(default)s"',
        choices=("yes", "no", "auto"),
        default="auto",
    )
    return parser


def load_colours(colour: Literal["yes", "no", "auto"]) -> None:
    IN_TTY = sys.stdout.isatty()
    if colour == "no" or (colour == "auto" and not IN_TTY):
        global WHITE_BOLD, GREEN_BOLD, BLUE_BOLD, RED_BOLD, YELLOW_BOLD, YELLOW, NC, RED
        WHITE_BOLD = ""
        GREEN_BOLD = ""
        BLUE_BOLD = ""
        RED_BOLD = ""
        YELLOW_BOLD = ""
        YELLOW = ""
        NC = ""
        RED = ""


def error(message: str, end: str = "\n") -> None:
    print(f"{RED}Error{NC}: {message}", end=end, file=sys.stderr)


def info(message: str, end: str = "\n") -> None:
    print(f"{WHITE_BOLD}{message}{NC}", end=end, file=sys.stderr)


def success(message: str, end: str = "\n") -> None:
    print(f"{GREEN_BOLD}{message}{NC}", end=end, file=sys.stderr)


def warn(message: str, end: str = "\n") -> None:
    print(f"{YELLOW}Warn{NC}: {message}", end=end, file=sys.stderr)


def indent(message: str, prefix="  ") -> str:
    return textwrap.indent(message, prefix)


def inside_worktree() -> bool:
    return (
        run_system_command(
            ["git", "rev-parse", "--is-inside-work-tree"],
            log_output=False,
            exit_on_error=False,
        ).stdout.strip()
        == "true"
    )


def inside_bare_repo() -> bool:
    return (
        run_system_command(
            ["git", "rev-parse", "--is-bare-repository"],
            log_output=False,
            exit_on_error=False,
        ).stdout.strip()
        == "true"
    )


def get_base_branch(check_gh: bool = False) -> str:
    if check_gh:
        proc = run_system_command(
            ["gh", "pr", "view", "--json", "baseRefName"],
            log_output=False,
            exit_on_error=False,
        )
        if proc.returncode == 0:
            return json.loads(proc.stdout)["baseRefName"]

    remote_branches = run_system_command(
        ["git", "remote", "show", "origin"], log_output=False
    ).stdout
    base_branch: str | None = None
    if match := re.search(r"HEAD branch: (.*)", remote_branches):
        base_branch = match.group(1)
    if not base_branch:
        raise ValueError("failed to get base git branch")
    return base_branch


def get_root_git_dir() -> pathlib.Path:
    return pathlib.Path(
        run_system_command(
            ["git", "rev-parse", "--show-toplevel"], log_output=False
        ).stdout.strip()
    )


def get_worktree(branch: str | None = None) -> pathlib.Path:
    branch = branch or get_current_branch()
    worktrees = run_system_command(["git", "worktree", "list"], log_output=False).stdout
    match = re.search(rf"(\S+)\s+(\S+)\s+\[{branch}\]", worktrees)
    if not match:
        raise FileNotFoundError(f"failed to get worktree for branch: {branch}")
    worktree = match.group(1)
    return pathlib.Path(worktree)


def get_ticket_number(branch: str | None = None) -> str | None:
    branch = branch or get_current_branch()
    if match := re.search(r"/\D*(\d+)\D*/", branch):
        return match.group(1)
    warn(f"No ticket number found for {branch}")
    return None


def get_current_branch() -> str:
    return run_system_command(
        ["git", "branch", "--show-current"], log_output=False
    ).stdout.strip()


def get_copy_to_clipboard_command() -> str:
    if platform.system() == "Darwin":
        return "pbcopy"
    return "xclip"


def copy_to_clipboard(value: str) -> None:
    run_system_command(
        [get_copy_to_clipboard_command()],
        input=value.strip(),
        log_output=False,
    )


def run_system_command(
    cmd: list[StrPath],
    input: str | None = None,
    env: dict[str, str] | None = None,
    cwd: StrPath | None = None,
    capture_output: bool = True,
    stdout: int | None = subprocess.PIPE,
    stderr: int | None = subprocess.STDOUT,
    log_output: bool = True,
    exit_on_error: bool = True,
) -> subprocess.CompletedProcess[str]:
    proc = subprocess.run(
        cmd,
        input=input,
        env=env,
        cwd=cwd,
        text=True,
        check=False,
        stdout=stdout if capture_output else None,
        stderr=stderr if capture_output else None,
    )

    if log_output:
        prefix = "  "
        if proc.returncode != 0:
            prefix = "       "
            error(f"failed to run: {' '.join(map(str, cmd))}")

        if proc.stdout:
            print(indent(proc.stdout.rstrip(), prefix=prefix), file=sys.stderr)

    if exit_on_error and proc.returncode != 0:
        sys.exit(1)

    return proc


def run_git_fetch() -> subprocess.CompletedProcess[str]:
    info("Running git fetch...")
    return run_system_command(
        ["git", "-c", "color.ui=always", "fetch"],
    )


def run_git_pull() -> subprocess.CompletedProcess[str]:
    info("Running git pull...")
    return run_system_command(
        ["git", "-c", "color.ui=always", "pull", "--no-all"],
    )


def run_git_rebase(branch: str | None = None) -> subprocess.CompletedProcess[str]:
    branch = branch or get_base_branch(check_gh=True)
    return run_system_command(
        ["git", "-c", "color.ui=always", "rebase", branch],
    )


def run_git_merge(branch: str | None = None) -> subprocess.CompletedProcess[str]:
    branch = branch or get_base_branch(check_gh=True)
    return run_system_command(
        ["git", "-c", "color.ui=always", "merge", branch],
    )


def repo_is_fork() -> tuple[str, str] | None:
    proc = run_system_command(
        ["gh", "repo", "view", "--json", "parent,isFork"],
        log_output=False,
        exit_on_error=False,
    )
    if proc.returncode != 0:
        return None

    settings = json.loads(proc.stdout)
    if settings["isFork"]:
        owner = settings["parent"]["owner"]["login"]
        repo = settings["parent"]["name"]
        return owner, repo

    return None


def update_python_deps() -> None:
    # We need to deactivate the current virtual environment otherwise poetry/uv
    # will install packages into the current virtual environment instead of the new
    # one we want to create for the new worktree.
    env: dict[str, str] = os.environ.copy()
    if env.get("VIRTUAL_ENV"):
        # Remove virtual environment-specific variables
        env.pop("VIRTUAL_ENV", None)
        env.pop("PYTHONHOME", None)
        env.pop("PYTHONPATH", None)

    if pathlib.Path("poetry.lock").exists():
        info("Running poetry install...")
        run_system_command(
            ["poetry", "install", "--all-extras"],
            capture_output=False,
            exit_on_error=False,
            env=env,
        )
    elif pathlib.Path("uv.lock").exists():
        info("Running uv sync...")
        run_system_command(
            ["uv", "sync", "--all-extras"],
            capture_output=False,
            exit_on_error=False,
            env=env,
        )
    elif pathlib.Path("pyproject.toml").exists():
        info("Running uv pip install...")
        run_system_command(
            ["uv", "venv"], capture_output=False, exit_on_error=False, env=env
        )
        run_system_command(
            ["uv", "pip", "install", "-e", ".", "-r", "pyproject.toml", "--all-extras"],
            capture_output=False,
            exit_on_error=False,
            env=env,
        )
