#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

# Install Hack Nerd font family
if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing nerd hack fonts" "installed nerd hack fonts" \
        "brew tap homebrew/cask-fonts && brew install font-hack-nerd-font"
else
    if [[ ! -f "$SCRIPT_DIR/Hack.zip" ]]; then
        run_command "downloading nerd hack fonts" "downloaded nerd hack fonts" \
            "wget -O $SCRIPT_DIR/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip"
    fi
    run_command "unpacking fonts to -> /usr/local/share/fonts/" "unpacked fonts to -> /usr/local/share/fonts/" \
        "sudo unzip -o $SCRIPT_DIR/Hack.zip -x \"*.md\" -d /usr/local/share/fonts/"
fi
