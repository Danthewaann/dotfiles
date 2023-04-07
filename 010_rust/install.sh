#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

run_command "installing rust" \
    "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"

run_command "installing rust-analyzer" \
    "$(which rustup) component add rust-analyzer"

info "linking rust-analyzer"
link_file "$(rustup which --toolchain stable rust-analyzer)" "$HOME/.cargo/bin/rust-analyzer"
