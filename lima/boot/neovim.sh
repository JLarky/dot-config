#!/bin/bash

set -eux -o pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
nvim_config="$HOME/.config/nvim"
plug_vim="$HOME/.local/share/nvim/site/autoload/plug.vim"

if ! command -v mise >/dev/null; then
  echo "mise is required; run lima/boot/mise.sh first" >&2
  exit 1
fi

sudo apt update -y
sudo apt install -y curl git

mise use -g node@lts
mise use -g neovim@latest
eval "$(mise activate bash)"

mkdir -p "$(dirname "$plug_vim")"
curl -fLo "$plug_vim" --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p "$HOME/.config"
if [ -e "$nvim_config" ] && [ ! -L "$nvim_config" ]; then
  backup_config="$nvim_config.backup.$(date +%Y%m%d%H%M%S)"
  mv "$nvim_config" "$backup_config"
  echo "Moved existing nvim config to $backup_config"
fi
ln -sfn "$repo_root/nvim" "$nvim_config"

nvim --headless '+PlugInstall --sync' +qa

echo 'All done. Run :Copilot setup inside nvim to authenticate GitHub Copilot.'
