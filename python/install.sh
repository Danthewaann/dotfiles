#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR"/../common

# Install Python build dependencies
if [[ $OSTYPE == "darwin"* ]]; then
    xcode-select --install
    brew install openssl readline sqlite3 xz zlib tcl-tk
else
    sudo apt-get install -y python3 python3-setuptools build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
    libpq-dev
fi

# Install and configure pyenv
if [[ ! -d ~/.pyenv ]]; then
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    cd ~/.pyenv && src/configure && make -C src
    cd -
fi

# Install and set global Python version using pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Only install provided Python version if it isn't already available
if ! pyenv global | grep "$PYTHON_VERSION"; then
    pyenv install -s "$PYTHON_VERSION"
    pyenv global "$PYTHON_VERSION"

    # Need to make sure flake8 is installed for coc-pyright to work correctly
    # for some reason. I also added other packages here for general use so 
    # my vim setup works when editing standalone files outside of a project.
    pip install flake8 black isort mypy

    # Make sure executables are available
    pyenv rehash
fi

if ! poetry -V | grep "$POETRY_VERSION"; then
    # Install poetry package manager
    curl -sSL https://install.python-poetry.org | python3 - --uninstall
    curl -sSL https://install.python-poetry.org | POETRY_VERSION="$POETRY_VERSION" python3 -
fi

