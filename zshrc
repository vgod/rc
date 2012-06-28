export EDITOR=vim
export LANG=en_US.UTF-8

UNAME=`uname`
if [[ $UNAME == "Darwin" ]]
then
   export LSCOLORS="gxfxcxdxbxegedabagacad"
   alias ls='ls -Gv'
elif [[ $UNAME == "Linux" ]]
then
   alias ls='ls --color=auto'
fi

if [ -f `brew --prefix`/etc/autojump ]; then
     . `brew --prefix`/etc/autojump
fi

#if [ -f ~/.zsh_profile ]; then
#     . ~/.zsh_profile
#fi

# path alias, e.g. cd ~XXX
#hash -d WWW="/home/lighttpd/html"


# HISTORY
# number of lines kept in history
export HISTSIZE=10000
# # number of lines saved in the history after logout
export SAVEHIST=10000
# # location of history
export HISTFILE=~/.zhistory
# # append command to history file once executed
setopt INC_APPEND_HISTORY

# Disable core dumps
limit coredumpsize 0

# vi key binding
bindkey -v
bindkey '^R' history-incremental-search-backward
# mapping del
bindkey "\e[3~" delete-char

setopt AUTO_PUSHD

WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

# auto-completion
setopt COMPLETE_ALIASES
setopt AUTO_LIST
setopt AUTO_MENU
#setopt MENU_COMPLETE
setopt MULTIBYTE

autoload -U compinit
compinit

# Completion caching
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path .zcache
#zstyle ':completion:*:cd:*' ignore-parents parent pwd

#Completion Options
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

# Path Expansion
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

#zstyle ':completion:*:*:*:default' menu yes select #interactive
zstyle ':completion:*:*:default' force-list always

# require /etc/DIR_COLORS to display colors in the completion list
[ -f /etc/DIR_COLORS ] && eval $(gdircolors -b /etc/DIR_COLORS)
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

bindkey -M menuselect '^M' .accept-line

compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select interactive
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'

# Group matches and Describe
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'

alias dv='dirs -v'
alias ll='ls -l'
alias grep='grep --color=auto'
alias kk='kinit && aklog'
alias cpwd='pwd | pbcopy'

# global alias
alias '..'='cd ..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g G='| grep'
alias -g GV='| grep -v'
alias ag='alias | grep -i'


################# BEGINNING OF GIT INFO

fpath=($fpath $HOME/.zsh/func)
typeset -U fpath
autoload -U ~/.zsh/func/*(:t)

# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions
 
# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'

################# END OF GIT INFO

function precmd {

local TERMWIDTH
(( TERMWIDTH = ${COLUMNS} - 1 ))

###
# Truncate the path if it's too long.

PR_FILLBAR=""
PR_PWDLEN=""

local promptsize=${#${(%):---(%n@%m)----}}
local pwdsize=${#${(%):-%~}}
local GIT_INFO="$(git_info)"
local gitsize=${#GIT_INFO}

if [[ "$promptsize + $pwdsize + $gitsize" -gt $TERMWIDTH ]]; then
((PR_PWDLEN=$TERMWIDTH - $promptsize - $gitsize))
else
PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize + $gitsize)))..${PR_HBAR}.)}"
fi

###
# Get APM info.

#if which ibam > /dev/null; then
#PR_APM_RESULT=`ibam --percentbattery`
#elif which apm > /dev/null; then
#PR_APM_RESULT=`apm`
#fi
}

setopt extended_glob
preexec () {
if [[ "$TERM" == "screen" ]]; then
local CMD=${1[(wr)^(*=*|sudo|-*)]}
echo -n "\ek$CMD\e\\"
fi
}

setprompt () {
###
# Need this so the prompt will work.

setopt prompt_subst

###
# See if we can use colors.

autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
(( count = $count + 1 ))
done
PR_NO_COLOUR="%{$terminfo[sgr0]%}"

###
# See if we can use extended characters to look nicer.

typeset -A altchar
set -A altchar ${(s..)terminfo[acsc]}
PR_SET_CHARSET="%{$terminfo[enacs]%}"
PR_SHIFT_IN="%{$terminfo[smacs]%}"
PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
PR_HBAR=${altchar[q]:--}
#PR_HBAR=" "
PR_ULCORNER=${altchar[l]:--}
PR_LLCORNER=${altchar[m]:--}
PR_LRCORNER=${altchar[j]:--}
PR_URCORNER=${altchar[k]:--}

###
# Decide if we need to set titlebar text.

case $TERM in
xterm*)
PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
export TERM=ansi
;;
screen)
PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
;;
*)
PR_TITLEBAR=''
;;
esac

###
# Decide whether to set a screen title
if [[ "$TERM" == "screen" ]]; then
PR_STITLE=$'%{\ekzsh\e\\%}'
else
PR_STITLE=''
fi

###
# APM detection

#if which ibam > /dev/null; then
#PR_APM='$PR_RED${${PR_APM_RESULT[(f)1]}[(w)-2]}%%(${${PR_APM_RESULT[(f)3]}[(w)-1]})$PR_LIGHT_BLUE:'
#elif which apm > /dev/null; then
#PR_APM='$PR_RED${PR_APM_RESULT[(w)5,(w)6]/\% /%%}$PR_LIGHT_BLUE:'
#else
PR_APM=''
#fi


###
# Finally, the prompt.

PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_CYAN$PR_SHIFT_IN$PR_ULCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT [\
$PR_GREEN%(!.%SROOT%s.%n)$PR_GREEN@%m\
$PR_BLUE]$PR_SHIFT_IN $PR_SHIFT_OUT$PR_BLUE\
$PR_MAGENTA%$PR_PWDLEN<..<%~%<<\
$(prompt_git_info)\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR${(e)PR_FILLBAR}$PR_CYAN$PR_URCORNER$PR_SHIFT_OUT\

$PR_CYAN$PR_SHIFT_IN$PR_LLCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT \
%(?..$PR_LIGHT_RED%?$PR_BLUE:)\
$PR_LIGHT_BLUE%(!.$PR_RED#.$PR_WHITE\$)$PR_SHIFT_IN$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_SHIFT_OUT\
$PR_NO_COLOUR '

RPROMPT=' $PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
($PR_YELLOW%D{%H:%M}$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'

PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
}

setprompt



compdef bzr

# Rudimentary zsh completion support for bzr.

# -S means there are no options after a -- and that argument is ignored

# To use this you must arrange for it to be in a directory that is on
# your $fpath, and also for compinit to be run.  I don't understand
# how to get zsh to reload this file when it changes, other than by
# starting a new zsh.


local _bzr_subcommands expl curcontext="$curcontext" state line
local fileList
typeset -A opt_args

if [[ $service == "bzr" ]]; then
    _arguments -C -A "-*" \
    '*::command:->subcmd' && return 0

    if (( CURRENT == 1 )); then
      _bzr_subcommands=(${(f)"$(_call_program bzr bzr shell-complete)"})
      _describe -t subcommand 'subcommand' _bzr_subcommands
      return
    fi

    service="$words[1]"
    curcontext="${curcontext%:*}=$service:"
fi


[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # This loads RVM into a shell session.

