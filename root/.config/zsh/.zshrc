# ---- ZSHRC ----
# Lang
export LANG="ja_JP.UTF-8"

export ZDOTDIR="$HOME/.config/zsh"
export ZSHRC_EX="$HOME/.ex"
[[ -e "$ZSHRC_EX" ]] && . $ZSHRC_EX

# disable C-s
stty stop undef
# disable C-d
stty eof undef
setopt IGNOREEOF

# linuxbrew
[[ -d /home/linuxbrew ]] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
# M1 brew
[[ -d /opt/homebrew/ ]] && eval $(/opt/homebrew/bin/brew shellenv)
# asdf
[[ -f $HOME/.asdf/asdf.sh ]] && . $HOME/.asdf/asdf.sh
# z
type brew >/dev/null 2>&1 && [[ -f $(brew --prefix)/etc/profile.d/z.sh ]] && . $(brew --prefix)/etc/profile.d/z.sh
[[ -e $HOME/.local/bin/z.sh ]] && . $HOME/.local/bin/z.sh
unalias z 2> /dev/null


# zsh-settings
bindkey -e
# 日本語ファイル名を表示可能にする
setopt print_eight_bit
# beep 無効化
setopt no_beep
# wildcard でファイル名生成時に、hitしなくてもエラーを出さない
setopt nonomatch
# 補完機能を有効にする
# -u : 上記のテストを避けて、すべての発見したファイルを警告なしに使用する
# -i : すべての安全でないファイルとディレクトリを無視する
# -C : セキュリティチェック全体をスキップする
autoload -Uz compinit; compinit -iC
# ディレクトリ選択時、最後の/を残す
setopt noautoremoveslash

# colors
autoload -Uz colors; colors
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors di=34 ln=35 ex=31

# history
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=2000
SAVEHIST=2000
setopt append_history       # 複数の zsh を同時に使う時など history ファイルに上書きせず追加
setopt inc_append_history   # コマンドが入力されるとすぐに追加
setopt hist_ignore_dups     # 前と重複する行は記録しない
setopt share_history        # 同時に起動したzshの間でヒストリを共有する
setopt hist_reduce_blanks   # 余分なスペースを削除してヒストリに保存する
setopt HIST_IGNORE_SPACE    # 行頭がスペースのコマンドは記録しない
setopt HIST_IGNORE_ALL_DUPS # 履歴中の重複行をファイル記録前に無くす
setopt HIST_FIND_NO_DUPS    # 履歴検索中、(連続してなくとも)重複を飛ばす
setopt HIST_NO_STORE        # histroyコマンドは記録しない
# http://mollifier.hatenablog.com/entry/20090728/p1
zshaddhistory() {
  local line=${1%%$'\n'} #コマンドライン全体から改行を除去したもの
  local cmd=${line%% *}  # １つ目のコマンド
  # 以下の条件をすべて満たすものだけをヒストリに追加する
  [[ ${#line} -ge 5
  && ${cmd} != (l|l[sal])
  && ${cmd} != (cd)
  && ${cmd} != (m|man)
  && ${cmd} != (r[mr])
  && ${cmd} != (twty)
  ]]
}
__clear_history(){
  echo /dev/null > $HISTFILE
  fc -R $HISTFILE
}

# preexec(){ }
# precmd(){ }

# 補完キー連打で順に補完候補を自動で補完
setopt menu_complete
setopt auto_menu
zstyle ':completion:*:default' menu select=1
bindkey "^I" menu-complete
bindkey "\e[Z" reverse-menu-complete
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# replace z
. $HOME/bin/func/cd-well

# functions
__zle-nothing() {
    return
}

__zle-fzf-z-insert() {
  local SELECTED=$(__cd-well | sort | uniq | fzf | sed 's/^[0-9,.]* *//')
  if [[ -n $SELECTED ]]; then
      BUFFER="${BUFFER}\"${SELECTED}\""
      CURSOR=${#BUFFER}
  fi
  zle reset-prompt
}

__zle-fzf-find() {
  local SELECTED=$(rg --files --follow --no-ignore-vcs --hidden -g '!{node_modules/*,.git/*}' | fzf)
  if [[ -n $SELECTED ]]; then
    BUFFER="${BUFFER}\"${SELECTED}\""
    CURSOR=${#BUFFER}
  fi
  zle reset-prompt
}

__zle-fzf-history() {
  local SELECTED=$(fc -l -n -r 1 | fzf --query=$BUFFER --preview="")
  if [[ -n $SELECTED ]]; then
    BUFFER="$SELECTED"
    CURSOR=${#BUFFER}
  fi
  zle reset-prompt
}
__zle-fzf-la() {
  local SELECTED=$(unbuffer ls -lA --color | fzf --ansi --bind='ctrl-o:execute(open $PWD/{})' --preview="[[ -d {9} ]] && exa -T {9} || bat {9}" | awk '{print substr($0,index($0,$9))}' | xargs echo)
  if [[ -n $SELECTED ]]; then
    BUFFER="${BUFFER}\"$SELECTED\""
    CURSOR=${#BUFFER}
  fi
  zle reset-prompt
}
__zle-fzf-ghq-cd() {
  local SELECTED=$(ghq list | fzf --preview "cat $(ghq root)/{}/README.md ")
  [[ ! -z $SELECTED ]] && cd $(ghq root)/$SELECTED
  zle reset-prompt
}

__zle-fzf-find-dir() {
  local SELECTED=$(fd -t d -I | fzf)
  if [[ -n $SELECTED ]]; then
    BUFFER="${BUFFER}\"${SELECTED}\""
    CURSOR=${#BUFFER}
  fi
  zle reset-prompt
}

# bindkey
zle -N __nothing
zle -N __zle-fzf-z-insert
zle -N __zle-fzf-la
zle -N __zle-fzf-history
zle -N __zle-fzf-find
zle -N __zle-fzf-ghq-cd
zle -N __zle-fzf-find-dir
bindkey '\el' __zle-fzf-la
bindkey '\ez' __zle-fzf-z-insert
bindkey '^@' __zle-nothing
bindkey '^s' __zle-nothing
bindkey '^r' __zle-fzf-history
bindkey '^t' __zle-fzf-find
# bindkey '^g' __zle-fzf-ghq-cd
bindkey '^o' __zle-fzf-find-dir

__fzf-ghq-cd() {
  local selected
  selected=$(ghq list | fzf --preview 'cat "$(ghq root)/{}/README.md" 2>/dev/null' --preview-window=down:30%)
  [[ -n "$selected" ]] && cd "$(ghq root)/$selected" || return 1
}
alias gg='__fzf-ghq-cd'

# source
. $HOME/bin/path/aliases.sh
. $HOME/bin/path/export.sh
. $HOME/bin/func/fzf.sh
. $HOME/bin/func/git.sh
. $HOME/bin/func/git-fzf-worktree.sh

# alias
alias reload="exec zsh -l"

# zsh plugins
export ZPLUGDIR="$ZDOTDIR/repos/"
export fpath=(${ZPLUGDIR}zsh-completions/src $fpath)
export fpath=(${ZDOTDIR}/zfunc $fpath)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'
. ${ZPLUGDIR}ohmyzsh/lib/completion.zsh
. ${ZPLUGDIR}zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if [[ -e /etc/arch-release ]]; then
    USE_POWERLINE="true"
    if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
        source /usr/share/zsh/manjaro-zsh-config
    fi
    # Use manjaro zsh prompt
    if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
        source /usr/share/zsh/manjaro-zsh-prompt
    fi
elif type starship > /dev/null 2>&1; then
    eval "$(starship init zsh)"
fi
