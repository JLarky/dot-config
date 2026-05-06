#!/bin/bash

# Docker CE + Compose plugin from Docker's official apt repository.

set -eux -o pipefail

sudo install -dm 755 /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/docker.asc ]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
  sudo chmod a+r /etc/apt/keyrings/docker.asc
fi

. /etc/os-release
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $VERSION_CODENAME stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

# Run docker without sudo (takes effect on next login)
sudo usermod -aG docker "$USER"

echo 'All done. Log out/in (or run: newgrp docker) to use docker without sudo.'
