#!/bin/bash
set -e

vp i -g agent-browser

# Ubuntu 24.04 ARM64 ships only a snap-stub for chromium, which can't be
# driven over CDP. The xtradeb PPA provides a real .deb chromium for noble/arm64.
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:xtradeb/apps
sudo apt-get install -y chromium

# Even the real .deb chromium still can't launch under agent-browser's
# default sandboxed launch inside this container: Chrome's setuid sandbox
# needs unprivileged user-namespace access that the container/AppArmor
# profile denies, so every launch attempt silently crash-loops (zombie
# [chrome] processes pile up, no CDP connection, the command just hangs
# until timeout). `chromium --no-sandbox` launches fine, so bake that into
# agent-browser's own user config instead of relying on every caller
# remembering to pass `--args --no-sandbox` by hand.
mkdir -p ~/.agent-browser
cat > ~/.agent-browser/config.json <<'EOF'
{
  "executablePath": "/usr/bin/chromium",
  "args": "--no-sandbox"
}
EOF

# Smoke test: agent-browser open https://example.com
