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
        "wget -O $SCRIPT_DIR/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip"
fi

if [[ ! -f "$SCRIPT_DIR/JetBrainsMono.zip" ]]; then
    run_command "downloading jet brains mono fonts" \
        "wget -O $SCRIPT_DIR/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
fi

if [[ ! -f "$SCRIPT_DIR/Iosevka.zip" ]]; then
    run_command "downloading iosevka fonts" \
        "wget -O $SCRIPT_DIR/Iosevka.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Iosevka.zip"
fi

# Install Hack Nerd font family
if [[ $OSTYPE == "darwin"* ]]; then
    run_command "unpacking nerd hack fonts to -> $HOME/Library/Fonts/" \
        "unzip -o $SCRIPT_DIR/Hack.zip -x \"*.md\" -d $HOME/Library/Fonts/"
    run_command "unpacking jet brains mono fonts to -> $HOME/Library/Fonts/" \
        "unzip -o $SCRIPT_DIR/JetBrainsMono.zip -x \"*.md\" -d $HOME/Library/Fonts/"
    run_command "unpacking iosevka fonts to -> $HOME/Library/Fonts/" \
        "unzip -o $SCRIPT_DIR/Iosevka.zip -x \"*.md\" -d $HOME/Library/Fonts/"
else
    run_command "unpacking nerd hack fonts to -> /usr/local/share/fonts/" \
        "sudo unzip -o $SCRIPT_DIR/Hack.zip -x \"*.md\" -d /usr/local/share/fonts/"
    run_command "unpacking jet brains mono fonts to -> /usr/local/share/fonts/" \
        "sudo unzip -o $SCRIPT_DIR/JetBrainsMono.zip -x \"*.md\" -d /usr/local/share/fonts/"
    run_command "unpacking iosevka fonts to -> /usr/local/share/fonts/" \
        "sudo unzip -o $SCRIPT_DIR/Iosevka.zip -x \"*.md\" -d /usr/local/share/fonts/"
fi

run_command "refreshing font cache" \
    "fc-cache -r -v"
