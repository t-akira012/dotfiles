alias g='git'
alias gg='git grep --break'
alias gitgraph="git log --color=always --pretty='format:%C(auto)%h%d %C(green)%cd %C(reset)%s %C(cyan)[%an]' --date=iso --graph --date=format:'%Y/%m/%d %a'"
# alias gap='echo "git fetch --all && git pull origin $(git rev-parse --abbrev-ref @)" && git fetch --all && git pull origin $(git rev-parse --abbrev-ref @)'
# alias gpp='echo "git fetch --all --prune && git pull" && git fetch --all --prune && git pull'
alias gcmm='git cmm'
alias gbr='git branch'
alias gst='git status'
alias gdfs='git diff --staged'
alias glo='git log --oneline --graph'
alias gl1='git log --oneline -1 --graph'
alias gl3='git log --oneline -3 --graph'
alias gl5='git log --oneline -5 --graph'
alias gl9='git log --oneline -9 --graph'
alias hb='open $(git remote -v | awk "NR==1 {print \$2}")'
alias ghp='open https://$(git remote -v | awk "NR==1 {print \$2}" | sed "s#.*/##" | sed -e "s/\.git$//")/?version=$(git rev-parse master)'
alias hbr="gitViewWeb"
alias branchname="git rev-parse --abbrev-ref HEAD"
alias gdfc="git diff --cached"
alias gp="git pull"
alias gr="cdGitRoot"

cdGitRoot() {
  local target=$(git rev-parse --show-toplevel)
  [[ -d $target ]] && cd "$target" || echo not git repo
}
getGitRootDir() {
  git rev-parse --show-toplevel
}

gitViewWeb() {
  local url=$(__getGitHttpsUrl)
  local branch=$(git rev-parse --abbrev-ref @)
  open $url/tree/$branch
}

gitCheckoutBranchFile() {
  local b=$(
    git branch -a |
      tr -d " " |
      fzf --height 100% --query="$1" --prompt "CHECKOUT BRANCH>" --preview "git log --color=always {}" |
      head -n 1 |
      sed -e "s/^\*\s*//g" |
      perl -pe "s/remotes\/origin\///g"
  )
  local f=$(rg --files --follow --no-ignore-vcs --hidden -g '!{node_modules/*,.git/*}' | fzf)
  [[ -n $b ]] &&
    [[ -n $f ]] &&
    echo "git checkout $b $f" &&
    git checkout "$b" "$f"
}

gitDiffFzf() {
  local root=$(getGitRootDir)
  local s=$(git diff --name-only | fzf --preview "git diff ${root}/{}")
  [[ -n $s ]] &&
    git diff "${root}/$s"
}

# https://gist.github.com/junegunn/f4fca918e937e6bf5bad#gistcomment-2731105
gitLog() {
  gitgraph |
    fzf --ansi --no-sort --reverse --tiebreak=index --preview \
      'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' \
      --bind "j:down,k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort,ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF" --preview-window=down:60%
}

gitHist() {
  [[ -n $1 ]] &&
    gitgraph "$1" |
    fzf --ansi --no-sort --reverse --tiebreak=index --preview \
      'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' \
      --bind "j:down,k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort,ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show %:$1 | less -R') << 'FZF-EOF'
                {}
FZF-EOF" --preview-window=down:60%
}

gitCheckOut() {
  local s=$(
    git branch -a |
      tr -d " " |
      fzf --height 100% --query="$1" --prompt "CHECKOUT BRANCH>" --preview "git log --color=always {}" |
      head -n 1 |
      sed -e "s/^\*\s*//g" |
      perl -pe "s/remotes\/origin\///g"
  )
  [[ "$s" ]] && git checkout $s
}

gitBranchDelete() {
  local s=$(
    git branch -a |
      tr -d " " |
      fzf --height 100% --query="$1" --prompt "DELETE BRANCH>" --preview "git log --color=always {}" |
      head -n 1 |
      sed -e "s/^\*\s*//g" |
      perl -pe "s/remotes\/origin\///g"
  )
  [[ "$s" ]] && git branch -D $s
}

gitRemoteDiff() {
  echo "## remote"
  git log $(git remote)/$(git branch --show-current) --oneline -n 3
  echo "## local"
  git log --oneline -n 3
  echo "## diff"
  git diff HEAD..$(git remote)/$(git branch --show-current)
}

gitCopyRepoName() {
  basename $PWD | pbcopy
  pbpaste
}
gitCopyBranchName() {
  # pbpaste
  git rev-parse --abbrev-ref HEAD | pbcopy
  pbpaste
}

gitOpenIssue() {
  # gh command wrap to fzf
  local s=$(unbuffer gh issue list -L 99 | tail -n +4 | fzf --ansi --preview "" | awk '{print $1}' | sed 's/#//')
  [[ -n $s ]] && gh issue view "$s"
  read "?Enter or C-c"
  gh issue view --web "$s"
  # for bash && read -p "show comments?(Enter or C-c)>" && gh issue view "$s" --comments
}

gitOpenPr() {
  # gh command wrap to fzf
  local s=$(unbuffer gh pr list -L 99 | tail -n +4 | fzf --ansi --preview "" | awk '{print $1}' | sed 's/#//')
  [[ -n $s ]] && gh pr view "$s"
  read "?Enter or C-c"
  gh pr view --web "$s"
  # for bash && read -p "show comments?(Enter or C-c)>" && gh pr view "$s" --comments
}

gitOpenRepo() {
  local s=$(unbuffer gh repo list $1 -L 999 | tail -n +4 | fzf --ansi --preview "" | awk '{print $1}')
  [[ -n $s ]] && gh repo view "$s"
}

gitDiff() {
  local s1=$(gitgraph $1 |
    fzf --ansi --no-sort --reverse --tiebreak=index --preview 'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' --preview-window=down:60% | __getGitShortHash)
  [[ -z $s1 ]] && return
  echo $s1
  local s2=$(gitgraph $1 |
    fzf --ansi --no-sort --reverse --tiebreak=index --preview 'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' --preview-window=down:60% | __getGitShortHash)
  echo $s2
  git diff $s1...$s2
}

gitBlob() {
  [[ -n $1 ]] && local file="$1" || local file="."
  local hash=$(gitgraph "$file" |
    fzf --ansi --no-sort --reverse --tiebreak=index --preview 'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' --preview-window=down:60% | __getGitShortHash)
  if [[ -n $hash ]]; then
    local httpsUrl=$(__getGitHttpsUrl)
    local prefix=$(__getGitPrefix)
    local fileUrl="$httpsUrl/$([[ $file == "." ]] && echo tree || echo blob)/$hash/$prefix$file"
    open "$fileUrl"
  fi
}

gitAdd() {
  local selected=$(unbuffer git -C $(getGitRootDir) status -s | fzf --ansi --preview="git diff --color $(echo {} | awk '{print $2}')" | awk '{print substr($0,index($0,$2))}')
  if [[ -n $selected ]]; then
    git -C $(getGitRootDir) add "$selected"
    echo "git add $selected"
  fi
}
gitStash() {
  local selected
  selected=$(git stash list | fzf --preview="echo {} | awk '{print \$1}' | tr -d ':' | xargs git diff --color" | awk '{print $1}' | tr -d ':')
  if [[ -n $selected ]]; then
    git stash apply "$selected"
    echo "git stash $selected"
  fi
}

__getGitShortHash() {
  grep -o '[a-f0-9]\{7\}' | head -n 1

}
__getGitRemoteUrl() {
  git remote -vv | awk '{print $2}' | head -n 1
}

__getGitHttpsUrl() {
  __generateGitHttpsUrl "$(__getGitRemoteUrl)"
}

__getGitPrefix() {
  local root=$(getGitRootDir)
  local prefix=$(git rev-parse --show-prefix)
  echo $(echo $prefix | sed 's/${root}//')
}

__generateGitHttpsUrl() {
  local URL="$1"
  if [[ ${URL:0:5} != "https" ]]; then
    local repoName=$(echo "$URL" | awk -F"[:/]" '{print $(NF -1)"/"$(NF)}' | sed 's/.git$//')
    local httpsUrl="https://github.com/$repoName"
    echo "$httpsUrl"
  else
    echo "$URL"
  fi
}

dupulicate-repo() {
  local TMP=$HOME/tgit
  local REMOTE=$(git remote -vv | awk '{print $2}' | head -n 1)
  local REPO_NAME=$(basename $PWD)
  echo $REMOTE

  if [[ ! -d $TMP ]]; then
    mkdir $TMP
  fi
  if [[ -d $TMP/$REPO_NAME ]]; then
    echo $REPO_NAME is exist.
  else
    cd $TMP
    git clone $REMOTE
    ls -la $TMP
  fi
  cd $TMP
}

purge-git-branches() {
  echo === リモートブランチに存在しないブランチをすべて削除
  git fetch -p && git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -D
}

alias cdtgit='cd $HOME/tgit'
alias dup-repo='dupulicate-repo'

alias gdf='gitDiffFzf'
alias gad='gitAdd'
alias gsta='gitStash'
alias glog='gitLog'
alias ghist='gitHist'
alias gco="gitCheckOut"
alias gbrd="gitBranchDelete"
alias giss="gitOpenIssue"
alias gpr="gitOpenPr"
alias grepo="gitOpenRepo"
alias gb="gitBlob"
alias gd="gitDiff"
