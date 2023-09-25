#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing fzf" \
        "brew install fzf"

    run_command "installing shellcheck" \
        "brew install shellcheck"

    run_command "installing git-delta" \
        "brew install git-delta"

    run_command "installing bat" \
        "brew install bat"

    run_command "installing ripgrep" \
        "brew install ripgrep"

    run_command "installing watchman" \
        "brew install watchman"

    run_command "installing rename" \
        "brew install rename"
else
    run_command "installing fzf" \
        "sudo apt-get install -y fzf"

    run_command "installing shellcheck" \
        "sudo apt-get install -y shellcheck"

    if [[ ! -f "$SCRIPT_DIR/git-delta.deb" ]]; then
        run_command "downloading git-delta" \
            "wget -O $SCRIPT_DIR/git-delta.deb https://github.com/dandavison/delta/releases/download/0.15.1/git-delta_0.15.1_amd64.deb"
    fi

    run_command "installing git-delta" \
        "sudo dpkg -i $SCRIPT_DIR/git-delta.deb"

    if [[ ! -f "$SCRIPT_DIR/bat.deb" ]]; then
        run_command "downloading bat" \
            "wget -O $SCRIPT_DIR/bat.deb https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-musl_0.22.1_amd64.deb"
    fi

    run_command "installing bat" \
        "sudo dpkg -i $SCRIPT_DIR/bat.deb"

    run_command "installing ripgrep" \
        "sudo apt-get install -y ripgrep"

    run_command "installing watchman" \
        "sudo apt-get install -y watchman"

    run_command "installing rename" \
        "sudo apt-get install -y rename"
fi
