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
else
    run_command "setting up key-repeat" "set up key-repeat" \
        "gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30" \
        "gsettings set org.gnome.desktop.peripherals.keyboard delay 150"
fi


