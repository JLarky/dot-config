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
  ./lima/xterm-open.sh

If `launchctl getenv DISPLAY` is still empty:
  1. Quit and relaunch XQuartz.
  2. Log out of macOS and log back in.
  3. Reboot macOS.
EOF
  exit 1
fi

if limactl list --format '{{.Name}}' | grep -qx xterm; then
  ensure_xterm_mode
  limactl start xterm >/dev/null
else
  limactl start --name=xterm xterm.yaml >/dev/null
fi

if [ "$#" -eq 0 ]; then
  set -- xterm
fi

exec ssh \
  -F "${HOME}/.lima/xterm/ssh.config" \
  -o ForwardX11Timeout=0 \
  lima-xterm \
  "$@"
