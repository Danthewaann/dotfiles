#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

# Install Python build dependencies
if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing dependencies" \
        "brew install python3 openssl readline sqlite3 xz zlib tcl-tk"
else
    run_command "installing dependencies" \
        "sudo apt-get install -y python3 python3-setuptools build-essential libssl-dev zlib1g-dev \\
            libbz2-dev libreadline-dev libsqlite3-dev curl \\
            libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \\
            libpq-dev"
fi

# Install and configure pyenv
if [[ ! -d ~/.pyenv ]]; then
    run_command "cloning pyenv to -> $HOME/.pyenv" \
        "git clone https://github.com/pyenv/pyenv.git ~/.pyenv"

    run_command "configuring pyenv" \
        "cd ~/.pyenv && src/configure && make -C src && cd -"
fi

# Setup Python version manager
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$("$PYENV_ROOT"/bin/pyenv init -)"

# Only install provided Python version if it isn't already available
if ! pyenv versions | grep "$PYTHON_VERSION" >/dev/null 2>&1; then
    run_command "installing python $PYTHON_VERSION" \
        "pyenv install -s $PYTHON_VERSION"
fi

run_command "setting global python version to $PYTHON_VERSION" \
    "pyenv global $PYTHON_VERSION"

# Need to make sure flake8 is installed for coc-pyright to work correctly
# for some reason. I also added other packages here for general use so
# my vim setup works when editing standalone files outside of a project.
run_command "installing pipx" \
    "pip install pipx"

run_command "installing python linters and formatters" \
    "pipx install flake8 black isort mypy ruff codespell"

run_command "installing ipython" \
    "pipx install ipython"

run_command "installing pre-commit" \
    "pipx install pre-commit"

run_command "installing pynvim" \
    "pip install pynvim"

run_command "installing twine" \
    "pipx install twine"

run_command "installing pyallel" \
    "pipx install pyallel"

run_command "installing uv" \
    "pipx install uv"

run_command "installing poetry" \
    "pipx install poetry==$POETRY_VERSION"

run_command "configuring poetry" \
    "poetry config virtualenvs.in-project true"

run_command "installing poetry zsh autocomplete" \
    "poetry completions zsh > ~/.zsh_completions/_poetry"

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing firefox geckodriver" \
        "brew install geckodriver"
else
    if [[ ! -f "$SCRIPT_DIR/geckodriver.tar.gz" ]]; then
        run_command "downloading firefox geckodriver" \
            "wget -O $SCRIPT_DIR/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v0.32.2/geckodriver-v0.32.2-linux64.tar.gz"

        run_command "unpacking $SCRIPT_DIR/geckodriver.tar.gz to -> /usr/local/bin/geckodriver" \
            "sudo rm -rf /usr/local/bin/geckodriver && \\
                    sudo tar -C /usr/local/bin -xzf $SCRIPT_DIR/geckodriver.tar.gz"
    fi
fi
