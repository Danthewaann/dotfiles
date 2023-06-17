#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

echo "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"

mkdir -p "$HOME/.config"
echo "$SCRIPT_DIR/gh-dash" "$HOME/.config/gh-dash"
