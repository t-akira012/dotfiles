export BROWESR="/Applications/Google Chrome.app"
export FILTER='fzf'
if [[ $(command -v nvim) ]]; then
  export EDITOR="nvim"
  alias vimdiff='nvim -d'
else
  export EDITOR="vim"
fi

alias vi="$EDITOR"
alias vim="$EDITOR"

export HOMEBREW_NO_AUTO_UPDATE=1

# coreutils
[[ -d /opt/homebrew/opt/coreutils/libexec/gnubin ]] && export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
[[ -d /usr/local/opt/coreutils/libexec/gnubin ]] && export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# gnu
[[ $(command -v gsed) ]] && alias sed='gsed'
[[ $(command -v gawk) ]] && alias awk='gawk'
[[ $(command -v ggrep) ]] && alias grep='ggrep'
[[ $(command -v gxargs) ]] && alias xargs="gxargs"

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
[[ $(command -v rbenv) ]] &&
  eval "$(rbenv init - zsh)"

# python
[[ $(command -v pyenv) ]] &&
  export PYENV_ROOT="$HOME/.pyenv" &&
  export PATH="$PYENV_ROOT/bin:$PATH" &&
  eval "$(pyenv init -)"


# node
if [[ $(command -v nodebrew) ]]; then
  export PATH="$HOME/.nodebrew/current/bin:$PATH"
elif [[ $(command -v nodenv) ]]; then
  export PATH="$HOME/.nodenv/bin:$PATH"
  eval "$(nodenv init -)"
fi

# fzf
# https://github.com/junegunn/fzf/wiki/Color-schemes
_gen_fzf_default_opts() {
  local base03="234"
  local base02="235"
  local base01="240"
  local base00="241"
  local base0="244"
  local base1="245"
  local base2="254"
  local base3="230"
  local yellow="136"
  local orange="166"
  local red="160"
  local magenta="125"
  local violet="61"
  local blue="33"
  local cyan="37"
  local green="64"

  local FZF_DARK="--color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow"
  local FZF_LIGHT="--color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue --color info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow"
  export COLOR_OPTS="$FZF_DARK"
  local OPTS="--height 70% --layout=reverse --preview-window=right --preview '[[ -d {} ]] && exa -T {} | head -200 || bat {}'"
  export FZF_DEFAULT_OPTS="$COLOR_OPTS $OPTS"
  export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!.git/*"'
  export FZF_TMUX_OPTS="-p 80%"
}
_gen_fzf_default_opts
