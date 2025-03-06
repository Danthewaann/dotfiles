#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

echo "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"

mkdir -p "$XDG_CONFIG_HOME/kitty"

echo "$SCRIPT_DIR/OneDark.conf" "$XDG_CONFIG_HOME/kitty/OneDark.conf"

echo "$SCRIPT_DIR/kitty.conf" "$XDG_CONFIG_HOME/kitty/kitty.conf"

echo "$SCRIPT_DIR/kitty-startup.session" "$XDG_CONFIG_HOME/kitty/kitty-startup.session"
