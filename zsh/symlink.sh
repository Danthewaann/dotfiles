#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

echo "$SCRIPT_DIR/.gitignore" "$HOME/.gitignore"

echo "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

echo "$SCRIPT_DIR/.zshenv" "$HOME/.zshenv"

mkdir -p "$HOME/.local/bin"

for f in "$SCRIPT_DIR"/bin/*; do
    echo "$f" "$HOME/.local/bin/$(basename "$f")"
done

echo "$SCRIPT_DIR/completions" "$HOME/.zsh_completions"

if [[ ! -f "$SCRIPT_DIR/.tmux-save-sessions" ]]; then
    cp "$SCRIPT_DIR/.tmux-save-sessions.example" "$SCRIPT_DIR/.tmux-save-sessions"
fi

echo "$SCRIPT_DIR/.tmux-save-sessions" "$HOME/.tmux-save-sessions"

if [[ ! -f "$SCRIPT_DIR/.secretsrc" ]]; then
    cp "$SCRIPT_DIR/.secretsrc.example" "$SCRIPT_DIR/.secretsrc"
fi

echo "$SCRIPT_DIR/.secretsrc" "$HOME/.secretsrc"
