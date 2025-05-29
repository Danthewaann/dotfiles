# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Disable marking untracked files under VCS as dirty. This makes repository
# status check for large repositories much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git-prompt zsh-autosuggestions virtualenv zsh-lazyload)

# From https://carlosbecker.com/posts/speeding-up-zsh/ and https://gist.github.com/ctechols/ca1035271ad134841284
# and https://htr3n.github.io/2018/07/faster-zsh/
# On slow systems, checking the cached .zcompdump file to see if it must be
# regenerated adds a noticeable delay to zsh startup.  This little hack restricts
# it to once a day.  It should be pasted into your own completion file.
#
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.
fpath=($fpath $HOME/.zsh_completions)
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit;
else
    compinit -C;
fi

source $ZSH/oh-my-zsh.sh

# Setup root variables
export NVM_ROOT="$HOME/.nvm"
export PYENV_ROOT="$HOME/.pyenv"
export RBENV_ROOT="$HOME/.rbenv"

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Add XDG_CONFIG_HOME to broadbast where my config files should live
export XDG_CONFIG_HOME="$HOME/.config"

# Use nvim as the manpager
export MANPAGER='nvim +Man!'

# Add pyenv bin, bob, local scripts and golang to path
export PATH="$PYENV_ROOT/bin:$HOME/.local/share/bob/nvim-bin:$HOME/.local/bin:/usr/local/go/bin:$HOME/go/bin${PATH+:$PATH}"

# Set theme for bat
export BAT_THEME="TwoDark"

# Setup fzf to use ripgrep for search
export FZF_DEFAULT_COMMAND='rg --files --hidden --color=never --ignore-file ~/.gitignore --glob ""'
export FZF_DEFAULT_OPTS='--color=border:#31353f,bg+:#1a1d21,bg:#1a1d21,spinner:#c678dd,hl:#5c6370,fg:#abb2bf,header:#5c6370,info:#c678dd,pointer:#c678dd,marker:#c678dd,fg+:#abb2bf,preview-bg:#282c34,prompt:#c678dd,hl+:#c678dd'

# Configure colours for `ls` on mac OS
# See `man ls` for more details about colours
export LSCOLORS="Exfxcxdxfxegedabagacad"

# Configure binds for `gh notify`
export GH_NOTIFY_FZF_OPTS="--bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"
export GH_NOTIFY_VIEW_DIFF_KEY="ctrl-f"
export GH_NOTIFY_VIEW_PATCH_KEY=" "

# Some aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias gc='git-clone-bare'
alias ga='gitw-add'
alias gu='gitw-update'
alias gr='gitw-rebase'
alias prc='git-pr-create'
alias pre='git-pr-edit'
alias pry='git-pr-copy'
alias prr='git-pr-review'
alias prv='gh pr view --web'
alias rv='gh repo view --web'
alias bv='gh repo view --web --branch $(git branch --show-current)'
alias bc='git-branch-copy'
alias tc='ticket-copy'
alias to='ticket-open'
alias dps='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.RunningFor}}\t{{.State}}\t{{.Size}}"'

# Some convenience functions
function b64e () { echo -n "$1" | base64 }
function b64d () { echo -n "$1" | base64 -D; echo }
function uuid4 () { python -c "import uuid; print(str(uuid.uuid4()))" }

# Git apply patch from clipboard
function gap () { patch="$(pbpaste)\n"; echo "$patch" | git apply - }
function checkport () { sudo lsof -i tcp:"$1" }
function tmux {
    # Expose current dir of where tmux was ran to tmux and
    # if no args are provided, create a session that is named after
    # the current directory where tmux was launched from
    if [ "$#" -eq 0 ]; then
        TMUX_CURRENT_DIR="${PWD}" command tmux new-session -s "$(basename "${PWD}")"
    else
        TMUX_CURRENT_DIR="${PWD}" command tmux "$@"
    fi
}

# Use <Alt-b> and <Alt-f> to jump a word at a time
# Use `cat` to see what keycodes are sent
bindkey "^[b" backward-word
bindkey "^[f" forward-word

# Cycle through command history (including suggested commands)
bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search

# Linux only setup
if [[ $OSTYPE == "darwin"* ]]; then
    # Add brew to path
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Allow gnu `find` to be available
    export PATH="$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"

    # Lazyload commands to improve startup time
    lazyload nvm -- '[ -s "$NVM_ROOT/nvm.sh" ] && \. "$NVM_ROOT/nvm.sh"  # This loads nvm
        [ -s "$NVM_ROOT/bash_completion" ] && \. "$NVM_ROOT/bash_completion"  # This loads nvm bash_completion'
    lazyload pyenv -- 'eval "$($PYENV_ROOT/bin/pyenv init --no-push-path - zsh)"'
    lazyload rbenv -- 'if [[ -d "$RBENV_ROOT" ]]; then eval "$($RBENV_ROOT/bin/rbenv init - zsh)"; fi'

    alias sed="gsed"
else
    # Setup Python version manager
    eval "$("$PYENV_ROOT"/bin/pyenv init - zsh)"

    # Setup node version manager
    [ -s "$NVM_ROOT/nvm.sh" ] && \. "$NVM_ROOT/nvm.sh"  # This loads nvm
    [ -s "$NVM_ROOT/bash_completion" ] && \. "$NVM_ROOT/bash_completion"  # This loads nvm bash_completion

    # Use the default nvm alias
    if [[ -e ~/.nvm/alias/default ]]; then
        PATH="$PATH:$HOME/.nvm/versions/node/v$(< ~/.nvm/alias/default)/bin"
    fi

    # Setup Ruby version manager
    if [[ -d "$RBENV_ROOT" ]]; then
        eval "$("$HOME"/.rbenv/bin/rbenv init - zsh)"
    fi

    alias pbcopy="xclip"
fi

# Custom prompt prefix based on the amuse theme
# https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/amuse.zsh-theme
# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}\uE0A0%{${reset_color}%} ("
ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg_bold[red]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"

# From: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git-prompt/git-prompt.plugin.zsh
function git_super_status() {
    precmd_update_git_vars
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
        # If we are in a git worktree, don't output the branch name
        if [[ $(git config --get core.bare | trim) == "true" ]]; then
            GIT_BRANCH=
        fi
        STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH$GIT_UPSTREAM%{${reset_color}%}"
        if [ "$GIT_BEHIND" -ne "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND$GIT_BEHIND%{${reset_color}%}"
        fi
        if [ "$GIT_AHEAD" -ne "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD$GIT_AHEAD%{${reset_color}%}"
        fi
        if [ "$GIT_BEHIND" -ne "0" ] || [ "$GIT_AHEAD" -ne "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
        fi
        if [ "$GIT_STAGED" -ne "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED%{${reset_color}%}"
        fi
        if [ "$GIT_CONFLICTS" -ne "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS%{${reset_color}%}"
        fi
        if [ "$GIT_CHANGED" -ne "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED%{${reset_color}%}"
        fi
        if [ "$GIT_DELETED" -ne "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_DELETED$GIT_DELETED%{${reset_color}%}"
        fi
        if [ "$GIT_UNTRACKED" -ne "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED$GIT_UNTRACKED%{${reset_color}%}"
        fi
        if [ "$GIT_STASHED" -ne "0" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STASHED$GIT_STASHED%{${reset_color}%}"
        fi
        if [ "$GIT_CLEAN" -eq "1" ]; then
            STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
        fi
        STATUS="$STATUS%{${reset_color}%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
        echo "$STATUS"
    fi
}

[ -n "$SSH" ] && BASE_PROMPT=$'%{$fg[magenta]%}%n@%M:%{$fg_bold[green]%}%~%{$reset_color%}$(git_super_status)\n$(virtualenv_prompt_info)'
[ -z "$SSH" ] && BASE_PROMPT=$'%{$fg_bold[green]%}%~%{$reset_color%}$(git_super_status)\n$(virtualenv_prompt_info)'
PROMPT="$BASE_PROMPT$ "

# Disable the right-hand side prompt
RPROMPT=""

VIRTUAL_ENV_DISABLE_PROMPT=0
ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="(%{$fg[green]%}🐍"
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="%{$reset_color%}) "
ZSH_THEME_VIRTUALENV_PREFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX
ZSH_THEME_VIRTUALENV_SUFFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX
