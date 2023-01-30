#!/usr/bin/env bash

set -e

# Install Vundle vim plugin manager
if [[ ! -d ~/.vim/bundle/Vundle.vim ]]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    # Workaround from https://github.com/neoclide/coc.nvim/issues/3258#issuecomment-1056660012
    cd ~/.vim/bundle/coc.nvim || exit
    git checkout release
fi

# Install plugins
vim --not-a-term +PluginInstall +qall
vim --not-a-term +VimspectorInstall debugpy +qall

# Install vim plugin dependencies
if [[ $OSTYPE == "darwin"* ]]; then
    brew install the_silver_searcher fzf shellcheck
else
    sudo apt-get install -y silversearcher-ag fzf shellcheck
fi

