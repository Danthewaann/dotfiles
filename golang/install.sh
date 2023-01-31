#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR"/../common

if [[ ! -f "$SCRIPT_DIR/go$GO_VERSION.linux-amd64.tar.gz" ]]; then
    wget -O "$SCRIPT_DIR/go$GO_VERSION.linux-amd64.tar.gz" "https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "$SCRIPT_DIR/go$GO_VERSION.linux-amd64.tar.gz"
fi

# Make sure go is installed
go version

