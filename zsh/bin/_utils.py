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
        for branch in remote_branches.splitlines():
            if "HEAD branch" in branch:
                base_branch = branch.split()[4]
                break

        if not base_branch:
            raise ValueError("failed to get base git branch")

        base_branch_file.write_text(base_branch)
        return base_branch

    return base_branch_file.read_text().strip()


def get_worktree(branch: str | None = None) -> str:
    branch = branch or get_base_branch()

    worktrees = subprocess.check_output(["git", "worktree", "list"], text=True)

    match = re.search(rf"(\S+)\s+(\S+)\s+\[{branch}\]", worktrees)

    if not match:
        raise ValueError("failed to get worktree")

    worktree = match.group(1)

    return worktree
