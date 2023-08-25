#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if inside_wsl; then
    warn "skipping fonts setup inside WSL"
    exit 0
fi

if [[ ! -f "$SCRIPT_DIR/Hack.zip" ]]; then
    run_command "downloading nerd hack fonts" \
        "wget -O $SCRIPT_DIR/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip"
fi

# Install Hack Nerd font family
if [[ $OSTYPE == "darwin"* ]]; then
    run_command "unpacking fonts to -> $HOME/Library/Fonts/" \
        "unzip -o $SCRIPT_DIR/Hack.zip -x \"*.md\" -d $HOME/Library/Fonts/"
else
    run_command "unpacking fonts to -> /usr/local/share/fonts/" \
        "sudo unzip -o $SCRIPT_DIR/Hack.zip -x \"*.md\" -d /usr/local/share/fonts/"
fi
