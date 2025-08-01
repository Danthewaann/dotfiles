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
        "sudo apt-get install git -y"

    if [[ ! -f "$SCRIPT_DIR"/gh_"$GH_CLI_VERSION"_linux_amd64.deb ]]; then
        run_command "downloading github cli" \
            "wget -O $SCRIPT_DIR/gh_${GH_CLI_VERSION}_linux_amd64.deb \\
            https://github.com/cli/cli/releases/download/v$GH_CLI_VERSION/gh_${GH_CLI_VERSION}_linux_amd64.deb"
    fi

    run_command "installing github cli" \
        "sudo dpkg -i $SCRIPT_DIR/gh_${GH_CLI_VERSION}_linux_amd64.deb"
fi

run_command "logging into github" \
    "gh auth status || gh auth login"

run_command "configuring github cli" \
    "gh config set editor nvim"

run_command "installing github cli dash extension" \
    "gh extension install dlvhdr/gh-dash"

run_command "installing github cli notify extension" \
    "gh extension install meiji163/gh-notify"
