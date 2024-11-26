#!/usr/bin/env bash
# pre-push

mkdir $HOME/.config/git-hooks
cat EOF<< > $HOME/.config/git-hooks/pre-push
#!/bin/bash

_exec_localhook(){
  GIT_ROOT=$(git rev-parse --show-superproject-working-tree --show-toplevel | head -1)
  HOOK_NAME=$(basename $0)
  LOCAL_HOOK="${GIT_ROOT}/.git/hooks/${HOOK_NAME}"
  if [ -e $LOCAL_HOOK ]; then
    source $LOCAL_HOOK
  fi
}

REMOTE_URL=$(git config --get remote.origin.url)
ALLOW_PUSH_ORGS=(xxx)

echo "========================================================="
for org in "${ALLOW_PUSH_ORGS[@]}"; do
  if [[ $REMOTE_URL == "https://github.com/${org}/"* ]];then
    echo "[Allow push: ${org}"]
    echo "Remote url is $REMOTE_URL"
    echo "========================================================="
    _exec_localhook
    exit 0
  fi
done

echo "[Deny push]"
echo "Remote url is $REMOTE_URL"
exit 1
echo "========================================================="
EOF

chmod +x $HOME/.config/git-hooks/pre-push
git config --global core.hooksPath .config/git-hooks
