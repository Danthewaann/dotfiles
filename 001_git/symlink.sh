#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

echo "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"

echo "$SCRIPT_DIR/themes.gitconfig" "$HOME/themes.gitconfig"

mkdir -p "$HOME/.config/gh-dash"

if [[ ! -f "$SCRIPT_DIR/gh-dash/config.yml" ]]; then
    cp "$SCRIPT_DIR/gh-dash/config.template.yml" "$SCRIPT_DIR/gh-dash/config.yml" 
fi

echo "$SCRIPT_DIR/gh-dash/config.yml" "$HOME/.config/gh-dash/config.yml"

mkdir -p "$HOME/.config/gh"
echo "$SCRIPT_DIR/gh/config.yml" "$HOME/.config/gh/config.yml"
