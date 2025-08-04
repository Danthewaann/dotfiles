#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

run_command "installing rust" \
    "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y"

run_command "installing agg - asciinema gif generator" \
    "$HOME/.cargo/bin/cargo install --git https://github.com/asciinema/agg"

run_command "installing sleek - sql formatter" \
    "$HOME/.cargo/bin/cargo install sleek"

run_command "installing presenterm - markdown slides in the terminal" \
    "$HOME/.cargo/bin/cargo install presenterm --version 0.15.1"
