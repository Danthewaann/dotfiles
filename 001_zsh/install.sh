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

    run_command "installing watch" \
        "brew install watch"

    run_command "installing jq" \
        "brew install jq"
else
    run_command "setting up key-repeat" \
        "gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 10" \
        "gsettings set org.gnome.desktop.peripherals.keyboard delay 150"
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

info "linking custom scripts in bin"
for f in "$SCRIPT_DIR"/bin/*; do
    link_file "$f" "$HOME/.local/bin/$(basename "$f")"
done

info "linking zsh functions"
link_file "$SCRIPT_DIR/functions" "$HOME/.zsh_functions"

