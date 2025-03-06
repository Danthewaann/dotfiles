#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

echo "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"

mkdir -p "$XDG_CONFIG_HOME/gh-dash"

if [[ ! -f "$SCRIPT_DIR/gh-dash/config.yml" ]]; then
    cp "$SCRIPT_DIR/gh-dash/config.template.yml" "$SCRIPT_DIR/gh-dash/config.yml" 
fi

echo "$SCRIPT_DIR/gh-dash/config.yml" "$XDG_CONFIG_HOME/gh-dash/config.yml"

mkdir -p "$XDG_CONFIG_HOME/gh"
echo "$SCRIPT_DIR/gh/config.yml" "$XDG_CONFIG_HOME/gh/config.yml"
