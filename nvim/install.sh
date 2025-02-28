#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

run_command "installing neovim bob version manager" \
    "$HOME/.cargo/bin/cargo install --git https://github.com/MordechaiHadad/bob.git"

run_command "installing neovim" \
    "$HOME/.cargo/bin/bob install nightly && bob use nightly"

