#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR"/../common

if [[ $OSTYPE == "darwin"* ]]; then
    run_command "setting up initial key-repeat" \
        "defaults write -g InitialKeyRepeat -int 10"

    run_command "setting up key-repeat" \
        "defaults write -g KeyRepeat -int 1"

    # Need this to enable key-repeat for firenvim
    run_command "disabling press and hold" \
        "defaults write -g ApplePressAndHoldEnabled -bool false"

    run_command "installing watch" \
        "brew install watch"

    run_command "installing jq" \
        "brew install jq"

    run_command "installing gsed" \
        "brew install gnu-sed"

    run_command "installing wget" \
        "brew install wget"

    run_command "installing tree" \
        "brew install tree"

    run_command "installing asciinema" \
        "brew install asciinema"

    run_command "installing findutils" \
        "brew install findutils"

    run_command "installing md5sum" \
        "brew install md5sha1sum"

    run_command "installing htop" \
        "brew install htop"

    run_command "installing fzf" \
        "brew install fzf"

    run_command "installing fd" \
        "brew install fd"

    run_command "installing shellcheck" \
        "brew install shellcheck"

    run_command "installing bat" \
        "brew install bat"

    run_command "installing ripgrep" \
        "brew install ripgrep"

    run_command "installing watchman" \
        "brew install watchman"

    run_command "installing rename" \
        "brew install rename"
else
    run_command "installing fzf" \
        "sudo apt-get install -y fzf"

    run_command "installing fd" \
        "sudo apt-get install -y fd-find"

    if [[ ! -L "$HOME/.local/bin/fd" ]]; then
        run_command "linking fd-find to fd" \
            "ln -s $(which fdfind) $HOME/.local/bin/fd"
    fi

    run_command "installing shellcheck" \
        "sudo apt-get install -y shellcheck"

    if [[ ! -f "$SCRIPT_DIR/bat.deb" ]]; then
        run_command "downloading bat" \
            "wget -O $SCRIPT_DIR/bat.deb https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-musl_0.22.1_amd64.deb"
    fi

    run_command "installing bat" \
        "sudo dpkg -i $SCRIPT_DIR/bat.deb"

    run_command "installing openssh-server" \
        "sudo apt-get install -y openssh-server"

    run_command "installing jq" \
        "sudo apt-get install -y jq"

    run_command "installing htop" \
        "sudo apt-get install -y htop"

    run_command "installing tree" \
        "sudo apt-get install -y tree"

    run_command "installing ripgrep" \
        "sudo apt-get install -y ripgrep"

    run_command "installing watchman" \
        "sudo apt-get install -y watchman"

    run_command "installing rename" \
        "sudo apt-get install -y rename"

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
fi

