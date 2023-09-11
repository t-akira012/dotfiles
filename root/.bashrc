# ---- BASHRC ----
# Lang
export LANG="ja_JP.UTF-8"

export BASHRC_EX="$HOME/.ex"
[[ -e "$BASHRC_EX" ]] && . "$BASHRC_EX"

# disable C-s
stty stop undef
# disable C-d
export IGNOREEOF=9999

# linuxbrew
[[ -d /home/linuxbrew ]] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
# M1 brew
[[ -d /opt/homebrew/ ]] && export PATH="/opt/homebrew/bin:$PATH"
# asdf
[[ -f $HOME/.asdf/asdf.sh ]] && . $HOME/.asdf/asdf.sh
[[ -f $(brew --prefix asdf)/libexec/asdf.sh ]] && . $(brew --prefix asdf)/libexec/asdf.sh

# bash-completion
[[ -f $(brew --prefix)/etc/bash_completion ]] && . $(brew --prefix)/etc/bash_completion

# タブ補完
bind '"\t":menu-complete'
bind '"\e[Z": menu-complete-backward'
bind "set show-all-if-ambiguous on"
bind "set completion-ignore-case on"
bind "set menu-complete-display-prefix on"

## History
HISTCONTROL=ignoreboth
HISTIGNORE='?:??:???:????:?????:exit:history*:reload:cd *:delhis'
HISTSIZE=1000
HISTFILESIZE=2000
# bashのプロセスを終了する時に、メモリ上の履歴を履歴ファイルに追記する動作を停止
shopt -u histappend

# History functions
__clear_history(){
  cat /dev/null > ~/.bash_history
  history -c
}

__update_history() {
  local exit_status="$?"
  if [[ $exit_status != "0" ]] ;then
    history -d $(history 1 | awk '{print $1}')
    false
  fi
}

__share_history() {
  history -a
  tac ~/.bash_history | awk '!a[$0]++' | tac > ~/.bash_history.tmp
  [[ -f ~/.bash_history.tmp ]] &&
    mv -f ~/.bash_history{.tmp,} &&
    history -c &&
    history -r
}

# z
[[ -f $(brew --prefix)/etc/profile.d/z.sh ]] && . $(brew --prefix)/etc/profile.d/z.sh
. $HOME/bin/func/cd-well

# bindkey functions
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
__fzf-z-insert() {
  local selected=$(_z -l 2>&1 | sort | awk '{print $2}' | fzf | sed 's/^[0-9,.]* *//')
  [[ -n $selected ]] && \
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}\"$selected\"${READLINE_LINE:$READLINE_POINT}" && \
    READLINE_POINT=$(( READLINE_POINT + ${#selected} + 2 ))
}

__fzf-find() {
  local selected=$(rg --files --follow --no-ignore-vcs --hidden -g '!{node_modules/*,.git/*}' | fzf)
  [[ -n $selected ]] && \
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}\"$selected\"${READLINE_LINE:$READLINE_POINT}" && \
    READLINE_POINT=$(( READLINE_POINT + ${#selected} + 2 ))
}
__fzf-history() {
  __share_history
  local BUFFER=$READLINE_LINE
  local selected=$(cat $HOME/.bash_history | sort | uniq | fzf --query="$BUFFER" --preview="" )
  [[ -n $selected ]] && \
    READLINE_LINE="$selected"
    READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}
__fzf-delete-history() {
  __share_history
  local BUFFER=$READLINE_LINE
  local selected=$(history | sort | uniq | fzf --query="$BUFFER" --preview="" | awk '{print $1}')
  [[ -n $selected ]] && \
    echo "$selected" && \
    history -d "$selected"
  history -w
}
__fzf-la() {
  local selected=$(unbuffer ls -lA --color | fzf --ansi --preview="" | awk '{print substr($0,index($0,$9))}' | xargs echo)
  [[ -n $selected ]] && \
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}\"$selected\"${READLINE_LINE:$READLINE_POINT}" && \
    READLINE_POINT=$(( READLINE_POINT + ${#selected} + 2 ))
}
__fzf-ghq-cd() {
  local selected=`ghq list | fzf --preview "bat $(ghq root)/{}/README.md "`
  [[ -n $selected ]] && \
    cd $(ghq root)/$selected
}

__fzf-find-dir() {
  local selected=$(fd -t d -I | fzf)
  [[ -n $selected ]] && \
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}\"$selected\"${READLINE_LINE:$READLINE_POINT}" && \
    READLINE_POINT=$(( READLINE_POINT + ${#selected} + 2 ))
}

# bind
bind -x ' "\ez": __fzf-z-insert'
bind -x ' "\ed": __fzf-la'
bind -x ' "\C-t": __fzf-find'
bind -x ' "\C-g": __fzf-ghq-cd '
bind -x ' "\C-r": __fzf-history'
bind -x ' "\C-o": __fzf-find-dir'

alias reload='source ~/.bashrc'
alias delhis='__fzf-delete-history'

# source
. $HOME/bin/path/aliases.sh
. $HOME/bin/path/export.sh
. $HOME/bin/func/fzf.sh
. $HOME/bin/func/git.sh

# vifm cd
vicd() {
    local dst="$(command vifm --choose-dir - "$@")"
    if [ -z "$dst" ]; then
        echo 'Directory picking cancelled/failed'
        return 1
    fi
    cd "$dst"
}

# show status
__show_status() {
    local status=$(echo ${PIPESTATUS[@]})
    local SETCOLOR_SUCCESS="echo -en \\033[1;39m"
    local SETCOLOR_FAILURE="echo -en \\033[1;31m"
    local SETCOLOR_WARNING="echo -en \\033[1;33m"
    local SETCOLOR_NORMAL="echo -en \\033[0;39m"

    local SETCOLOR s
    for s in ${status}
    do
        if [ ${s} -gt 100 ]; then
            SETCOLOR=${SETCOLOR_FAILURE}
        elif [ ${s} -gt 0 ]; then
            SETCOLOR=${SETCOLOR_WARNING}
        else
            SETCOLOR=${SETCOLOR_SUCCESS}
        fi
    done
    ${SETCOLOR}
    echo -n "$"
    ${SETCOLOR_NORMAL}
}

# git-prompt
[[ -f $HOME/.local/bin/git-completion.bash ]] && source $HOME/.local/bin/git-completion.bash
if [[ -f $HOME/.local/bin/git-prompt.sh ]];then
  . $HOME/.local/bin/git-prompt.sh
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWUPSTREAM=auto
  GIT_PS1_SHOWUNTRACKEDFILES=
  GIT_PS1_SHOWSTASHSTATE=
  export PS1='\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\n$ '
else
  export PS1='\[\033[35m\]\w\033[00m\]\n$ '
fi
