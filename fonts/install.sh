#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Install Hack Nerd font family
if [[ $OSTYPE == "darwin"* ]]; then
    brew tap homebrew/cask-fonts
    brew install font-hack-nerd-font
else
    if [[ ! -f "$SCRIPT_DIR/Hack.zip" ]]; then
        wget -O "$SCRIPT_DIR/Hack.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip 
    fi
    sudo unzip -o "$SCRIPT_DIR/Hack.zip" -x "*.md" -d /usr/local/share/fonts/
fi
