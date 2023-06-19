#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

echo "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"

echo "$SCRIPT_DIR/themes.gitconfig" "$HOME/themes.gitconfig"

mkdir -p "$HOME/.config"
echo "$SCRIPT_DIR/gh-dash" "$HOME/.config/gh-dash"

mkdir -p "$HOME/.config/gh"
echo "$SCRIPT_DIR/gh/config.yml" "$HOME/.config/gh/config.yml"
