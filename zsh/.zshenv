# Use the default nvm alias
if [[ -e ~/.nvm/alias/default ]]; then
    export PATH="$HOME/.nvm/versions/node/v$(< ~/.nvm/alias/default)/bin${PATH+:$PATH}"
fi

# Allow python and ruby to be findable
export PATH="$HOME/.pyenv/shims:$HOME/.rbenv/shims${PATH+:$PATH}"

# Allow cargo tools to be findable
source "$HOME/.cargo/env"

# Skip the global compinit that Ubuntu performs in favour of the one we perfom in `.zshrc`
#
# From: https://gist.github.com/ctechols/ca1035271ad134841284?permalink_comment_id=3664231#gistcomment-3664231
skip_global_compinit=1
