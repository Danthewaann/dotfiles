#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing tmux" "installed tmux" \
        "brew install tmux"

    run_command "installing iterm2" "installed iterm2" \
        "brew install --cask iterm2"

    if [[ ! -f $SCRIPT_DIR/onedark.itermcolors ]]; then
        run_command "downloading one dark MACOS iterm2 theme" "downloaded one dark MACOS iterm2 theme" \
            "curl -L -o $SCRIPT_DIR/onedark.itermcolors https://raw.githubusercontent.com/one-dark/iterm-one-dark-theme/main/One%20Dark.itermcolors"
    fi
else
    run_command "installing tmux" "installed tmux" \
        "sudo apt-get install -y tmux"

    # From https://github.com/denysdovhan/one-gnome-terminal
    if [[ ! -f $SCRIPT_DIR/.gnome_installed_one_dark_theme ]]; then
        run_command "installing one dark GNOME terminal theme" "installed one dark GNOME terminal theme" \
            "curl -fsSL https://raw.githubusercontent.com/denysdovhan/gnome-terminal-one/master/one-dark.sh | bash"
        touch "$SCRIPT_DIR/.gnome_installed_one_dark_theme"
    fi
fi

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    run_command "cloning tpm to -> ~/.tmux/plugins/tpm" "cloned tpm to -> ~/.tmux/plugins/tpm" \
        "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
fi

# Install TPM plugins
run_command "installing tpm plugins" "installed tpm plugins" \
    "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"

