#!/bin/bash
set -e

# Install agent-browser CLI globally
vp i -g agent-browser

# Ubuntu 24.04 ARM64 only ships a snap-stub for chromium, and snap chromium
# can't be driven over CDP (sandbox confinement breaks programmatic launch).
# The xtradeb PPA provides a real .deb chromium for noble/arm64.
sudo add-apt-repository -y ppa:xtradeb/apps
sudo apt-get update
sudo apt-get install -y chromium

# Point agent-browser at the native chromium by default.
mkdir -p ~/.agent-browser
cat > ~/.agent-browser/config.json <<'EOF'
{
  "executablePath": "/usr/bin/chromium"
}
EOF

# Smoke test: agent-browser open https://example.com
