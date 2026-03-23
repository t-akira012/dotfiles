#!/bin/bash
# curlDuckduckgo.sh - DuckDuckGo lite search via curl, outputs "url\ttitle" lines
query="$*"
[[ -z "$query" ]] && exit 1
curl -s -X POST "https://lite.duckduckgo.com/lite/" \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
  -H "Referer: https://lite.duckduckgo.com/" \
  -H "Accept: text/html,application/xhtml+xml" \
  -H "Accept-Language: ja,en;q=0.9" \
  -H "DNT: 1" \
  --compressed \
  -d "q=$(printf '%s' "$query" | jq -sRr @uri)&kl=jp-jp" \
  | sed -n "s/.*href=\"\([^\"]*\)\" class='result-link'>\(.*\)<\/a>.*/\1\t\2/p" \
  | grep -v 'duckduckgo.com/y.js'
