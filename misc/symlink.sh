#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

echo "$SCRIPT_DIR/.jq" "$HOME/.jq"

echo "$SCRIPT_DIR/keyd.conf" "/etc/keyd/default.conf"

echo "$SCRIPT_DIR/i3" "$XDG_CONFIG_HOME/i3"
