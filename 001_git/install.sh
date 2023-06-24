#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing github cli" \
        "brew install gh"
else
    if [[ ! -f "$SCRIPT_DIR/gh_2.23.0_linux_amd64.deb" ]]; then
        run_command "downloading github cli" \
            "wget -O $SCRIPT_DIR/gh_2.23.0_linux_amd64.deb \\
            https://github.com/cli/cli/releases/download/v2.23.0/gh_2.23.0_linux_amd64.deb"
    fi

    run_command "installing github cli" \
        "sudo dpkg -i $SCRIPT_DIR/gh_2.23.0_linux_amd64.deb"
fi

run_command "configuring github cli" \
    "gh config set editor nvim"

run_command "installing github cli dash extension" \
    "gh extension install dlvhdr/gh-dash --force"

run_command "installing github cli notify extension" \
    "gh extension install dcrblack/gh-notify --force"

run_command "installing github cli autocomplete" \
    "gh completion -s zsh > ~/.zsh_functions/_gh && autoload -Uz compinit && compinit"
