#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

echo "$SCRIPT_DIR/.jq" "$HOME/.jq"

echo "$SCRIPT_DIR/keyd.conf" "/etc/keyd/default.conf" "true"

echo "$SCRIPT_DIR/i3" "$XDG_CONFIG_HOME/i3"

echo "$SCRIPT_DIR/rofi" "$XDG_CONFIG_HOME/rofi"

echo "$SCRIPT_DIR/polybar" "$XDG_CONFIG_HOME/polybar"

echo "$SCRIPT_DIR/lockscreen" "$HOME/.local/bin/lockscreen"

echo "$SCRIPT_DIR/dunst" "$XDG_CONFIG_HOME/dunst"

echo "$SCRIPT_DIR/picom" "$XDG_CONFIG_HOME/picom"
