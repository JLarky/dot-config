#!/bin/bash

mkdir -p ~/.claude

# add claude cli to path
if ! grep -q "export PATH=\"\$HOME/.local/bin:\$PATH\"" ~/.bashrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

# install claude cli
curl -fsSL https://claude.ai/install.sh | bash

# claude instructions
cat <<EOF >~/.claude/CLAUDE.md
You are running inside a VM and you have access to mise
EOF
