#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "setting up initial key-repeat" "set up initial key-repeat" \
        "defaults write -g InitialKeyRepeat -int 10"

    run_command "setting up key-repeat" "set up key-repeat" \
        "defaults write -g KeyRepeat -int 1"

    run_command "installing watch" "installed watch" \
        "brew install watch"

    run_command "installing jq" "installed jq" \
        "brew install jq"
else
    run_command "setting up key-repeat" "set up key-repeat" \
        "gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30" \
        "gsettings set org.gnome.desktop.peripherals.keyboard delay 150"
fi

if [[ ! -d $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
    run_command "installing zsh-autosuggestions" "installed zsh-autosuggestions" \
        "git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

if [[ ! -d $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
    run_command "installing zsh-syntax-highlighting" "installed zsh-syntax-highlighting" \
        "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
fi

