#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

echo "$SCRIPT_DIR/.vimrc" "$HOME/.vimrc"

echo "$SCRIPT_DIR/coc-settings.json" "$HOME/coc-settings.json"

mkdir -p "$XDG_CONFIG_HOME/clangd"
echo "$SCRIPT_DIR/clangd_config.yaml" "$XDG_CONFIG_HOME/clangd/config.yaml"

mkdir -p "$HOME/.vim/autoload"
for d in "$SCRIPT_DIR"/autoload/*; do
    if [[ -d "$d" ]]; then
        echo "$d" "$HOME/.vim/autoload/$(basename "$d")"
    fi
done

mkdir -p "$HOME/.vim/ftplugin"
for f in "$SCRIPT_DIR"/ftplugin/*; do
    echo "$f" "$HOME/.vim/ftplugin/$(basename "$f")"
done
