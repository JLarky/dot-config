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

for _ in $(seq 1 20); do
  DISPLAY_VALUE="${DISPLAY:-$(launchctl getenv DISPLAY || true)}"
  if [ -n "${DISPLAY_VALUE}" ]; then
    export DISPLAY="${DISPLAY_VALUE}"
    break
  fi
  sleep 1
done

if [ -z "${DISPLAY:-}" ]; then
  cat <<'EOF'
XQuartz did not publish a DISPLAY into this shell.

Open a normal macOS Terminal/iTerm window, start XQuartz once, then retry:
  open -a XQuartz
  ./lima/t3code-open.sh

If `launchctl getenv DISPLAY` is still empty:
  1. Quit and relaunch XQuartz.
  2. Log out of macOS and log back in.
  3. Reboot macOS.
EOF
  exit 1
fi

if has_t3code_instance; then
  ensure_t3code_mode
  limactl start t3code >/dev/null
else
  limactl start --name=t3code t3code.yaml >/dev/null
fi

if [ "$#" -eq 0 ]; then
  set -- t3code
fi

exec ssh \
  -F "${HOME}/.lima/t3code/ssh.config" \
  -o ForwardX11Timeout=0 \
  lima-t3code \
  "$@"
