#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if ! inside_wsl; then
    run_command "installing xclip" \
        "sudo apt-get install -y xclip"

    run_command "setting up key-repeat" \
        "gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 10" \
        "gsettings set org.gnome.desktop.peripherals.keyboard delay 200"
else
    if [[ ! -f "$SCRIPT_DIR/win32yank.zip" ]]; then
        run_command "downloading win32yank" \
            "wget -O $SCRIPT_DIR/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip"

        run_command "unpacking $SCRIPT_DIR/win32yank.exe to -> /usr/local/bin" \
            "unzip -p $SCRIPT_DIR/win32yank.zip win32yank.exe > $SCRIPT_DIR/win32yank.exe" \
            "chmod +x $SCRIPT_DIR/win32yank.exe" \
            "sudo mv $SCRIPT_DIR/win32yank.exe /usr/local/bin/"
    fi
fi

if [[ -z $ZSH ]]; then
    run_command "installing on-my-zsh" \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [[ ! -d $ZSH_CUSTOM/plugins/zsh-autosuggestions ]]; then
    run_command "installing zsh-autosuggestions" \
        "git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [[ ! -d $ZSH_CUSTOM/plugins/zsh-syntax-highlighting ]]; then
    run_command "installing zsh-syntax-highlighting" \
        "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [[ ! -d $ZSH_CUSTOM/plugins/zsh-lazyload ]]; then
    run_command "installing zsh-lazyload" \
        "git clone https://github.com/qoomon/zsh-lazyload $ZSH_CUSTOM/plugins/zsh-lazyload"
fi

if [[ ! -d $ZSH_CUSTOM/plugins/zsh-fzf-history-search ]]; then
    run_command "installing zsh-fzf-history-search" \
        "git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM}/plugins/zsh-fzf-history-search"
fi

