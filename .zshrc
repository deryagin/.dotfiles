# https://grml.org/zsh/zsh-lovers.html

# a path to the personal scripts
export PATH=~/.bin:$PATH

# nvm (Node.js Version Manager)
export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
export NODE_PATH=$(npm root --quiet -g)

# command line prompt
PROMPT='%F{cyan}%M%f:%F{yellow}%~%f %B$%b '
PROMPT2='    %i ->'
RPROMPT='%B%*%b'

# wakatime, taken from https://github.com/irondoge/bash-wakatime/blob/master/bash-wakatime.sh
pre_prompt_command() {
    entity=$(echo $(fc -ln -0) | cut -d ' ' -f1)
    [ -z "$entity" ] && return # $entity is empty or only whitespace
    git status &> /dev/null && local project="$(basename $(git rev-parse --show-toplevel))" || local project="Terminal"
    (wakatime --write --plugin "zsh-wakatime" --entity-type app --project "$project" --entity "$entity" 2>&1 > /dev/null &)
}

precmd () { pre_prompt_command }

# base env variables
export TERM=screen-256color
export EDITOR='vim'
export PAGER='less -inrS --tabs=4'
export PSQL_EDITOR='vim -c "set ft=plsql"'
export VISUAL='vim -c "set ft=mysql"'

# global behavior
setopt extended_glob
setopt correct
setopt No_Beep

# history
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt  append_history
setopt  hist_ignore_all_dups
setopt  hist_ignore_space
setopt  hist_reduce_blanks
setopt	share_history

# autocomplete
autoload -U compinit
compinit -C

# menu with autocomplete options by single Tab
zstyle ':completion:' menu yes select

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# autocomplete an user name and host for SSH
hosts=(`cat ~/.ssh/known_hosts | tr , " " | awk '{ print $1 }'`)
zstyle ':completion:*:hosts' hosts $hosts
zstyle ':completion:*:(ssh|scp):*' tag-order '! users'

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# file`s coloring depending on the type
eval `dircolors`
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# grc command output highlighting
if [ -f /usr/bin/grc ]; then
  alias ping="grc --colour=auto ping"
  alias traceroute="grc --colour=auto traceroute"
  alias make="grc --colour=auto make"
  alias diff="grc --colour=auto diff"
  alias netstat="grc --colour=auto netstat"
fi

# grep's template highlight
export GREP_COLOR='1;32'

# key bindings https://wiki.archlinux.org/index.php/Zsh#Key_bindings
# initially run zkbd, it will create  ~/.zkbd/xterm.
# autoload zkbd
# source ~/.zkbd/$TERM # may be different - check where zkbd saved the configuration:
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char

# navigate command history like vim
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" history-beginning-search-backward
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" history-beginning-search-forward

# jump by words using Ctrl+Left/Right
# http://stackoverflow.com/questions/12382499/looking-for-altleftarrowkey-solution-in-zsh
if [ -n "$TMUX" ]; then
	bindkey "^[OC" forward-word
	bindkey "^[OD" backward-word
else
	bindkey "^[[1;5C" forward-word
	bindkey "^[[1;5D" backward-word
fi

# auto add cd, if only path entered
setopt autocd

# show command name in tetminal title xterm|rxvt|screen
case $TERM in
  gnome-terminal|xterm*|rxvt|screen-256color)
    preexec(){print -Pn "\e]0;$0\a"}
    precmd () { print -Pn "\e]0;%n@%m: %~\a" }
    ;;
  screen)
    precmd () { print -Pn "\033k%~\033\\" }
    preexec () { print -Pn "\033k$1\033\\" }
    ;;
esac

# aliases
alias cp="cp -v"
alias mv="mv -v"
alias rm="rm -v"
alias j="jobs"
alias ls="ls --color --group-directories-first --sort=extension --time-style=long-iso"
alias la="ls -lA --color --group-directories-first --sort=extension --time-style=long-iso"
alias ll="ls -l --color --group-directories-first --sort=extension --time-style=long-iso"
alias lh="ls -lh --color --group-directories-first --sort=extension --time-style=long-iso"
alias ld="ls -ld --color --sort=extension --time-style=long-iso"
alias l1="ls -1"
alias grep='grep --color=auto --exclude-dir=.git --exclude-dir=.idea'
alias less='less -MR'
alias mount='mount | column -t'
alias fdn='f() { find . -iname "*$1*" }; f' # case insensitive search by template
alias gitdiff="git difftool --tool=vimdiff --no-prompt"
alias gitsave="git add -u; git commit -m 'WIP. Save point.'"
alias gitback="git reset --mixed HEAD~1"
alias gitco='f() { git branch | grep $1 | sed s/*\ // | xargs git checkout && git status -sb }; f' # git checkout by <pattern>
alias gitswitch='git add -u;  git commit -m "WIP. Save point."; gitco $1' # git save current changes and checkout other branch by <pattern>
alias json="jq '.' | vim -c 'set syntax=json nowrap nofoldenable' - " # e.g. curl -s -k -L https://example.com | json
alias scurl="curl -w '\n\nLookup time:\t%{time_namelookup}s\nConnect time:\t%{time_connect}s\nTotal time:\t%{time_total}s\n'" # prints timings stats at the end

# dirs aliases
hash -d log=/var/log/

# man-pages coloring
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# hints
# !! - last command repeat
# sudo !! - last command repeat with sudo
# sudo fuser /var/lib/apt/lists/lock - PID of process which is locking apt database
# cd - next/prev directory
# source ~/.zshrc - config reload
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
