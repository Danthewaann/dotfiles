# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="amuse"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git git-prompt zsh-autosuggestions virtualenv)

source $ZSH/oh-my-zsh.sh

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
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit;
else
    compinit -C;
fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Autoload functions
fpath=($fpath $HOME/.zsh_functions)
autoload -Uz vim
autoload -Uz tmux
autoload -Uz nvm
autoload -Uz pyenv
autoload -Uz rbenv

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
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/opt/findutils/libexec/gnubin${PATH+:$PATH}";
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
    fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)

    alias sed="gsed"
else
    # Setup Python version manager
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$("$PYENV_ROOT"/bin/pyenv init -)"

    alias pbcopy="xclip"
fi

# Setup node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Use the default nvm alias
if [[ -e ~/.nvm/alias/default ]]; then
    PATH="$PATH:$HOME/.nvm/versions/node/$(< ~/.nvm/alias/default)/bin"
fi

# Setup Ruby version manager
if [[ -d "$HOME"/.rbenv ]]; then
    eval "$("$HOME"/.rbenv/bin/rbenv init - zsh)"
fi

# Add XDG_CONFIG_HOME to broadbast where my config files should live
export XDG_CONFIG_HOME="$HOME/.config"

# Add local scripts, rust, bob, golang, ruby and python stuff to path
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH:$HOME/.local/bin:$HOME/.cargo/bin:/usr/local/go/bin:$HOME/go/bin:$HOME/.pyenv/shims:$HOME/.rbenv/shims"

# Set theme for bat
export BAT_THEME="TwoDark"

# Setup fzf to use ripgrep for search
export FZF_DEFAULT_COMMAND='rg --files --hidden --color=never --ignore-file ~/.gitignore --glob ""'
export FZF_DEFAULT_OPTS='--color=border:#31353f,bg+:#1a1d21,bg:#1a1d21,spinner:#c678dd,hl:#5c6370,fg:#abb2bf,header:#5c6370,info:#c678dd,pointer:#c678dd,marker:#c678dd,fg+:#abb2bf,preview-bg:#282c34,prompt:#c678dd,hl+:#c678dd'

# Use nvim as the manpager
export MANPAGER='nvim +Man!'

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
alias prr='git-pr-review'
alias prv='gh pr view --web'
alias rv='gh repo view --web'
alias dps='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.RunningFor}}\t{{.State}}\t{{.Size}}"'

# Some convenience functions
function b64encode () {
    python -c "import base64; print(base64.b64encode('$1'.encode()).decode())"
}
function b64decode () {
    python -c "import base64; print(base64.b64decode('$1').decode())"
}
function uuid4 () {
    python -c "import uuid; print(str(uuid.uuid4()))"
}

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
        if [[ -f $PWD/.git ]]; then
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

# Add git branch completion to custom gitw-add script
_git 2>/dev/null
compdef _git_show_branch gitw-add

if [[ -f $HOME/.zprofile ]]; then
    source $HOME/.zprofile
fi
