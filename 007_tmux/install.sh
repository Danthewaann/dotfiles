#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing tmux" \
        "brew install tmux"

    run_command "installing kitty" \
        "brew install --cask kitty"
else
    run_command "installing tmux" \
        "sudo apt-get install -y tmux"

    run_command "installing kitty" \
        "sudo apt-get install -y kitty"
fi

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    run_command "cloning tpm to -> ~/.tmux/plugins/tpm" \
        "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
fi

# Install TPM plugins
run_command "installing tpm plugins" \
    "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"

