#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "setting up key-repeat" "set up key-repeat" \
        "defaults write -g InitialKeyRepeat -int 10" \  # normal minimum is 15 (225 ms)
        "defaults write -g KeyRepeat -int 1" # normal minimum is 2 (30 ms)
else
    run_command "setting up key-repeat" "set up key-repeat" \
        "gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30" \
        "gsettings set org.gnome.desktop.peripherals.keyboard delay 250"
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    run_command "installing oh-my-zsh" "installed oh-my-zsh" \
        "sh -c \"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
fi

