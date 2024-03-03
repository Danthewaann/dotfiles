#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

mkdir -p "$HOME/.docker"

if [[ ! -f "$SCRIPT_DIR/config.json" ]]; then
    cp "$SCRIPT_DIR/config.template.json" "$SCRIPT_DIR/config.json" 
fi

echo "$SCRIPT_DIR/config.json" "$HOME/.docker/config.json"
