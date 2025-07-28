# Uncomment the following line and the last line in this file to enable profiling
# zmodload zsh/zprof

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Disable marking untracked files under VCS as dirty. This makes repository
# status check for large repositories much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#
# Can find external plugins from: https://github.com/topics/zsh-plugins
plugins=(
    git-prompt
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-autopair
    zsh-lazyload
    zsh-fzf-history-search
    virtualenv
)

# Load oh-my-zsh
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

# Setup colorscheme for fzf
export FZF_DEFAULT_OPTS='--color=border:#31353f
                         --color=bg+:#1a1d21
                         --color=bg:#1a1d21
                         --color=spinner:#c678dd
                         --color=hl:#5c6370
                         --color=fg:#abb2bf
                         --color=header:#5c6370
                         --color=info:#c678dd
                         --color=pointer:#c678dd
                         --color=marker:#c678dd
                         --color=fg+:#abb2bf
                         --color=preview-bg:#1a1d21
                         --color=prompt:#c678dd
                         --color=hl+:#c678dd'

# Configure binds for `gh notify`
export GH_NOTIFY_FZF_OPTS="--bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"
export GH_NOTIFY_VIEW_DIFF_KEY="ctrl-f"
export GH_NOTIFY_VIEW_PATCH_KEY=" "

# Some aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias bc='git-branch-copy'
alias pc='git-pr-copy'
alias rc='git-repo-copy'
alias tc='ticket-copy'
alias gc='git-clone-bare'
alias ga='gitw-add'
alias gu='gitw-update'
alias gr='gitw-rebase'
alias prc='git-pr-create'
alias pre='git-pr-edit'
alias prr='git-pr-review'
alias bv='gh repo view --web --branch $(git branch --show-current)'
alias pv='gh pr view --web'
alias rv='gh repo view --web'
alias tv='ticket-open'
alias dps='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.RunningFor}}\t{{.State}}\t{{.Size}}"'
function d () { output=$(git diff); if [[ -n $output ]]; then git diff -w | nvim -R -; fi; }
function ds () { git --no-pager diff --shortstat | trim }
function db () { branch=${1:-origin/$(git-get-base-branch)}..HEAD; output=$(git diff $branch); if [[ -n $output ]]; then git diff $branch | nvim -R -; fi; }
function dbs () { git --no-pager diff --shortstat ${1:-origin/$(git-get-base-branch)}..HEAD | trim }
# see `git help log` for detailed help.
#   %h: abbreviated commit hash
#   %d: ref names, like the --decorate option of git-log(1)
#   %cn: committer name
#   %ce: committer email
#   %cr: committer date, relative
#   %ci: committer date, ISO 8601-like format
#   %an: author name
#   %ae: author email
#   %ar: author date, relative
#   %ai: author date, ISO 8601-like format
#   %s: subject
function gl () { git log --oneline --graph --decorate }
function gll () { git log --graph --pretty=format:"%C(auto)%h%d%Creset %C(cyan)(%cr)%Creset %s" }
function glll () { git log --graph --pretty=format:"%C(auto)%h%d%Creset %C(cyan)(%ci)%Creset %C(green)%cn <%ce>%Creset %s" }

# Some convenience functions
function b64e () { echo -n "$1" | base64 }
function b64d () { echo -n "$1" | base64 -D; echo }
function uuid4 () { python -c "import uuid; print(str(uuid.uuid4()))" }

# Git apply patch from clipboard
function gap () { patch="$(pbpaste)\n"; echo "$patch" | git apply - }
# Check what is running at a given port
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

# [C-p, C-n] Cycle through command history (including suggested commands)
bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search

if [[ $OSTYPE == "darwin"* ]]; then
    # mac OS only setup
    #
    # Add brew to path
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Allow gnu `find` to be available
    export PATH="$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"
    alias sed="gsed"
else
    # Linux only setup
    alias pbcopy="xclip"
fi

# Lazyloaded functions
lazyload nvm -- '[ -s "$NVM_ROOT/nvm.sh" ] && \. "$NVM_ROOT/nvm.sh"  # This loads nvm
    [ -s "$NVM_ROOT/bash_completion" ] && \. "$NVM_ROOT/bash_completion"  # This loads nvm bash_completion'
lazyload pyenv -- 'eval "$($PYENV_ROOT/bin/pyenv init --no-push-path - zsh)"'
lazyload rbenv -- 'if [[ -d "$RBENV_ROOT" ]]; then eval "$($RBENV_ROOT/bin/rbenv init - zsh)"; fi'

# Setup git info in prompt
#
# From: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git-prompt/git-prompt.plugin.zsh
function git_super_status() {
    precmd_update_git_vars
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
        # If we are in a git worktree, don't output the branch name
        #
        # The git that comes with homebrew is slow when running the following command
        # to properly determine if we are in a bare repository
        #
        #   $(git config --get core.bare | trim) == "true"
        #
        # The command that is used below is much faster and it works with my setup
        if [[ ! -d .git ]]; then
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

# Set the prompt
#
# Optionally include user and hostname in the prompt if we are in an SSH session
[ -n "$SSH" ] && PROMPT=$'%{$fg[magenta]%}%n@%M:%{$fg_bold[green]%}%~%{$reset_color%}$(git_super_status)\n$(virtualenv_prompt_info)$ ' || \
                 PROMPT=$'%{$fg_bold[green]%}%~%{$reset_color%}$(git_super_status)\n$(virtualenv_prompt_info)$ '

# Disable the right-hand side prompt
RPROMPT=""

# Setup virtual environment details if one is activated in the prompt
ZSH_THEME_VIRTUALENV_PREFIX="(%{$fg[green]%}🐍"
ZSH_THEME_VIRTUALENV_SUFFIX="%{$reset_color%}) "

# Add my custom zsh completions scripts to fpath so they are detected by compinit
fpath=($fpath $HOME/.zsh_completions)

# Load zsh completion scripts using compinit
#
# More info can be found from `man zshcompsys`
#
# On slow systems, checking the cached .zcompdump file to see if it must be
# regenerated adds a noticeable delay to zsh startup.  This little hack restricts
# it to once a day.  It should be pasted into your own completion file.
#
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.
#
# From:
#  - https://carlosbecker.com/posts/speeding-up-zsh/
#  - https://gist.github.com/ctechols/ca1035271ad134841284
#  - https://htr3n.github.io/2018/07/faster-zsh/
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit;
else
    compinit -C;
fi

# Set completion styles
#
# More info can be found from `man zshmodules`
#
# From:
#  - https://unix.stackexchange.com/a/214699
#  - http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
zstyle ':completion:*' menu yes select
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# Load my secrets rc file
if [ -f $HOME/.secretsrc ]; then source $HOME/.secretsrc; fi

# Uncomment the following line and the first line in this file to enable profiling
# zprof
