#!/usr/bin/env bash
set -eux

brew install docker
brew install colima

# install docker compose
compose_version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | sed -e 's/[^0-9\.]//g' )

curl -SL https://github.com/docker/compose/releases/download/v${compose_version}/docker-compose-darwin-aarch64 -o docker-compose
chmod +x docker-compose
[[ ! -d $HOME/.local/bin ]] && mkdir $HOME/.local/bin
mv docker-compose $HOME/.local/bin/docker-compose

# buildx
BUILDX_VERSION=$(curl -s https://api.github.com/repos/docker/buildx/releases/latest | jq -r .tag_name)
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins/
curl -SL https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.darwin-arm64 -o $DOCKER_CONFIG/cli-plugins/docker-buildx
chmod +x $DOCKER_CONFIG/cli-plugins/docker-buildx

# test
colima start --mount /Users:w --mount /Volumes:w

docker info
docker pull hello-world && docker run hello-world

which docker-compose
docker-compose --version
