# Use the default nvm alias
if [[ -e ~/.nvm/alias/default ]]; then
    export PATH="$HOME/.nvm/versions/node/v$(< ~/.nvm/alias/default)/bin${PATH+:$PATH}"
fi

# Allow python and ruby to be findable
export PATH="$HOME/.pyenv/shims:$HOME/.rbenv/shims${PATH+:$PATH}"

# Allow cargo tools to be findable
source "$HOME/.cargo/env"
