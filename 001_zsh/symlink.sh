#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

link_file "$SCRIPT_DIR/.gitignore" "$HOME/.gitignore"

link_file "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

for f in "$SCRIPT_DIR"/bin/*; do
    link_file "$f" "$HOME/.local/bin/$(basename "$f")"
done

link_file "$SCRIPT_DIR/functions" "$HOME/.zsh_functions"

