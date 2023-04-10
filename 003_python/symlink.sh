#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

link_file "$SCRIPT_DIR/pyrightconfig.json" "$HOME/pyrightconfig.json"

link_file "$SCRIPT_DIR/black" "$HOME/.config/black"
