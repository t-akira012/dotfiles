__omni-autofetch-today-calendar() {
  __gog_fetch-today-calendar
}

__omni-autofetch-today-tasks() {
  __gog_fetch-today-tasks
}

__omni-autofetch-run() {
  local cache_file="$HOME/.cache/omni/unixtime"
  local now=$(date +%s)
  local last=0

  [[ -f "$cache_file" ]] && last=$(<"$cache_file")

  if (( now - last >= 3600 )); then
    mkdir -p "${cache_file%/*}"
    echo "$now" > "$cache_file"
    for func in ${(k)functions[(I)__omni-autofetch-*]}; do
      [[ "$func" == "__omni-autofetch-run" ]] && continue
      "$func" &
    done
  fi
}
