#!/bin/bash
set -euo pipefail

if [[ $(whoami) != 't-akira012' ]];then
  echo 'user is not t-akira012'
  exit 1
fi

DOCKER_DMG_URL="https://desktop.docker.com/mac/main/arm64/Docker.dmg"
INSTALL_USER="$(id -un)"
WORK_DIR="$(mktemp -d)"
DMG_PATH="$WORK_DIR/Docker.dmg"
MOUNT_POINT="$WORK_DIR/mount"

cleanup() {
  if mount | grep -Fq "on $MOUNT_POINT "; then
    hdiutil detach "$MOUNT_POINT" >/dev/null
  fi
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This installer must run on macOS." >&2
  exit 1
fi

if [[ "$(uname -m)" != "arm64" ]]; then
  echo "This installer is for the Apple Silicon Mac mini." >&2
  exit 1
fi

if [[ -d /Applications/Docker.app ]]; then
  echo "Docker Desktop is already installed at /Applications/Docker.app." >&2
  exit 1
fi

echo "Downloading Docker Desktop for Apple Silicon..."
curl --fail --location --progress-bar "$DOCKER_DMG_URL" --output "$DMG_PATH"

mkdir "$MOUNT_POINT"
hdiutil attach "$DMG_PATH" -nobrowse -mountpoint "$MOUNT_POINT" >/dev/null

echo "Installing Docker Desktop..."
sudo "$MOUNT_POINT/Docker.app/Contents/MacOS/install" \
  --accept-license \
  --user "$INSTALL_USER"

echo "Docker Desktop was installed at /Applications/Docker.app."
