#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

link_file "$SCRIPT_DIR/.vimrc" "$HOME/.vimrc"

link_file "$SCRIPT_DIR/coc-settings.json" "$HOME/coc-settings.json"

link_file "$SCRIPT_DIR/.vimspector.json" "$HOME/.vimspector.json"

mkdir -p "$HOME/.config/clangd"
link_file "$SCRIPT_DIR/clangd_config.yaml" "$HOME/.config/clangd/config.yaml"

for d in "$SCRIPT_DIR"/autoload/*; do
    if [[ -d "$d" ]]; then
        link_file "$d" "$HOME/.vim/autoload/$(basename "$d")"
    fi
done

