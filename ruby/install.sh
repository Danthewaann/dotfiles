#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

# Install Python build dependencies
if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing dependencies" \
        "brew install openssl@1.1 readline libyaml gmp"

    run_command "installing rubyfmt formatter" "brew install rubyfmt"
else
    run_command "installing dependencies" \
        "sudo apt-get install -y autoconf bison patch build-essential rustc libssl-dev libyaml-dev \\
            libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev"
fi

# Install and configure rbenv
if [[ ! -d ~/.rbenv ]]; then
    run_command "cloning rbenv to -> $HOME/.rbenv" \
        "git clone https://github.com/rbenv/rbenv.git ~/.rbenv"
fi

if [[ ! -d ~/.rbenv/plugins/ruby-build ]]; then
    run_command "cloning ruby-build to -> $HOME/.rbenv/plugins/ruby-build" \
        "git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build"
fi

# Setup Ruby version manager
eval "$("$HOME"/.rbenv/bin/rbenv init - zsh)"
if [[ $OSTYPE == "darwin"* ]]; then
    RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
    export RUBY_CONFIGURE_OPTS
fi

# Only install provided Ruby version if it isn't already available
if ! rbenv versions | grep "3.2.2" > /dev/null 2>&1; then
    # From https://stackoverflow.com/a/74821955
    run_command "installing ruby 3.2.2" "RUBY_CFLAGS=\"-w\" rbenv install 3.2.2"
fi

run_command "setting global ruby version to 3.2.2" "rbenv global 3.2.2"

# Need to install this version of nokogiri to be able to install solargraph LSP
run_command "installing nokogiri" "gem install nokogiri -v 1.13.10"
run_command "installing solargraph lsp" "gem install solargraph"
