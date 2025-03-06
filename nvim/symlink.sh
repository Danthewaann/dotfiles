#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

mkdir -p "$XDG_CONFIG_HOME"

echo "$SCRIPT_DIR/nvim" "$XDG_CONFIG_HOME/nvim"

