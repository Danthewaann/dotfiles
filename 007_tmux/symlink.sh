#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

link_file "$SCRIPT_DIR/OneDark.conf" "$HOME/.config/kitty/OneDark.conf"

link_file "$SCRIPT_DIR/kitty.conf" "$HOME/.config/kitty/kitty.conf"

