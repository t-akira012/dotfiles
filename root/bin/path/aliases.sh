alias ls='ls -FG --color'
alias ll='ls -lFG --color'
alias la='ls -alFG --color'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
alias o.='open .'

alias cdssh='cd $HOME/.ssh'
alias cdtmp='cd $HOME/tmp'
alias cdchore='cd $HOME/Chore'
alias cdot='cd $HOME/dotfiles'
alias cdbin='cd $HOME/bin'
alias cdnas='cd $HOME/nas'
alias prv='ssh prv'

alias tree="tree -I node_modules"
alias treed="tree -d -I node_modules"
alias a='OPENAPP=$(unbuffer fd -d 3 '^*.app$' /Applications/ | fzf --ansi) && open "$OPENAPP"'
alias zz='zellij'
alias t='date +"%Y/%m/%d %a %H:%M:%S"'

if type podman >/dev/null 2>&1; then
  alias docker="podman"
fi

start_tmux() {
  if [[ $__CFBundleIdentifier == 'com.microsoft.VSCode' ]]; then
    [[ -z "$(tmux ls | grep code)" ]] && tmux new -s 'code' || tmux a -t 'code'
  elif [[ $__CFBundleIdentifier == 'com.googlecode.iterm2' ]]; then
    [[ -z "$(tmux ls | grep iTerm)" ]] && tmux new -s 'iTerm' || tmux a -t 'iTerm'
  else
    [[ -z "$(tmux ls | grep other)" ]] && tmux new -s 'other' || tmux a -t 'other'
  fi
}
alias ta='start_tmux'

tmux_select_window_fzf (){
  [[ -z $1 ]] && local window=$(tmux list-windows | awk '{print $1, $2}' | fzf --preview '' | cut -c 1) || local window=$1
  tmux select-window -t $window
}
# alias t='tmux_select_window_fzf'

alias statf="stat --format='%a %U %G %n'"
alias sls='serverless'
alias rg="rg --hidden -g '!{node_modules/*,.git/*}'"

alias ranger='TERM=xterm-256color && ranger'
alias r='[ -z "$TMUX" ] && ranger || echo "in TMUX"'

alias mp='multipass'
alias mk='make'
alias q='exit'
alias bd='cd ../'
alias cdr='cd $_'

alias shfmt="$(which shfmt) -i 2 -ci -bn -s"
