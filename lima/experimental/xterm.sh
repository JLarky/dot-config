#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"

if [ ! -x /opt/X11/bin/xauth ]; then
  echo "XQuartz is required. Install it from https://www.xquartz.org/"
  exit 1
fi

open -ga XQuartz

ensure_xterm_mode() {
  local instance_json current_vm_type current_arch
  instance_json="$(limactl list --json xterm 2>/dev/null || true)"
  current_vm_type="$(printf '%s' "${instance_json}" | grep -o '"vmType":"[^"]*"' | head -n1 | cut -d'"' -f4)"
  current_arch="$(printf '%s' "${instance_json}" | grep -o '"arch":"[^"]*"' | head -n1 | cut -d'"' -f4)"

  if [ -n "${current_vm_type}" ] && [ "${current_vm_type}" != "vz" ]; then
    cat <<EOF
The existing xterm VM uses ${current_vm_type}/${current_arch}, not vz/aarch64 with Rosetta.

Delete and recreate it once to apply the new VZ/Rosetta config:
  limactl stop xterm
  limactl delete xterm
  ./lima/xterm.sh
EOF
    exit 1
  fi
}

if limactl list --format '{{.Name}}' | grep -qx xterm; then
  ensure_xterm_mode
  limactl start xterm
else
  limactl start --name=xterm xterm.yaml
fi

cat <<'EOF'

The xterm VM is running.

It is configured as an ARM VZ guest with Rosetta for Intel user-space
binaries, so it should be much faster than the full x86_64 QEMU variant.

Launch a Linux GUI app on your Mac display with:
  ./lima/xterm-open.sh

Verify the guest architecture with:
  limactl shell xterm uname -m

Remember: `uname -m` should still be `aarch64` in this mode.

Launch a different X11 app with:
  ./lima/xterm-open.sh xclock

Verify X11 forwarding with:
  ./lima/xterm-open.sh bash -lc 'echo $DISPLAY'

If the wrapper says XQuartz did not publish DISPLAY:
  launchctl getenv DISPLAY
  pkill XQuartz
  open -a XQuartz

If that is still empty:
  1. Log out of macOS and log back in.
  2. Reboot macOS.
EOF
