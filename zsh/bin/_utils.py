from __future__ import annotations

import argparse
import functools
import json
import os
import pathlib
import re
import subprocess
import sys
import textwrap
from collections.abc import Callable, Sequence
from typing import TYPE_CHECKING, Any

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
        parsed_args = super().parse_args(args, namespace)
        load_colours(parsed_args.colour)
        return parsed_args


def create_parser(prog: str) -> Parser:
    parser = Parser(prog=prog)
    parser.add_argument("--colour", action="store_true", default=False)
    return parser


def load_colours(enable: bool = False) -> None:
    IN_TTY = sys.stdout.isatty()
    if not enable and not IN_TTY:
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
    print(f"{RED}ERROR: {message}{NC}", end=end, file=sys.stderr)


def info(message: str, end: str = "\n") -> None:
    print(f"{WHITE_BOLD}{message}{NC}", end=end, file=sys.stderr)


def success(message: str, end: str = "\n") -> None:
    print(f"{GREEN_BOLD}{message}{NC}", end=end, file=sys.stderr)


def warn(message: str, end: str = "\n") -> None:
    print(f"{YELLOW}WARN: {message}{NC}", end=end, file=sys.stderr)


def indent(message: str, prefix="  ") -> str:
    return textwrap.indent(message, prefix)


def inside_worktree() -> bool:
    return (
        subprocess.run(
            ["git", "rev-parse", "--is-inside-work-tree"],
            text=True,
            check=False,
            capture_output=True,
        ).stdout.strip()
        == "true"
    )


def inside_bare_repo() -> bool:
    return (
        subprocess.run(
            ["git", "rev-parse", "--is-bare-repository"],
            text=True,
            check=False,
            capture_output=True,
        ).stdout.strip()
        == "true"
    )


def get_base_branch(check_gh: bool = False) -> str:
    info("Fetching base branch...")
    if check_gh:
        proc = subprocess.run(
            ["gh", "pr", "view", "--json", "baseRefName"],
            text=True,
            check=False,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )
        if proc.returncode == 0:
            return json.loads(proc.stdout)["baseRefName"]

    remote_branches = check_output(["git", "remote", "show", "origin"])
    base_branch: str | None = None
    if match := re.search(r"HEAD branch: (.*)", remote_branches):
        base_branch = match.group(1)
    if not base_branch:
        raise ValueError("failed to get base git branch")
    return base_branch


def get_root_git_dir() -> pathlib.Path:
    return pathlib.Path(check_output(["git", "rev-parse", "--show-toplevel"]).strip())


def get_worktree(branch: str | None = None) -> pathlib.Path:
    branch = branch or get_current_branch()
    worktrees = check_output(["git", "worktree", "list"])
    match = re.search(rf"(\S+)\s+(\S+)\s+\[{branch}\]", worktrees)
    if not match:
        raise ValueError("failed to get worktree")
    worktree = match.group(1)
    return pathlib.Path(worktree)


def get_ticket_number(branch: str | None = None) -> str | None:
    branch = branch or get_current_branch()
    if match := re.search(r"/\D*(\d+)\D*/", branch):
        return match.group(1)
    warn(f"No ticket number found for {branch}")
    return None


def get_current_branch() -> str:
    return check_output(["git", "branch", "--show-current"]).strip()


def run_and_log_command(
    cmd: Sequence[str | StrPath],
) -> subprocess.CompletedProcess[str]:
    proc = subprocess.run(
        cmd, text=True, check=False, stdout=subprocess.PIPE, stderr=subprocess.STDOUT
    )
    log: Callable[[str], None] = functools.partial(print, file=sys.stderr)
    if proc.returncode != 0:
        log = error
    if proc.stdout:
        log(indent(proc.stdout.rstrip()))

    return proc


def check_output(cmd: Sequence[str | StrPath]) -> str:
    try:
        return subprocess.check_output(cmd, text=True, stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        error(e.stdout.rstrip())
        sys.exit(1)


def run_git_fetch() -> subprocess.CompletedProcess[str]:
    info("Running git fetch...")
    return run_and_log_command(
        ["git", "-c", "color.ui=always", "fetch"],
    )


def run_git_pull() -> subprocess.CompletedProcess[str]:
    return run_and_log_command(
        ["git", "-c", "color.ui=always", "pull", "--no-all"],
    )


def run_git_rebase(branch: str | None = None) -> subprocess.CompletedProcess[str]:
    branch = branch or get_base_branch(check_gh=True)
    return run_and_log_command(
        ["git", "-c", "color.ui=always", "rebase", branch],
    )


def run_git_merge(branch: str | None = None) -> subprocess.CompletedProcess[str]:
    branch = branch or get_base_branch(check_gh=True)
    return run_and_log_command(
        ["git", "-c", "color.ui=always", "merge", branch],
    )


def repo_is_fork() -> tuple[str, str] | None:
    proc = subprocess.run(
        ["gh", "repo", "view", "--json", "parent,isFork"],
        check=False,
        text=True,
        capture_output=True,
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
        subprocess.run(["poetry", "install", "--all-extras"], check=False, env=env)
    elif pathlib.Path("uv.lock").exists():
        info("Running uv sync...")
        subprocess.run(["uv", "sync", "--all-extras"], check=False, env=env)
    elif pathlib.Path("pyproject.toml").exists():
        info("Running uv pip install...")
        subprocess.run(["uv", "venv"], check=False, env=env)
        subprocess.run(
            ["uv", "pip", "install", "-e", ".", "-r", "pyproject.toml", "--all-extras"],
            check=False,
            env=env,
        )
