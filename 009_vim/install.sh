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

# Install vim plugin dependencies
if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing fzf" \
        "brew install fzf"

    run_command "installing shellcheck" \
        "brew install shellcheck"

    run_command "installing git-delta" \
        "brew install git-delta"

    run_command "installing bat" \
        "brew install bat"

    run_command "installing ripgrep" \
        "brew install ripgrep"
else
    run_command "installing fzf" \
        "sudo apt-get install -y fzf"

    run_command "installing shellcheck" \
        "sudo apt-get install -y shellcheck"

    if [[ ! -f "$SCRIPT_DIR/git-delta.deb" ]]; then
        run_command "downloading git-delta" \
            "wget -O $SCRIPT_DIR/git-delta.deb https://github.com/dandavison/delta/releases/download/0.15.1/git-delta_0.15.1_amd64.deb"
    fi

    run_command "installing git-delta" \
        "sudo dpkg -i $SCRIPT_DIR/git-delta.deb"

    if [[ ! -f "$SCRIPT_DIR/bat.deb" ]]; then
        run_command "downloading bat" \
            "wget -O $SCRIPT_DIR/bat.deb https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-musl_0.22.1_amd64.deb"
    fi

    run_command "installing bat" \
        "sudo dpkg -i $SCRIPT_DIR/bat.deb"

    run_command "installing ripgrep" \
        "sudo apt-get install -y ripgrep"
fi

# Install vim plugins
run_command "installing vim plugins" \
    "vim --not-a-term +PlugInstall\! +qall > /dev/null 2>&1"

run_command "creating $HOME/.coc-post directory" "mkdir -p $HOME/.coc-post"

