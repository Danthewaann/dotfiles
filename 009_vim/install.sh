#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

# Install vim 9
if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing vim" \
        "brew install macvim"
else
    run_command "installing vim" \
        "sudo add-apt-repository -y ppa:jonathonf/vim" \
        "sudo apt-get install -y vim"
fi

# Install vim-plug plugin manager
if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
    run_command "installing vim-plug plugin manager" \
        "curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \\
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
fi

# Install vim plugins
run_command "installing vim plugins" \
    "vim --not-a-term +PlugInstall\! +qall > /dev/null 2>&1"

run_command "creating $HOME/.coc-post directory" "mkdir -p $HOME/.coc-post"

