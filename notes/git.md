## Git

### Links

- https://ohshitgit.com/ (reference for fixing common git issues)

### Commands

Squash all commits to `main` locally (from https://www.internalpointers.com/post/squash-commits-into-one-git)

```bash
git rebase -i main
```

Remove all untracked files in a git repo

```bash
git clean -f -d
```

Get number of lines changed in unstaged files

```bash
git diff --shortstat
```

Get number of lines changed in staged files

```bash
git diff --shortstat --cached
```

Show full history of file

```bash
git log --all --full-history "**/thefile.*"

# Or

git log --all --full-history "<path-to-file>"

# Or oneline

git log --all --full-history --oneline "<path-to-file>"
```
