# If we are inside tmux we don't need to re-load the following variables
# since it has already been done when starting up the terminal
#
# From: https://stackoverflow.com/questions/13058578/how-to-prevent-tmux-from-filling-up-the-global-path-variable-with-duplicated-pat
#
# ~/.zshenv is sourced in all terminals and before ~/.zshrc
if [[ -z $TMUX ]]; then
    # Setup root variables
    export NVM_ROOT="$HOME/.nvm"
    export PYENV_ROOT="$HOME/.pyenv"
    export RBENV_ROOT="$HOME/.rbenv"

    # Preferred editor for local and remote sessions
    export EDITOR='nvim'

    # Set theme for bat
    export BAT_THEME="TwoDark"

    # Add XDG_CONFIG_HOME to broadbast where my config files should live
    export XDG_CONFIG_HOME="$HOME/.config"

    # Use nvim as the manpager
    export MANPAGER='nvim +Man!'

    # Add pyenv bin, bob, local scripts and golang to path
    export PATH="$PYENV_ROOT/bin:$HOME/.local/share/bob/nvim-bin:$HOME/.local/bin:/usr/local/go/bin:$HOME/go/bin${PATH+:$PATH}"

    # Use the default nvm alias
    if [[ -e ~/.nvm/alias/default ]]; then
        export PATH="$HOME/.nvm/versions/node/v$(< ~/.nvm/alias/default)/bin${PATH+:$PATH}"
    fi

    # Allow python and ruby to be findable
    export PATH="$HOME/.pyenv/shims:$HOME/.rbenv/shims${PATH+:$PATH}"

    # Allow cargo tools to be findable
    source "$HOME/.cargo/env"

    # Skip the global compinit that Ubuntu performs in favour of the one we perform in `.zshrc`
    #
    # From: https://gist.github.com/ctechols/ca1035271ad134841284?permalink_comment_id=3664231#gistcomment-3664231
    skip_global_compinit=1

    if [[ $OSTYPE == "darwin"* ]]; then
        # The following is from the output of `/opt/homebrew/bin/brew shellenv`
        export HOMEBREW_PREFIX="/opt/homebrew";
        export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
        export HOMEBREW_REPOSITORY="/opt/homebrew";
        fpath[1,0]="/opt/homebrew/share/zsh/site-functions";
        export FPATH;
        export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
        [ -z "${MANPATH-}" ] || { export MANPATH="${MANPATH%"${MANPATH##*[!:]}"}"; export MANPATH=":${MANPATH#"${MANPATH%%[!:]*}"}"; };
        export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    # Allow gnu `find` to be available
    export PATH="$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"
fi
