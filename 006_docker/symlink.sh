#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

mkdir -p "$HOME/.docker"

echo "$SCRIPT_DIR/config.json" "$HOME/.docker/config.json"
