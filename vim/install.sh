#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR"/../common

# Install vim 9
if [[ $OSTYPE == "darwin"* ]]; then
    brew install vim
else
    sudo add-apt-repository -y ppa:jonathonf/vim
    sudo apt-get install -y vim
fi

# Install Vundle vim plugin manager
if [[ ! -d ~/.vim/bundle/Vundle.vim ]]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# Install plugins
vim --not-a-term +PluginInstall +qall > /dev/null 2>&1

# Workaround from https://github.com/neoclide/coc.nvim/issues/3258#issuecomment-1056660012
cd ~/.vim/bundle/coc.nvim || exit
git checkout release
cd -

# vimspector debugpy post-install step
vim --not-a-term "+VimspectorInstall debugpy" +qall > /dev/null 2>&1

# markdown-preview post-install step
vim --not-a-term "+call mkdp#util#install()" +qall > /dev/null 2>&1

# Install binaries for vim-go plugin
vim --not-a-term "+GoInstallBinaries" +qall > /dev/null 2>&1

# Install vim plugin dependencies
if [[ $OSTYPE == "darwin"* ]]; then
    brew install the_silver_searcher fzf shellcheck
else
    sudo apt-get install -y silversearcher-ag fzf shellcheck
fi

