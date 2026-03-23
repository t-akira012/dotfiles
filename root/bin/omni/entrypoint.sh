# omni entrypoint — source all omni modules
# .zshrc から source "$HOME/bin/omni/entrypoint.sh" で読み込む

# common
for __f in "$HOME/bin/omni"/common-*.sh; do source "$__f"; done
unset __f

# biz / prv
if [[ "$(whoami)" == "t-akira012" ]]; then
  for __f in "$HOME/bin/omni"/prv-*.sh; do source "$__f"; done
else
  for __f in "$HOME/bin/omni"/biz-*.sh; do source "$__f"; done
fi
unset __f
