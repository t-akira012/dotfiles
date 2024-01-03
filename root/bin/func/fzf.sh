## functions
__fzf-open() {
  local SELECTED=$(unbuffer ls -lA --color | rg ^- | fzf --ansi --preview="" | awk '{print substr($0,index($0,$9))}' | xargs echo)
  [[ -f "$SELECTED" ]] && open "$SELECTED"
}

__fzf-z-cd() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(__cd-well | sort | uniq | fzf | sed 's/^[0-9,.]* *//')"
}

__fzf-la-cd() {
  local selected=$(unbuffer ls -lA --color | rg ^d | awk '{print substr($0,index($0,$9))}' | fzf --ansi --preview "exa -T {}" | xargs echo) 
  [[ -n $selected ]] && cd $selected 
}

__fzf-tree() {
  local DEPTH=$([ -z $1 ] && echo 9 || echo $1)
  local SELECTED=$(tree -i -d -n -N -L $DEPTH -f -d -a -I node_modules -I .git | fzf)
  [[ -d "$SELECTED" ]] && cd "$SELECTED"
}

__fzf-find-vi() {
  if [[ $# -eq 0 ]]; then
    local selected=$(rg --files --follow --no-ignore-vcs --hidden -g '!{node_modules/*,.git/*}' | sort | sed 's?^./??' | fzf)
  else
    local selected=$(rg --files --follow --no-ignore-vcs --hidden -g '!{node_modules/*,.git/*}' | sort | sed 's?^./??' | fzf -q $*)
  fi
  [[ -n $selected ]] && echo $selected && $EDITOR "$selected"
}

__fzf-ghq-web() {
  local SELECTED=`ghq list | fzf --preview "bat $(ghq root)/{}/README.md "`
  [[ ! -z $SELECTED ]] && gh repo view --web $SELECTED 
}

ghq-cd() {
  local SELECTED=`ghq list | fzf --preview "cat $(ghq root)/{}/README.md "`
  [[ ! -z $SELECTED ]] && cd $(ghq root)/$SELECTED 
}

# ファイル名コピー
__fzf-filename-copy(){
  local SELECTED=$(unbuffer ls -lA --color | awk '{print substr($0,index($0,$9))}' | fzf --ansi --preview "" | xargs echo)
  if [[ ! -z $SELECTED ]]; then
    local ext=${SELECTED##*.}
    echo $(basename -s .$ext $SELECTED) | pbcopy
  fi
}

alias o='__fzf-open'
alias z='__fzf-z-cd'
alias l='__fzf-la-cd'
alias vz='__fzf-find-vi'
alias tf='__fzf-tree'
alias ghqw='__fzf-ghq-web'
alias cdg='ghq-cd'
alias fnamecopy='__fzf-filename-copy'


## Works

__fzf-tree-Works(){
  local DEPTH=$([ -z $1 ] && echo 9 || echo $1)
  local W_DIR=$HOME/Works
  local SELECTED=$(tree $W_DIR -i -d -n -N -L $DEPTH -f -d -a -I node_modules -I .git | sed "s?$W_DIR??g" | fzf --preview "[[ -d $W_DIR/{} ]] && exa -T $W_DIR/{} | head -200 || bat $W_DIR/{}")
  if [[ -n $SELECTED ]]; then
    BUFFER="${BUFFER}\"$W_DIR/$SELECTED\""
    CURSOR=${#BUFFER}
  fi
  zle reset-prompt
}

if [[ $SHELL == "/bin/zsh" ]];then
    zle -N __fzf-tree-Works
    bindkey '\et' __fzf-tree-Works
fi
