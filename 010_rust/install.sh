#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

run_command "installing rust" \
    "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"

run_command "installing agg - asciinema gif generator" \
    "cargo install --git https://github.com/asciinema/agg"

run_command "installing sleek - sql formatter" \
    "cargo install sleek"
