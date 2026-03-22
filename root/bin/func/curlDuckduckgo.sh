#!/bin/bash
# curlDuckduckgo.sh - DuckDuckGo search via curl, outputs "title\turl" lines
query="$*"
[[ -z "$query" ]] && exit 1
curl -s -X POST "https://html.duckduckgo.com/html/" \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
  -H "Referer: https://html.duckduckgo.com/" \
  -H "Accept: text/html,application/xhtml+xml" \
  -H "Accept-Language: ja,en;q=0.9" \
  -H "DNT: 1" \
  --compressed \
  -d "q=$(printf '%s' "$query" | jq -sRr @uri)&b=&kf=-1&kh=1&kl=jp-jp&kp=-2&k1=-1" \
  | sed -n 's/.*class="result__a" href="\([^"]*\)">\(.*\)<\/a>.*/\1\t\2/p'
