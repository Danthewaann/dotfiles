#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

mkdir -p "$HOME/.config/nvim"
echo "$SCRIPT_DIR/init.vim" "$HOME/.config/nvim/init.vim"

