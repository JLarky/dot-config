#!/bin/bash

set -eux -o pipefail

curl -fsSL tailscale.com/install.sh | sh
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y tailscale-nginx-auth
# sudo tailscale set --operator $USER
sudo tailscale up

echo 'All done'
