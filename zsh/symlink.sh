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

echo "$SCRIPT_DIR/.tmux-default-sessions" "$HOME/.tmux-default-sessions"

if [[ ! -f "$SCRIPT_DIR/.secretsrc" ]]; then
    cp "$SCRIPT_DIR/.secretsrc.example" "$SCRIPT_DIR/.secretsrc"
fi

echo "$SCRIPT_DIR/.secretsrc" "$HOME/.secretsrc"
