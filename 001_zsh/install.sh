#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "setting up initial key-repeat" \
        "defaults write -g InitialKeyRepeat -int 10"

    run_command "setting up key-repeat" \
        "defaults write -g KeyRepeat -int 1"

    run_command "installing watch" \
        "brew install watch"

    run_command "installing jq" \
        "brew install jq"

    run_command "installing gsed" \
        "brew install gnu-sed"

    run_command "installing wget" \
        "brew install wget"
else
    run_command "setting up key-repeat" \
        "gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 10" \
        "gsettings set org.gnome.desktop.peripherals.keyboard delay 150"

    run_command "installing xclip" \
        "sudo apt-get install -y xclip"
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [[ ! -d $ZSH_CUSTOM/plugins/zsh-autosuggestions ]]; then
    run_command "installing zsh-autosuggestions" \
        "git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [[ ! -d $ZSH_CUSTOM/plugins/fast-syntax-highlighting ]]; then
    run_command "installing fast-syntax-highlighting" \
        "git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting"
fi

if [[ ! -d $ZSH_CUSTOM/plugins/zsh-vi-mode ]]; then
    run_command "installing zsh-vi-mode" \
        "git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode"
fi

if [[ ! -d $ZSH_CUSTOM/plugins/zsh-git-prompt ]]; then
    run_command "installing zsh-git-prompt" \
        "git clone https://github.com/dcrblack/zsh-git-prompt $ZSH_CUSTOM/plugins/zsh-git-prompt"
fi
