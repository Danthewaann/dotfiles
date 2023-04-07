#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

run_command "downloading nvm" \
    "curl -s -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash"

export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# shellcheck disable=SC1091
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install node and npm
run_command "installing node $MY_NODE_VERSION" \
    "nvm install $MY_NODE_VERSION"

run_command "making node $MY_NODE_VERSION the default" \
    "nvm alias default $MY_NODE_VERSION"

run_command "using node $MY_NODE_VERSION" \
    "nvm use default"

# Install bash language server
run_command "installing bash-language-server" \
    "npm i -g bash-language-server"

