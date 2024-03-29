#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

echo "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"

mkdir -p "$HOME/.config/kitty"

echo "$SCRIPT_DIR/OneDark.conf" "$HOME/.config/kitty/OneDark.conf"

echo "$SCRIPT_DIR/kitty.conf" "$HOME/.config/kitty/kitty.conf"

echo "$SCRIPT_DIR/kitty-startup.session" "$HOME/.config/kitty/kitty-startup.session"
