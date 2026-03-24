__query-urls() {
  [[ ! -f "$URLS_MD" ]] && return
  awk '
  {
    lines[NR] = $0
  }
  END {
    printf "[\n"
    first = 1
    for (i = 1; i <= NR; i++) {
      if (lines[i] !~ /^https?:\/\//) continue
      url = lines[i]
      title = ""
      prev = (i > 1) ? lines[i-1] : ""
      nxt  = (i < NR) ? lines[i+1] : ""
      if (prev != "" && prev !~ /^# [0-9]/ && prev !~ /^https?:\/\// && prev !~ /^>/ && prev !~ /^[[:space:]]*$/) {
        title = prev
      } else if (nxt != "" && nxt !~ /^# [0-9]/ && nxt !~ /^https?:\/\// && nxt !~ /^>/ && nxt !~ /^[[:space:]]*$/) {
        title = nxt
      } else {
        title = url
      }
      gsub(/"/, "\\\"", title)
      gsub(/"/, "\\\"", url)
      if (!first) printf ",\n"
      printf "  {\"url\":\"%s\",\"title\":\"%s\"}", url, title
      first = 0
    }
    printf "\n]\n"
  }' "$URLS_MD" | jq -r '.[] | .url + "\t" + .title + "\t\t\t" + .url'
}

__action-urls() {
  "${BROWSER:-open}" "$(echo "$1" | awk -F'\t' '{print $NF}')"
}

__omni-fzf-urls() {
  local popup="$HOME/bin/omni/popup.sh"
  local fzf_opts="--with-nth=2..5 --delimiter=$'\t' --query=$*"
  local selected
  selected=$(__query-urls | sed 's/^/_\t/' | __omni-engine-format | "$popup" $fzf_opts)
  [[ -n "$selected" ]] && __action-urls "$selected"
}
alias u='__omni-fzf-urls'
