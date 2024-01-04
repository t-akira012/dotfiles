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

# 複数ファイルを選択してファイルコピー
__fzf-multi-copy(){
  if ! type gxargs > /dev/null 2>&1;then
      echo require gxargs
  fi
  if ! type gcp > /dev/null 2>&1;then
      echo require gcp
  fi
  local SELECTED="$(unbuffer ls -lA --color | tail -n +2 | fzf -m --ansi --preview "[[ -d {9} ]] && exa -T {9} || bat {9}" | awk '{print substr($0,index($0,$9))}')"

  if [[ ! -z $SELECTED ]]; then
      local DIR_SELECT_MODE=$(echo -e "current_dir\nz\ntree" | fzf --preview "")
      if [[ $DIR_SELECT_MODE == 'z' ]];then
          local TARGET_DIR="$(__cd-well | sort | uniq | fzf | sed 's/^[0-9,.]* *//')"
      fi
      if [[ $DIR_SELECT_MODE == 'tree' ]];then
          local DEPTH=$([ -z $1 ] && echo 9 || echo $1)
          local TARGET_DIR=$(tree -i -d -n -N -L $DEPTH -f -d -a -I node_modules -I .git | fzf)
      fi
      if [[ $DIR_SELECT_MODE == 'current_dir' ]];then
          local TARGET_DIR="$PWD/$(unbuffer ls -la --color | rg ^d | awk '{print substr($0,index($0,$9))}' | fzf --ansi --preview "exa -T {}")"
      fi
      echo -e "== TARGET DIR IS:\n$TARGET_DIR"
      echo -e "== SOURCE FILE IS:\n$SELECTED"
      read -p "OK?(ctrl-c OR enter)"
      echo "${SELECTED}" | gxargs -d\\n -I {} gcp -i -v {} -t "$TARGET_DIR"
  fi
}
__fzf-multi-move(){
  if ! type gxargs > /dev/null 2>&1;then
      echo require gxargs
  fi
  if ! type gmv > /dev/null 2>&1;then
      echo require gmv
  fi
  local SELECTED="$(unbuffer ls -lA --color | tail -n +2 | fzf -m --ansi --preview "[[ -d {9} ]] && exa -T {9} || bat {9}" | awk '{print substr($0,index($0,$9))}')"

  if [[ ! -z $SELECTED ]]; then
      local DIR_SELECT_MODE=$(echo -e "current_dir\nz\ntree" | fzf --preview "")
      if [[ $DIR_SELECT_MODE == 'z' ]];then
          local TARGET_DIR="$(__cd-well | sort | uniq | fzf | sed 's/^[0-9,.]* *//')"
      fi
      if [[ $DIR_SELECT_MODE == 'tree' ]];then
          local DEPTH=$([ -z $1 ] && echo 9 || echo $1)
          local TARGET_DIR=$(tree -i -d -n -N -L $DEPTH -f -d -a -I node_modules -I .git | fzf)
      fi
      if [[ $DIR_SELECT_MODE == 'current_dir' ]];then
          local TARGET_DIR="$PWD/$(unbuffer ls -la --color | rg ^d | awk '{print substr($0,index($0,$9))}' | fzf --ansi --preview "exa -T {}")"
      fi
      echo -e "== TARGET DIR IS:\n$TARGET_DIR"
      echo -e "== SOURCE FILE IS:\n$SELECTED"
      read -p "OK?(ctrl-c OR enter)"
      echo "${SELECTED}" | gxargs -d\\n -I {} gmv -i -v {} -t "$TARGET_DIR"
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
alias mmv='__fzf-multi-move'
alias mcp='__fzf-multi-copy'
