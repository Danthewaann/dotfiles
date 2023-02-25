#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

# Install vim 9
if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing vim" "installed vim" \
        "brew install vim"
else
    run_command "installing vim" "installed vim" \
        "sudo add-apt-repository -y ppa:jonathonf/vim" \
        "sudo apt-get install -y vim"
fi

# Install vim-plug plugin manager
if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
    run_command "installing vim-plug plugin manager" "installed vim-plug plugin manager" \
        "curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \\
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
fi

# Install plugins
run_command "installing plugins" "installed plugins" \
    "vim --not-a-term +PluginInstall +qall"

# Workaround from https://github.com/neoclide/coc.nvim/issues/3258#issuecomment-1056660012
run_command "configuring coc" "configured coc" \
    "cd $HOME/.vim/plugged/coc.nvim && git checkout release" \

# vimspector gadgets post-install step
run_command "configuring vimspector" "configured vimspector" \
    "vim --not-a-term \"+VimspectorInstall\" +qall"

# Install binaries for vim-go plugin
run_command "installing go binaries for vim-go" "installed go binaries for vim-go" \
    "vim --not-a-term \"+GoInstallBinaries\" +qall"

run_command "installing clangd" "installed clangd" \
    "vim --not-a-term \"+CocCommand clangd.install\" +qall"

# Install vim plugin dependencies
if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing vim plugin dependencies" "installed vim plugin dependencies" \
        "brew install fzf shellcheck"

    run_command "installing git-delta" "installed git-delta" \
        "brew install git-delta"

    run_command "installing bat" "installed bat" \
        "brew install bat"

    run_command "installing ripgrep" "installed ripgrep" \
        "brew install ripgrep"
else
    run_command "installing vim plugin dependencies" "installed vim plugin dependencies" \
        "sudo apt-get install -y fzf shellcheck"

    if [[ ! -f "$SCRIPT_DIR/git-delta.deb" ]]; then
        run_command "downloading git-delta" "downloaded git-delta"\
            "wget -O $SCRIPT_DIR/git-delta.deb https://github.com/dandavison/delta/releases/download/0.15.1/git-delta_0.15.1_amd64.deb"
    fi

    run_command "installing git-delta" "installed git-delta" \
        "sudo dpkg -i $SCRIPT_DIR/git-delta.deb"

    if [[ ! -f "$SCRIPT_DIR/bat.deb" ]]; then
        run_command "downloading bat" "downloaded bat"\
            "wget -O $SCRIPT_DIR/bat.deb https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-musl_0.22.1_amd64.deb"
    fi

    run_command "installing bat" "installed bat" \
        "sudo dpkg -i $SCRIPT_DIR/bat.deb"

    run_command "installing ripgrep" "installed ripgrep" \
        "sudo apt-get install -y ripgrep"
fi

info "linking files"
mkdir -p "$HOME/.config/clangd"
link_file "$SCRIPT_DIR/clangd_config.yaml" "$HOME/.config/clangd/config.yaml"

