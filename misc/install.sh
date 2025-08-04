#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

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

    run_command "installing coreutils" \
        "brew install coreutils"

    run_command "installing htop" \
        "brew install htop"

    run_command "installing fzf" \
        "brew install fzf"

    run_command "installing fd" \
        "brew install fd"

    run_command "installing shellcheck" \
        "brew install shellcheck"

    run_command "installing git-delta" \
        "brew install git-delta"

    run_command "installing bat" \
        "brew install bat"

    run_command "installing ripgrep" \
        "brew install ripgrep"

    run_command "installing watchman" \
        "brew install watchman"

    run_command "installing rename" \
        "brew install rename"

    run_command "installing just" \
        "brew install just"
else
    run_command "installing fd" \
        "sudo apt-get install -y fd-find"

    if [[ ! -L "$HOME/.local/bin/fd" ]]; then
        run_command "linking fd-find to fd" \
            "ln -s $(which fdfind) $HOME/.local/bin/fd"
    fi

    run_command "installing shellcheck" \
        "sudo apt-get install -y shellcheck"

    if [[ ! -f "$SCRIPT_DIR/git-delta.deb" ]]; then
        run_command "downloading git-delta" \
            "wget -O $SCRIPT_DIR/git-delta.deb https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_amd64.deb"
    fi

    run_command "installing git-delta" \
        "sudo dpkg -i $SCRIPT_DIR/git-delta.deb"

    if [[ ! -f "$SCRIPT_DIR/bat.deb" ]]; then
        run_command "downloading bat" \
            "wget -O $SCRIPT_DIR/bat.deb https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-musl_0.22.1_amd64.deb"
    fi

    run_command "installing bat" \
        "sudo dpkg -i $SCRIPT_DIR/bat.deb"

    if [[ ! -d "$HOME/.keyd" ]]; then
        run_command "downloading keyd" \
            "git clone https://github.com/rvaiya/keyd $HOME/.keyd"
    fi

    cd "$HOME/.keyd"
    run_command "installing keyd" \
        "make && sudo make install"
    run_command "starting keyd" \
        "sudo systemctl enable --now keyd"
    run_command "reloading keyd" \
        "sudo keyd reload"
    cd - >/dev/null

    if [[ ! -f "$SCRIPT_DIR/keyring.deb" ]]; then
        # From: https://i3wm.org/docs/repositories.html
        run_command "downloading i3 keyring" \
            "/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2025.03.09_all.deb $SCRIPT_DIR/keyring.deb SHA256:2c2601e6053d5c68c2c60bcd088fa9797acec5f285151d46de9c830aaba6173c"
        run_command "installing i3 keyring" \
            "sudo apt-get install -y $SCRIPT_DIR/keyring.deb"
        run_command "adding i3 keyring to -> /etc/apt/sources.list.d/sur5r-i3.list" \
            "echo 'deb [signed-by=/usr/share/keyrings/sur5r-keyring.gpg] http://debian.sur5r.net/i3/ $(grep '^VERSION_CODENAME=' /etc/os-release | cut -f2 -d=) universe' | sudo tee /etc/apt/sources.list.d/sur5r-i3.list"
        run_command "updating apt" \
            "sudo apt-get update"
    fi

    run_command "installing i3" \
        "sudo apt-get install -y i3"

    run_command "installing rofi" \
        "sudo apt-get install -y rofi"

    if [[ ! -d "$HOME/rofi-collection" ]]; then
        run_command "downloading rofi-collection" \
            "git clone https://github.com/Murzchnvok/rofi-collection $HOME/rofi-collection"
        run_command "installing rofi onedark theme" \
            "mkdir -p $HOME/.local/share/rofi/themes && cp $HOME/rofi-collection/tokyonight/tokyonight.rasi $HOME/.local/share/rofi/themes"
    fi

    run_command "installing polybar" \
        "sudo apt-get install -y polybar"

    run_command "installing imagemagick" \
        "sudo apt-get install -y imagemagick"

    if [[ ! -d "$HOME/i3lock-color" ]]; then
        run_command "installing i3lock-color dependencies" \
            "sudo apt-get install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libgif-dev"
        run_command "downloading i3lock-color" \
            "git clone https://github.com/Raymo111/i3lock-color.git $HOME/i3lock-color"
        run_command "installing i3lock-color" \
            "cd $HOME/i3lock-color && ./install-i3lock-color.sh"
    fi

    run_command "installing xautolock" \
        "sudo apt-get install -y xautolock"

    run_command "installing brightnessctl" \
        "sudo apt-get install -y brightnessctl"

    run_command "chmoding brightnessctl" \
        "sudo chmod +s /usr/bin/brightnessctl"

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

    run_command "removing apport in ubuntu" \
        "sudo apt purge apport"

    if ! inside_wsl; then
        run_command "installing xclip" \
            "sudo apt-get install -y xclip"

        run_command "setting up key-repeat in gnome" \
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
