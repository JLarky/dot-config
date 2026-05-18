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
  echo "$nvim_config exists and is not a symlink; move it aside before running this script" >&2
  exit 1
fi
ln -sfn "$repo_root/nvim" "$nvim_config"

nvim --headless '+PlugInstall --sync' +qa

echo 'All done. Run :Copilot setup inside nvim to authenticate GitHub Copilot.'
