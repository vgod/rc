# Path to your oh-my-zsh configuration.
ZSH=$HOME/.rc/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="blinks-venv"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx python screen ssh-agent autojump coffee git-flow git-remote-branch vi-mode virtualenvwrapper)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:$HOME/bin:/usr/local/bin:/usr/local/sbin:$HOME/.rvm/bin

# vi key binding
bindkey '^R' history-incremental-search-backward
export EDITOR=vim

source $ZSH/plugins/history-substring-search/history-substring-search.zsh


# HISTORY
# number of lines kept in history
export HISTSIZE=10000
# # number of lines saved in the history after logout
export SAVEHIST=10000
# # location of history
export HISTFILE=~/.zhistory
# # append command to history file once executed
setopt APPEND_HISTORY

# virtualenv and virtualenvwrapper
export VIRTUAL_ENV_DISABLE_PROMPT='1'
export WORKON_HOME=~/Envs

# alias
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

_VBoxManage() {
reply=(`VBoxManage 2>&1|awk '/VBoxManage [a-z]/ {print $2}'|uniq`)
}
compctl -K _VBoxManage VBoxManage
