#!/usr/bin/env bash
set -euo pipefail

if [[ $(whoami) == 't-akira012' ]];then
  echo 'user is t-akira012'
  exit 1
fi

setup_repo() {
    local codename arch
    codename="$(. /etc/os-release && echo "${VERSION_CODENAME}")"
    arch="$(dpkg --print-architecture)"

    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo "deb [arch=${arch} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${codename} stable" \
        | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

install_docker() {
    sudo apt-get update
    sudo apt-get install -y \
        docker-ce docker-ce-cli containerd.io \
        docker-buildx-plugin docker-compose-plugin
}

setup_user() {
    sudo usermod -aG docker "${USER}"
}

main() {
    setup_repo
    install_docker
    setup_user
}

main "$@"

# 実行後の動作確認手順
#
# 1. docker デーモン起動
#    systemd 有効環境: sudo systemctl enable --now docker
#    systemd 無効環境 (WSL2 デフォルト): sudo service docker start
#
# 2. docker グループ反映 (以下いずれか)
#    - ログアウトして再ログイン
#    - newgrp docker
#
# 3. CLI 疎通確認
#    docker version            # Client/Server 両方表示されれば daemon と通信成功
#    docker compose version    # compose plugin 確認
#    docker buildx version     # buildx plugin 確認
#
# 4. コンテナ実行確認
#    docker run --rm hello-world
#
# 5. 失敗時の切り分け
#    sudo systemctl status docker   または   sudo service docker status
#    sudo journalctl -u docker --no-pager -n 50
#    /var/run/docker.sock の権限確認 (ls -l /var/run/docker.sock)
