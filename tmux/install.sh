#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    brew install tmux
else
    sudo apt-get install -y tmux
fi

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install TPM plugins
~/.tmux/plugins/tpm/scripts/install_plugins.sh

