#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing tmux" "installed tmux" \
        "brew install tmux"

    run_command "installing kitty" "installed kitty" \
        "brew install --cask kitty"
else
    run_command "installing tmux" "installed tmux" \
        "sudo apt-get install -y tmux"

    run_command "installing kitty" "installed kitty" \
        "sudo apt-get install -y kitty"
fi

info "linking OneDark.conf colour theme for kitty"
link_file "$SCRIPT_DIR/OneDark.conf" "$HOME/.config/kitty/OneDark.conf"

info "linking kitty.conf"
link_file "$SCRIPT_DIR/kitty.conf" "$HOME/.config/kitty/kitty.conf"

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    run_command "cloning tpm to -> ~/.tmux/plugins/tpm" "cloned tpm to -> ~/.tmux/plugins/tpm" \
        "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
fi

# Install TPM plugins
run_command "installing tpm plugins" "installed tpm plugins" \
    "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"

