#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"

if [ ! -x /opt/X11/bin/xauth ]; then
  echo "XQuartz is required. Install it from https://www.xquartz.org/"
  exit 1
fi

open -ga XQuartz

ensure_t3code_mode() {
  local instance_json current_vm_type current_arch
  instance_json="$(limactl list --json t3code 2>/dev/null || true)"
  current_vm_type="$(printf '%s' "${instance_json}" | grep -o '"vmType":"[^"]*"' | head -n1 | cut -d'"' -f4)"
  current_arch="$(printf '%s' "${instance_json}" | grep -o '"arch":"[^"]*"' | head -n1 | cut -d'"' -f4)"

  if [ -n "${current_vm_type}" ] && { [ "${current_vm_type}" != "vz" ] || [ "${current_arch}" != "aarch64" ]; }; then
    cat <<EOF
The existing t3code VM uses ${current_vm_type}/${current_arch}, not vz/aarch64 with Rosetta.

Delete and recreate it once to apply the new VZ/Rosetta config:
  limactl stop t3code
  limactl delete t3code
  ./lima/t3code.sh
EOF
    exit 1
  fi
}

has_t3code_instance() {
  limactl list --json t3code >/dev/null 2>&1
}

if has_t3code_instance; then
  ensure_t3code_mode
  limactl start t3code
else
  limactl start --name=t3code t3code.yaml
fi

cat <<'EOF'

The t3code VM is running.

It is configured as an ARM VZ guest with Rosetta for Intel user-space
binaries and provisions the x86_64 runtime libraries needed by T3 Code.

Launch T3 Code on your Mac display with:
  ./lima/t3code-open.sh

Verify the guest architecture with:
  limactl shell t3code uname -m

Remember: `uname -m` should still be `aarch64` in this mode.

Run arbitrary guest commands with:
  ./lima/t3code-open.sh bash -lc 'echo $DISPLAY'
EOF
