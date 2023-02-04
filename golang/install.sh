#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    # TODO: Need to make sure go is available in PATH
    brew install go
else
    if [[ ! -f "$SCRIPT_DIR/go$GO_VERSION.linux-amd64.tar.gz" ]]; then
        wget -O "$SCRIPT_DIR/go$GO_VERSION.linux-amd64.tar.gz" "https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz"
        sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "$SCRIPT_DIR/go$GO_VERSION.linux-amd64.tar.gz"
    fi
fi

# Make sure go is installed
go version

