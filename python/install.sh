#!/usr/bin/env bash

set -e

# Install Python build dependencies
if [[ $OSTYPE == "darwin"* ]]; then
    xcode-select --install
    brew install openssl readline sqlite3 xz zlib tcl-tk
else
    sudo apt-get install -qq -y build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
fi

# Install and configure pyenv
if [[ ! -d ~/.pyenv ]]; then
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    cd ~/.pyenv && src/configure && make -C src
fi

# Install and set global Python version using pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pyenv install -s "$PYTHON_VERSION"
pyenv global "$PYTHON_VERSION"

# Install poetry package manager
curl -sSL https://install.python-poetry.org | python3 -

