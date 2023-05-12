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
# DISABLE_UNTRACKED_FILES_DIRTY="true"

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
plugins=(git zsh-autosuggestions virtualenv zsh-vi-mode fast-syntax-highlighting)

# Use `fd` to enter normal mode in zsh
ZVM_VI_ESCAPE_BINDKEY=fd

# Disable the cursor style feature
ZVM_CURSOR_STYLE_ENABLED=false

# The plugin will auto execute this zvm_after_select_vi_mode function
function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)
        PROMPT="$BASE_PROMPT%{$fg_bold[green]%}N%{$reset_color%} $ "
    ;;
    $ZVM_MODE_INSERT)
        PROMPT="$BASE_PROMPT$ "
    ;;
    $ZVM_MODE_VISUAL)
        PROMPT="$BASE_PROMPT%{$fg_bold[green]%}V%{$reset_color%} $ "
    ;;
    $ZVM_MODE_VISUAL_LINE)
        PROMPT="$BASE_PROMPT%{$fg_bold[green]%}V%{$reset_color%} $ "
    ;;
    $ZVM_MODE_REPLACE)
        PROMPT="$BASE_PROMPT%{$fg_bold[green]%}R%{$reset_color%} $ "
    ;;
  esac
}

zvm_after_init() {
    # Override <C-P> and <C-N> to cycle through command history (including suggested commands)
    zvm_bindkey viins '^P' up-line-or-search
    zvm_bindkey viins '^N' down-line-or-search
}

source $ZSH/oh-my-zsh.sh

# From https://carlosbecker.com/posts/speeding-up-zsh/ and https://gist.github.com/ctechols/ca1035271ad134841284
# and https://htr3n.github.io/2018/07/faster-zsh/
# On slow systems, checking the cached .zcompdump file to see if it must be 
# regenerated adds a noticable delay to zsh startup.  This little hack restricts 
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
export EDITOR='vim'

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

# Global variables used in my installers and dotfiles
export MY_PYTHON_VERSION=3.11.0
export MY_POETRY_VERSION=1.3.2
export MY_NODE_VERSION=19.0.0
export MY_GO_VERSION=1.19.5

# Add brew to path
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

# Add local scripts, rust, golang, ruby and python stuff to path
export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin::/usr/local/go/bin:$HOME/go/bin:$HOME/.pyenv/shims:$HOME/.rbenv/shims"

# Set theme for bat
export BAT_THEME="TwoDark"

# Setup fzf to use ripgrep for search
export FZF_DEFAULT_COMMAND='rg --files --hidden --color=never --ignore-file ~/.gitignore --glob ""'

# Some aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Custom prompt based on the amuse theme
# https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/amuse.zsh-theme
# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg_bold[red]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"

BASE_PROMPT=$'\n%{$fg_bold[green]%}%~%{$reset_color%}\n$(virtualenv_prompt_info)'
PROMPT="$BASE_PROMPT$ "

VIRTUAL_ENV_DISABLE_PROMPT=0
ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="(%{$fg[green]%}🐍"
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="%{$reset_color%}) "
ZSH_THEME_VIRTUALENV_PREFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX
ZSH_THEME_VIRTUALENV_SUFFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX
