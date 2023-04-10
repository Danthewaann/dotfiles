#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

echo "$SCRIPT_DIR/.gitignore" "$HOME/.gitignore"

echo "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

for f in "$SCRIPT_DIR"/bin/*; do
    echo "$f" "$HOME/.local/bin/$(basename "$f")"
done

echo "$SCRIPT_DIR/functions" "$HOME/.zsh_functions"

