#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

# Install neovim
if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing neovim" \
        "brew install neovim"
else
    run_command "installing neovim" \
        "sudo apt-get install -y neovim"
fi

if [[ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]]; then
    run_command "installing packer plugin manager" \
        "git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
fi

