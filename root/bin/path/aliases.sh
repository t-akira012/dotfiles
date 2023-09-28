alias ls='ls -FG --color'
alias ll='ls -lFG --color'
alias la='ls -alFG --color'
alias q='exit'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
alias o.='open .'

alias cdssh='cd $HOME/.ssh'
alias cdtmp='cd $HOME/tmp'
alias cdot='cd $HOME/dotfiles'
alias cdbin='cd $HOME/bin'
alias cdnas='cd $HOME/nas'
alias cdoc="[[ -d $MEMO_DIR ]] && cd $MEMO_DIR || echo 'MEMO_DIR is not set'"
alias cdocs="cd $HOME/docs/"
alias cdr='cd $_'

alias prv='ssh prv'

alias tree="tree -I node_modules"
alias rg="rg --hidden -g '!{node_modules/*,.git/*}'"
alias shfmt="$(which shfmt) -i 2 -ci -bn -s"
alias sls='serverless'
[[ -d "/opt/homebrew/opt/util-linux/bin/" ]] && alias cal='/opt/homebrew/opt/util-linux/bin/cal -m'


start_tmux() {
  if [[ $__CFBundleIdentifier == 'com.microsoft.VSCode' ]]; then
    [[ -z "$(tmux ls | grep code)" ]] && tmux new -s 'code' || tmux a -t 'code'
  elif [[ $__CFBundleIdentifier == 'com.googlecode.iterm2' ]]; then
    [[ -z "$(tmux ls | grep iTerm)" ]] && tmux new -s 'iTerm' || tmux a -t 'iTerm'
  else
      [[ -z "$(tmux ls | grep other)" ]] && tmux new -s $(whoami) || tmux a -t 'other'
  fi
}
alias ta='start_tmux'


# alias mp='multipass'
# alias qqq='exit'
# alias bd='cd ../'
# alias ranger='TERM=xterm-256color && ranger'
# alias r='[ -z "$TMUX" ] && ranger || echo "in TMUX"'

# alias statf="stat --format='%a %U %G %n'"
# alias treed="tree -d -I node_modules"
# alias a='OPENAPP=$(unbuffer fd -d 3 '^*.app$' /Applications/ | fzf --ansi) && open "$OPENAPP"'
# alias t='date +"%Y/%m/%d %a %H:%M:%S"'

# start_zellij() {
#   if [[ -z "$ZELLIJ" ]];then
#     if [[ "$TERM_COLOR_MODE" == "LIGHT" ]];then
#       zellij options --theme "$ZELLIJ_COLOR_LIGHT"
#     else
#       zellij options --theme "$ZELLIJ_COLOR_DARK"
#     fi
#   else
#     echo zellij is aready running.
#   fi
# }
# alias zz='start_zellij'
