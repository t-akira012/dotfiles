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

  local input_file="$1"
  local output_file
  local temp_dir

  if [ -z "${input_file}" ]; then
    echo "Usage: $0 <input.md>" >&2
    exit 1
  fi

  if [ ! -f "${input_file}" ]; then
    echo "ERROR: 入力ファイルが見つかりません: ${input_file}" >&2
    exit 1
  fi

  output_file="$(printf '%s\n' "${input_file}" | sed 's/[.]md$/.pdf/')"

  if temp_dir="$(mktemp -d)"; then
    echo "一時ディレクトリを作成しました: ${temp_dir}"
  else
    echo "ERROR: 一時ディレクトリを作成できませんでした" >&2
    exit 1
  fi

  cat > "${temp_dir}/style.css" <<'EOF'
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

  if ! pandoc "${input_file}" -o "${output_file}" \
      --pdf-engine=weasyprint \
      --css="${temp_dir}/style.css"; then
    rm -rf -- "${temp_dir}"
    return 1
  fi

  rm -rf -- "${temp_dir}"

  echo "${output_file}"
}

main "$@"
