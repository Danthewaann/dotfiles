#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    # TODO: Need to make sure go is available in PATH
    run_command "installing golang" \
        "brew install go"
else
    if [[ ! -f "$SCRIPT_DIR/go$GO_VERSION.linux-amd64.tar.gz" ]]; then
        run_command "downloading golang $GO_VERSION to -> $SCRIPT_DIR/go$GO_VERSION.linux-amd64.tar.gz" \
                    "wget -O $SCRIPT_DIR/go$GO_VERSION.linux-amd64.tar.gz \\
                    https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz"

        run_command "unpacking $SCRIPT_DIR/go$GO_VERSION.linux-amd64.tar.gz to -> /usr/local/go" \
                    "sudo rm -rf /usr/local/go && \\
                    sudo tar -C /usr/local -xzf $SCRIPT_DIR/go$GO_VERSION.linux-amd64.tar.gz"
    fi
fi

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing golangci-lint" \
        "brew install golangci-lint"
else
    run_command "installing golangci-lint" \
        "curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.56.2"
fi
