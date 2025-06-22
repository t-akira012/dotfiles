export TMUX_SESSION_NAME=$(tmux display-message -p '#S')
export TMUX_WINDOW_NAME=$(tmux display-message -p '#W')
export TMUX_WINDOW_PANES=$(tmux display-message -p '#{window_panes}')
if [[ $TMUX_SESSION_NAME = 'term_on_vim'* ]]; then
	__toggle_tmux_popup() {
		$HOME/bin/tmux-popup.sh
	}
	zle -N __toggle_tmux_popup
	bindkey '^j' __toggle_tmux_popup
fi

# docウィンドウなら、docs/docを開く
change_dir_doc(){
  if [[ $(tty) == $(tmux list-panes -F '#{pane_tty}') ]] && [[ $TMUX_WINDOW_PANES -eq 1 ]] && [[ "$TMUX_WINDOW_NAME" == "doc" ]] ; then
    cd $HOME/docs/doc
  fi
}

change_dir_doc

export FILTER='fzf'
export HOMEBREW_NO_AUTO_UPDATE=1

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
# alias claude="$HOME/.claude/local/claude"

# coreutils
# [[ -d /opt/homebrew/opt/coreutils/libexec/gnubin ]] && export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
# [[ -d /usr/local/opt/coreutils/libexec/gnubin ]] && export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# gnu
# [[ $(command -v gsed) ]] && alias sed='gsed'
# [[ $(command -v gawk) ]] && alias awk='gawk'
# [[ $(command -v ggrep) ]] && alias grep='ggrep'
# [[ $(command -v gxargs) ]] && alias xargs="gxargs"

# bin
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Go
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"
export GO111MODULE=auto

# rust
[[ -d "$HOME/.cargo/bin" ]] && export PATH=$HOME/.cargo/bin:$PATH
[[ -e "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# deno
export PATH="$HOME/.deno/bin:$PATH"

# ruby
if [[ $(command -v asdf) ]]; then
	:
elif [[ $(command -v rbenv) ]]; then
	eval "$(rbenv init - zsh)"
fi

# python
if [[ $(command -v asdf) ]]; then
	:
elif [[ $(command -v pyenv) ]]; then
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
fi

# node
if [[ $(command -v asdf) ]]; then
	:
elif [[ $(command -v nodebrew) ]]; then
	export PATH="$HOME/.nodebrew/current/bin:$PATH"
elif [[ $(command -v nodenv) ]]; then
	export PATH="$HOME/.nodenv/bin:$PATH"
	eval "$(nodenv init -)"
fi

# bun completions & bun
[ -s "$HOME/.bun/_bun" ] &&
	source "$HOME/.bun/_bun" &&
	export BUN_INSTALL="$HOME/.bun" &&
	export PATH="$BUN_INSTALL/bin:$PATH"

# fzf
# https://github.com/junegunn/fzf/wiki/Color-schemes
_gen_fzf_default_opts() {
	# https://github.com/jez/dotfiles/blob/master/util/fzf.zsh#L47C1-L58C4
	# Solarized Dark color scheme for fzf
	export FZF_DARK="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:-1,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
    --no-separator
  "
	# Solarized Light color scheme for fzf
	export FZF_LIGHT="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:-1,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow
    --no-separator
  "
	if [[ "$TERM_COLOR_MODE" == "LIGHT" ]]; then
		export COLOR_OPTS="$FZF_LIGHT"
	else
		export COLOR_OPTS="$FZF_DARK"
	fi
	local OPTS="--bind='ctrl-o:execute(open {})' --height 70% --layout=reverse --preview-window=right --preview '[[ -d {} ]] && exa -T {} | head -200 || bat {}'"
	export FZF_DEFAULT_OPTS="$COLOR_OPTS $OPTS"
	export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!.git/*"'
	export FZF_TMUX_OPTS="-p 80%"
}
_gen_fzf_default_opts
