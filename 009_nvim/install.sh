#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

# Install neovim
if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing nvim" \
        "brew install neovim"
else
    run_command "installing vim" \
        "sudo apt-get install -y neovim"
fi

