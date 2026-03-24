# omni entrypoint — source all omni modules
# .zshrc から source "$HOME/bin/omni/entrypoint.sh" で読み込む

# paths
TASK_MD="$HOME/docs/doc/DRAFT.md"
PROJECT_MD="$HOME/docs/doc/DRAFT.md"
URLS_MD="$HOME/docs/doc/urls.md"
__gog_cache_dir="$HOME/.cache/omni/gog-function"
INCLUDE_EXTS=(
  png jpg jpeg gif webp svg bmp ico tiff tif heic heif avif
  mp4 mkv avi mov wmv flv webm m4v mpg mpeg ts
  pdf
)
FIND_FILE_DIRS=(
  "$HOME/Downloads/"
  "$HOME/Documents/"
  "/Volumes/ssd/Dropbox/"
)

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
