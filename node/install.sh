#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

# This is needed to prevent nvm from updating our .zshrc file
export PROFILE=/dev/null

run_command "downloading nvm" \
    "curl -s -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash"

# # Setup node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install node and npm
run_command "installing node $NODE_VERSION" \
    "nvm install $NODE_VERSION"

run_command "making node $NODE_VERSION the default" \
    "nvm alias default $NODE_VERSION"

run_command "using node $NODE_VERSION" \
    "nvm use default"

run_command "installing prettierd" \
    "npm i -g @fsouza/prettierd"

run_command "installing commitlint" \
    "npm install -g @commitlint/{config-conventional,cli}"

run_command "installing tree-sitter CLI" \
    "npm install -g tree-sitter-cli"
