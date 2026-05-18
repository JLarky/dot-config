# Lima

Create `~/vm` directory.

```bash
mkdir -p ~/vm/JLarky
```

Clone this repo into it

```bash
cd ~/vm/JLarky
git clone https://github.com/JLarky/dot-config.git
```

Create `mine` VM for the first time.

```bash
cd dot-config
bash lima/provision.sh
```

Clone `mine` VM to `default` every time you want to start from scratch.

```bash
limactl stop mine; limactl stop default; limactl delete default; limactl clone mine default
```

Install stuff into the VM.

```bash
cd ~/vm/JLarky/dot-config
lima sudo apt-get install tig unzip
lima ./lima/boot/mise.sh
lima ./lima/boot/neovim.sh
lima ./lima/boot/viteplus.sh
lima ./lima/boot/claude.sh
lima ./lima/boot/gh-cli.sh # interactive
lima ./lima/boot/chezmoi.sh
lima ./lima/boot/tailscale.sh # interactive
```

`lima/boot/neovim.sh` preserves an existing `~/.config/nvim` by moving it to
`~/.config/nvim.backup.YYYYMMDDHHMMSS` before linking this repo's config.
