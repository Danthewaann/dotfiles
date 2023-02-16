#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

# Install Python build dependencies
if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing dependencies" "installed dependencies" \
        "xcode-select --install && brew install openssl readline sqlite3 xz zlib tcl-tk"
else
    run_command "installing dependencies" "installed dependencies" \
        "sudo apt-get install -y python3 python3-setuptools build-essential libssl-dev zlib1g-dev \\
            libbz2-dev libreadline-dev libsqlite3-dev curl \\
            libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \\
            libpq-dev"
fi

# Install and configure pyenv
if [[ ! -d ~/.pyenv ]]; then
    run_command "cloning pyenv to -> $HOME/.pyenv" "cloned pyenv to -> $HOME/.pyenv" \
        "git clone https://github.com/pyenv/pyenv.git ~/.pyenv"

    run_command "configuring pyenv" "configuring pyenv" \
        "cd ~/.pyenv && src/configure && make -C src && cd -"
fi

# Install and set global Python version using pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Only install provided Python version if it isn't already available
if ! pyenv global | grep "$MY_PYTHON_VERSION" > /dev/null 2>&1; then
    run_command "installing python $MY_PYTHON_VERSION" "installed python $MY_PYTHON_VERSION" \
        "pyenv install -s $MY_PYTHON_VERSION"

    run_command "setting global python version to $MY_PYTHON_VERSION" "setted global python version to $MY_PYTHON_VERSION" \
        "pyenv global $MY_PYTHON_VERSION"

    # Need to make sure flake8 is installed for coc-pyright to work correctly
    # for some reason. I also added other packages here for general use so 
    # my vim setup works when editing standalone files outside of a project.
    run_command "installing python linters and formatters" "installed python linters and formatters"\
        "pip install flake8 black isort mypy"

    run_command "installing ipython" "installed ipython"\
        "pip install ipython"

    # Make sure executables are available
    run_command "rehashing pyenv" "rehashed pyenv" \
        "pyenv rehash"
fi

if ! poetry -V | grep "$MY_POETRY_VERSION" > /dev/null 2>&1; then
    # Install poetry package manager
    run_command "installing poetry version $MY_POETRY_VERSION" "installed poetry version $MY_POETRY_VERSION" \
        "curl -sSL https://install.python-poetry.org | python3 - --uninstall" \
        "curl -sSL https://install.python-poetry.org | POETRY_VERSION=$MY_POETRY_VERSION python3 -"
fi

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing firefox geckodriver" "installed firefox geckodriver" \
        "brew install geckodriver"
else
    if [[ ! -f "$SCRIPT_DIR/geckodriver.tar.gz" ]]; then
        run_command "downloading firefox geckodriver" "downloaded firefox geckodriver" \
            "wget -O $SCRIPT_DIR/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v0.32.2/geckodriver-v0.32.2-linux64.tar.gz"

        run_command "unpacking $SCRIPT_DIR/geckodriver.tar.gz to -> /usr/local/bin/geckodriver" \
                    "unpacked $SCRIPT_DIR/geckodriver.tar.gz to -> /usr/local/bin/geckodriver" \
                    "sudo rm -rf /usr/local/bin/geckodriver && \\
                    sudo tar -C /usr/local/bin -xzf $SCRIPT_DIR/geckodriver.tar.gz"
    fi
fi

run_command "creating global $HOME/.config/black file" "created global $HOME/.config/black file" \
    "echo \"[tool.black]\" > $HOME/.config/black" \
    "echo \"line-length = 79\" >> $HOME/.config/black" \
