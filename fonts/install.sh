#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

# Install Hack Nerd font family
if [[ $OSTYPE == "darwin"* ]]; then
    info "installing nerd hack fonts"
    if ! output=$(brew tap homebrew/cask-fonts && brew install font-hack-nerd-font 2>&1); then
        fail "$output"
    fi
    success "installed nerd hack fonts"
else
    if [[ ! -f "$SCRIPT_DIR/Hack.zip" ]]; then
        info "downloading nerd hack fonts"
        if ! output=$(wget -O "$SCRIPT_DIR/Hack.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip 2>&1); then
            fail "$output"
        fi
        success "downloaded nerd hack fonts"
    fi
    info "unpacking fonts to -> /usr/local/share/fonts/"
    if ! output=$(sudo unzip -o "$SCRIPT_DIR/Hack.zip" -x "*.md" -d /usr/local/share/fonts/ 2>&1); then
        fail "$output"
    fi
    success "unpacked fonts to -> /usr/local/share/fonts/"
fi
