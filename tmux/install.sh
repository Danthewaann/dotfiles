#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "installing tmux" \
        "brew install tmux"

    run_command "installing kitty" \
        "brew install --cask kitty"
else
    if [[ ! -f "$SCRIPT_DIR/tmux-$TMUX_VERSION.tar.gz" ]]; then
        run_command "downloading tmux" \
            "wget -O $SCRIPT_DIR/tmux-$TMUX_VERSION.tar.gz \\
            https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/tmux-$TMUX_VERSION.tar.gz"
    fi

    run_command "installing libevent tmux dependency" \
        "sudo apt-get install -y libevent-dev ncurses-dev build-essential bison pkg-config"

    run_command "unpacking tmux" \
        "tar -C $SCRIPT_DIR -zxf $SCRIPT_DIR/tmux-$TMUX_VERSION.tar.gz"

    cd "$SCRIPT_DIR/tmux-$TMUX_VERSION"
    run_command "compiling and installing tmux to /usr/local/bin" \
        "./configure && make && sudo make install"
    cd - > /dev/null

    run_command "installing kitty" \
        "sudo apt-get install -y kitty"
fi

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    run_command "cloning tpm to -> ~/.tmux/plugins/tpm" \
        "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
fi

# Install TPM plugins
run_command "installing tpm plugins" \
    "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"

