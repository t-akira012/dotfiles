## functions
__fzf-open() {
  local SELECTED=$(unbuffer ls -lA --color | rg ^- | fzf --ansi --bind='ctrl-o:execute(open {9})' --preview "[[ -d {9} ]] && exa -T {9} || bat {9}" | awk '{print substr($0,index($0,$9))}' | xargs echo)
  [[ -f "$SELECTED" ]] && open "$SELECTED"
}

# replace zoxide
# __fzf-z-cd() {
#   [ $# -gt 0 ] && _z "$*" && return
#   cd "$(__cd-well | sort | uniq | fzf | sed 's/^[0-9,.]* *//')"
# }

__fzf-la-cd() {
  local selected=$(unbuffer ls -lA --color | rg ^d | awk '{print substr($0,index($0,$9))}' | fzf --ansi --bind='ctrl-o:execute(open {})' --preview "exa -T {}" | xargs echo) 
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
  [[ -n $selected ]] && echo $selected && start_nvim "$selected"
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
      local DIR_SELECT_MODE=$(echo -e "CURRENT_DIR\nz\ntree" | fzf --preview "")
      if [[ $DIR_SELECT_MODE == 'z' ]];then
          local TARGET_DIR="$(__cd-well | sort | uniq | fzf | sed 's/^[0-9,.]* *//')"
      fi
      if [[ $DIR_SELECT_MODE == 'tree' ]];then
          local DEPTH=$([ -z $1 ] && echo 9 || echo $1)
          local TARGET_DIR=$(tree -i -d -n -N -L $DEPTH -f -d -a -I node_modules -I .git | fzf)
      fi
      if [[ $DIR_SELECT_MODE == 'CURRENT_DIR' ]];then
          local TARGET_DIR="$PWD/$(unbuffer ls -la --color | rg ^d | awk '{print substr($0,index($0,$9))}' | fzf --ansi --preview "exa -T {}")"
      fi
      echo -e "== TARGET DIR IS:\n$TARGET_DIR"
      echo -e "== SOURCE FILE IS:\n$SELECTED"
      if [ -n "$ZSH_VERSION" ]; then
          read "OK?(ctrl-c OR enter)"
      else
          read -p "OK?(ctrl-c OR enter)"
      fi
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
      local DIR_SELECT_MODE=$(echo -e "CURRENT_DIR\nz\ntree\nDropbox\nHome" | fzf --preview "")
      if [[ $DIR_SELECT_MODE == 'z' ]];then
          local TARGET_DIR="$(__cd-well | sort | uniq | fzf | sed 's/^[0-9,.]* *//')"
      fi
      if [[ $DIR_SELECT_MODE == 'tree' ]];then
          local DEPTH=$([ -z $1 ] && echo 9 || echo $1)
          local TARGET_DIR=$(tree -i -d -n -N -L $DEPTH -f -a -I node_modules -I .git | fzf)
      fi
      if [[ $DIR_SELECT_MODE == 'CURRENT_DIR' ]];then
          local TARGET_DIR="$PWD/$(unbuffer ls -la --color | rg ^d | awk '{print substr($0,index($0,$9))}' | fzf --ansi --preview "exa -T {}")"
      fi
      if [[ $DIR_SELECT_MODE == 'Dropbox' ]];then
          local DEPTH=$([ -z $1 ] && echo 9 || echo $1)
          local TARGET_DIR=$(tree -i -d -n -N -L $DEPTH -f -a -I node_modules -I .git $HOME/Dropbox| fzf)
      fi
      if [[ $DIR_SELECT_MODE == 'Home' ]];then
          local DEPTH=$([ -z $1 ] && echo 9 || echo $1)
          local TARGET_DIR=$(tree -i -d -n -N -L $DEPTH -f -I node_modules -I .git -I Applications -I Library $HOME | fzf)
      fi
      echo -e "== TARGET DIR IS:\n$TARGET_DIR"
      echo -e "== SOURCE FILE IS:\n$SELECTED"
      if [ -n "$ZSH_VERSION" ]; then
          read "OK?(ctrl-c OR enter)"
      else
          read -p "OK?(ctrl-c OR enter)"
      fi
      echo "${SELECTED}" | gxargs -d\\n -I {} gmv -i -v {} -t "$TARGET_DIR"
  fi
}

__fzf-open-app(){
    local popup="$HOME/bin/func/fzf-tmux-popup.sh"
    local app=$(find /Applications -name "*.app" -type d -maxdepth 2 | sed 's|/Applications/||' | "$popup")
    [[ -n "$app" ]] && open -a "/Applications/$app"
}


__fzf-open-code-workspace(){
    local workspace=$(ls -1 $HOME/dev | fzf)
    [ -n "$workspace" ] && open $HOME/dev/$workspace
}

# bookmarks.sh - source from .zshrc
__fzf-bookmarks() {
  local file="$HOME/src/github.com/t-akira012/prv/README.md"
  local popup="$HOME/bin/func/fzf-tmux-popup.sh"
  if [[ -e $file ]]; then
      local tmp_data=$(mktemp)
      sed -n 's/.*\[\([^]]*\)\](\([^)]*\)).*/\2\t\1/p' "$file" > "$tmp_data"
      local selected
      selected=$(awk -F'\t' '{printf "%-40.40s  %.70s\n", $1, $2}' "$tmp_data" | "$popup")
      if [[ -n "$selected" ]]; then
        local line=$(grep -nF "$selected" <(awk -F'\t' '{printf "%-40.40s  %.70s\n", $1, $2}' "$tmp_data") | head -1 | cut -d: -f1)
        local url=$(sed -n "${line}p" "$tmp_data" | cut -f1)
        open "$url"
      fi
      rm -f "$tmp_data"
  else
      echo 'bookmark file is notfound.'
  fi
}

__fzf-firefox-history() {
  local profile_dir="$HOME/Library/Application Support/zen/Profiles"
  local popup="$HOME/bin/func/fzf-tmux-popup.sh"
  local dbs=("${(@f)$(find "$profile_dir" -name "places.sqlite" 2>/dev/null)}")
  [[ ${#dbs[@]} -eq 0 ]] && echo "places.sqlite not found" && return 1
  local tmp=$(mktemp)
  local selected
  local tmp_data=$(mktemp)
  {
    for db in "${dbs[@]}"; do
      command cp "$db" "$tmp"
      sqlite3 "$tmp" "SELECT p.title, p.url FROM moz_places p INNER JOIN moz_historyvisits v ON p.id = v.place_id ORDER BY v.visit_date DESC LIMIT 5000;" -separator $'\t'
    done
  } | awk -F'\t' '!seen[$2]++' > "$tmp_data"
  local selected
  selected=$(awk -F'\t' '{printf "%-40.40s  %.70s\n", $2, $1}' "$tmp_data" | "$popup")
  if [[ -n "$selected" ]]; then
    local line=$(grep -nF "$selected" <(awk -F'\t' '{printf "%-40.40s  %.70s\n", $2, $1}' "$tmp_data") | head -1 | cut -d: -f1)
    local url=$(sed -n "${line}p" "$tmp_data" | cut -f2)
    open "$url"
  fi
  rm -f "$tmp" "$tmp_data"
}

__fzf-search() {
  local query="$*"
  local popup="$HOME/bin/func/fzf-tmux-popup.sh"
  if [[ -z "$query" ]]; then
    query=$("$popup" --input "Search: ")
    [[ -z "$query" ]] && return 1
  fi
  local tmp_data=$(mktemp)
  "$HOME/bin/func/curlDuckduckgo.sh" "$query" > "$tmp_data"
  local selected
  selected=$(awk -F'\t' '{printf "%-40.40s  %.70s\n", $1, $2}' "$tmp_data" | "$popup")
  if [[ -n "$selected" ]]; then
    local line=$(grep -nF "$selected" <(awk -F'\t' '{printf "%-40.40s  %.70s\n", $1, $2}' "$tmp_data") | head -1 | cut -d: -f1)
    local url=$(sed -n "${line}p" "$tmp_data" | cut -f1)
    open "$url"
  fi
  rm -f "$tmp_data"
}
alias s='__fzf-search'


alias h='__fzf-firefox-history'
alias b='__fzf-bookmarks'
alias o='__fzf-open'
alias a='__fzf-open-app'
# replace zoxide
# alias z='__fzf-z-cd'
alias l='__fzf-la-cd'
alias vz='__fzf-find-vi'
alias tf='__fzf-tree'
alias ghqw='__fzf-ghq-web'
alias cdg='ghq-cd'
alias fnamecopy='__fzf-filename-copy'
alias mmv='__fzf-multi-move'
alias mcp='__fzf-multi-copy'
alias dev='__fzf-open-code-workspace'
