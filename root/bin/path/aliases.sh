alias bd='cd ../'
alias ls='ls -FG --color'
alias ll='ls -lFG --color'
alias la='ls -alFG --color'
alias q='exit'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
alias o.='open .'
alias qa='$HOME/bin/quit_app.sh'
alias br='cd ..'

run_cloud_code_container(){
	cd $HOME/ccc/.ccc
	make
	cd -
}
alias ccc=run_cloud_code_container

run_cloud_code_log(){
	cd $HOME/ccc/.ccl
	make
	cd -
}
alias ccl=run_cloud_code_log

alias cdssh='cd $HOME/.ssh'
alias cdtmp='cd $HOME/tmp'
alias cdot='cd $HOME/dotfiles'
alias cdbin='cd $HOME/bin'
alias cdr='cd $_'
alias k='kubectl'

alias prv='ssh prv'
alias pss='ssh prvssh'
alias prvtmux='ssh -t prv tmux new-session -s prv'

alias tree="tree -I node_modules"
alias rg="rg --hidden -g '!{node_modules/*,.git/*}'"
alias shfmt="$(which shfmt) -i 2 -ci -bn -s"
alias sls='serverless'
alias pn=pnpm
alias va='. .venv/bin/activate'


[[ -d "/opt/homebrew/opt/util-linux/bin/" ]] && alias cal='/opt/homebrew/opt/util-linux/bin/cal -m'

start_tmux() {
	if [[ $__CFBundleIdentifier == 'com.microsoft.VSCode' ]]; then
		[[ -z "$(tmux ls | grep code)" ]] && tmux new -s 'code' || tmux a -t 'code'
	elif [[ $THIS_ITERM2 == 'DOC' ]]; then
		[[ -z "$(tmux ls | grep doc)" ]] && tmux new -s 'doc' || tmux a -t 'doc'
	elif [[ $__CFBundleIdentifier == 'com.googlecode.iterm2' ]]; then
		[[ -z "$(tmux ls | grep iTerm)" ]] && $HOME/bin/tmux-dev.sh || tmux a -t 'iTerm'
	else
		[[ -z $TMUX ]] && [[ -z "$(tmux ls | grep $(whoami))" ]] && tmux new -s $(whoami) || tmux a -t $(whoami)
	fi
}
alias ta='start_tmux'

if [[ $(command -v nvim) ]]; then
	export EDITOR="nvim"
	alias vimdiff='nvim -d'
else
	export EDITOR="vim"
fi
start_nvim() {
  if [[ $TMUX_SESSION_NAME == *"term_on_vim"* ]]; then
    echo "This terminal on tmux pop window."
  else
    $EDITOR $*
  fi
}
alias v='start_nvim'
alias vi='start_nvim'
alias vim='start_nvim'

if [[ $XDG_SESSION_TYPE == "x11" ]];then
  alias pbcopy='xsel -bi'
  alias pbpaste='xsel -b'
fi
if [[ $WAYLAND_DISPLAY == "wayland-"* ]];then
  alias pbcopy='wl-copy'
  alias pbpaste='wl-paste'
fi
