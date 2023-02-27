#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "setting up initial key-repeat" "set up initial key-repeat" \
        "defaults write -g InitialKeyRepeat -int 15"

    run_command "setting up key-repeat" "set up key-repeat" \
        "defaults write -g KeyRepeat -int 2"
else
    run_command "setting up key-repeat" "set up key-repeat" \
        "gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30" \
        "gsettings set org.gnome.desktop.peripherals.keyboard delay 250"
fi


