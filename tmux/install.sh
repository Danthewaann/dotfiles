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
        "curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n"

    # Add linux desktop integration with kitty
    #
    # From: https://sw.kovidgoyal.net/kitty/binary/#desktop-integration-on-linux
    #
    # Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
    # your system-wide PATH)
    ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
    # Place the kitty.desktop file somewhere it can be found by the OS
    cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    # If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
    cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
    # Update the paths to the kitty and its icon in the kitty desktop file(s)
    sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
    # Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
    echo 'kitty.desktop' > ~/.config/xdg-terminals.list
fi

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    run_command "cloning tpm to -> ~/.tmux/plugins/tpm" \
        "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
fi

# Install TPM plugins
run_command "installing tpm plugins" \
    "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"

