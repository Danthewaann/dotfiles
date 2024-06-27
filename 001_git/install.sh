#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing github cli" \
        "brew install gh"
else
    run_command "installing git" \
        "sudo apt-get install software-properties-common && \\
            sudo apt-add-repository -y ppa:git-core/ppa && \\
            sudo apt-get -y update && \\
            sudo apt-get -y install git"

    if [[ ! -f "$SCRIPT_DIR/gh_2.31.0_linux_amd64.deb" ]]; then
        run_command "downloading github cli" \
            "wget -O $SCRIPT_DIR/gh_2.31.0_linux_amd64.deb \\
            https://github.com/cli/cli/releases/download/v2.31.0/gh_2.31.0_linux_amd64.deb"
    fi

    run_command "installing github cli" \
        "sudo dpkg -i $SCRIPT_DIR/gh_2.31.0_linux_amd64.deb"
fi

run_command "logging into github" \
    "gh auth status || gh auth login"

run_command "configuring github cli" \
    "gh config set editor nvim"

run_command "installing github cli dash extension" \
    "gh extension install dlvhdr/gh-dash --force --pin v4.0.0"

run_command "installing github cli notify extension" \
    "gh extension install dcrblack/gh-notify --force"

run_command "installing github cli autocomplete" \
    "gh completion -s zsh > ~/.zsh_functions/_gh"
