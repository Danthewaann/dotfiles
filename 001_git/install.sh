#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing github cli" "installed github cli" \
        "brew install gh"
else
    if [[ ! -f "$SCRIPT_DIR/gh_2.23.0_linux_amd64.deb" ]]; then
        run_command "downloading github cli" "downloaded github cli" \
            "wget -O $SCRIPT_DIR/gh_2.23.0_linux_amd64.deb \\
            https://github.com/cli/cli/releases/download/v2.23.0/gh_2.23.0_linux_amd64.deb"
    fi

    run_command "installing github cli" "installed github cli" \
        "sudo dpkg -i $SCRIPT_DIR/gh_2.23.0_linux_amd64.deb"
fi

run_command "configuring github cli" "configured github cli" \
    "gh config set editor vim"

info "linking git post-checkout hook"
link_file "$SCRIPT_DIR/post-checkout" "$HOME/post-checkout"
