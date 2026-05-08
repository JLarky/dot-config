#!/bin/bash
set -e

vp i -g agent-browser

# Ubuntu 24.04 ARM64 ships only a snap-stub for chromium, which can't be
# driven over CDP. The xtradeb PPA provides a real .deb chromium for noble/arm64.
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:xtradeb/apps
sudo apt-get install -y chromium

# Smoke test: agent-browser open https://example.com
