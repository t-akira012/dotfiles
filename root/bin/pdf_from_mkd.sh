#!/bin/bash

check_weasyprint() {
  if ! command -v weasyprint > /dev/null 2>&1; then
    echo "ERROR: weasyprint が見つかりません" >&2
    echo "brew install weasyprint" >&2
    exit 1
  fi
}

check_pandoc() {
  if ! command -v pandoc > /dev/null 2>&1; then
    echo "ERROR: pandoc が見つかりません" >&2
    echo "brew install pandoc" >&2
    exit 1
  fi
}

main() {
  check_pandoc
  check_weasyprint

  local input_file="${1}"
  local output_file="${input_file%.md}.pdf"

  if [ -z "${input_file}" ]; then
    echo "Usage: $0 <input.md>" >&2
    exit 1
  fi

  pandoc "${input_file}" -o "${output_file}" --pdf-engine=weasyprint --css=<(cat <<'EOF'
body {
  font-family: "Hiragino Sans", sans-serif;
  font-size: 10pt;
  line-height: 1.8;
}
code, pre {
  font-family: "PlemolJP Console", monospace;
  font-size: 9pt;
}
pre {
  background: #f5f5f5;
  padding: 0.8em;
}
img {
  max-width: 100%;
  height: auto;
}
EOF
  )

  echo "${output_file}"
}

main "$@"
