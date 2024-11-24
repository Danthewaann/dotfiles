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

if [[ ! -d $ZSH_CUSTOM/plugins/fast-syntax-highlighting ]]; then
    run_command "installing fast-syntax-highlighting" \
        "git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting"
fi

if [[ ! -d $ZSH_CUSTOM/plugins/zsh-git-prompt ]]; then
    run_command "installing zsh-git-prompt" \
        "git clone https://github.com/dcrblack/zsh-git-prompt $ZSH_CUSTOM/plugins/zsh-git-prompt"
fi

if [[ ! -d $ZSH_CUSTOM/plugins/zsh-vi-mode ]]; then
    run_command "installing zsh-vi-mode" \
        "git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode"
fi
