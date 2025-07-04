import os
import re
import subprocess
import sys
import pathlib

WHITE_BOLD = "\033[1m"
GREEN_BOLD = "\033[1;32m"
BLUE_BOLD = "\033[1;34m"
RED_BOLD = "\033[1;31m"
YELLOW_BOLD = "\033[1;33m"
YELLOW = "\033[0;33m"
NC = "\033[0m"
RED = "\033[0;31m"


def error(message: str) -> None:
    print(f"{RED}ERROR: {message}{NC}", file=sys.stderr)


def info(message: str) -> None:
    print(f"{WHITE_BOLD}{message}{NC}", file=sys.stderr)


def success(message: str) -> None:
    print(f"{GREEN_BOLD}{message}{NC}", file=sys.stderr)


def warn(message: str) -> None:
    print(f"{YELLOW}WARN: {message}{NC}", file=sys.stderr)


def inside_worktree() -> bool:
    return (
        subprocess.run(
            ["git", "rev-parse", "--is-inside-work-tree"],
            text=True,
            capture_output=True,
        ).stdout.strip()
        == "true"
    )


def inside_bare_repo() -> bool:
    return (
        subprocess.run(
            ["git", "rev-parse", "--is-bare-repository"], text=True, capture_output=True
        ).stdout.strip()
        == "true"
    )


def get_base_branch() -> str:
    base_branch_file = pathlib.Path(".base_branch")
    if not base_branch_file.exists():
        remote_branches = subprocess.check_output(
            ["git", "remote", "show", "origin"], text=True
        )
        base_branch: str | None = None
        if match := re.search(r"HEAD branch: (.*)", remote_branches):
            base_branch = match.group(1)
        if not base_branch:
            raise ValueError("failed to get base git branch")
        base_branch_file.write_text(base_branch)
        return base_branch
    return base_branch_file.read_text().strip()


def get_worktree(branch: str | None = None) -> pathlib.Path:
    branch = branch or get_base_branch()
    worktrees = subprocess.check_output(["git", "worktree", "list"], text=True)
    match = re.search(rf"(\S+)\s+(\S+)\s+\[{branch}\]", worktrees)
    if not match:
        raise ValueError("failed to get worktree")
    worktree = match.group(1)
    return pathlib.Path(worktree)


def get_ticket_number(branch: str | None = None) -> str | None:
    branch = (
        branch
        or subprocess.check_output(
            ["git", "branch", "--show-current"], text=True
        ).strip()
    )
    if match := re.search(r"/\D*(\d+)\D*/", branch):
        return match.group(1)
    error(f"No ticket number found for {branch}")
    return None


def run_git_fetch() -> None:
    info("Running git fetch...")
    proc = subprocess.run(
        ["git", "-c", "color.ui=always", "fetch"],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    if proc.stdout:
        print(proc.stdout.rstrip(), file=sys.stderr)
    if proc.returncode != 0:
        sys.exit(1)


def run_git_pull() -> None:
    proc = subprocess.run(
        ["git", "-c", "color.ui=always", "pull", "--no-all"],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    if proc.stdout:
        print(proc.stdout.rstrip(), file=sys.stderr)
    if proc.returncode != 0:
        sys.exit(1)


def run_git_rebase(branch: str | None = None) -> None:
    branch = branch or get_base_branch()

    proc = subprocess.run(
        ["git", "-c", "color.ui=always", "rebase", branch],
        text=True,
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    if proc.stdout:
        print(proc.stdout.rstrip(), file=sys.stderr)
    if proc.returncode != 0:
        sys.exit(1)


def update_python_deps() -> None:
    if pathlib.Path("poetry.lock").exists():
        print(file=sys.stderr)
        info("Running poetry install...")
        print(file=sys.stderr)
        # We need to deactivate the current virtual environment otherwise poetry install
        # will install packages into the current virtual environment instead of the new
        # one we want to create for the new worktree.
        if os.getenv("VIRTUAL_ENV"):
            subprocess.run(["deactivate"])
        subprocess.run(["poetry", "install", "--all-extras"])
    elif pathlib.Path("pyproject.lock").exists():
        print(file=sys.stderr)
        info("Running uv pip install with pyproject.toml...")
        print(file=sys.stderr)
        subprocess.run(["uv", "venv"])
        subprocess.run(
            ["uv", "pip", "install", "-e", ".", "-r", "pyproject.toml", "--all-extras"]
        )
