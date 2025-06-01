#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

# Install vim 9
if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing vim" \
        "brew install vim"
else
    run_command "installing vim" \
        "sudo add-apt-repository -y ppa:jonathonf/vim" \
        "sudo apt-get install -y vim"
fi

