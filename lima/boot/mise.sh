sudo apt update -y && sudo apt install -y curl
sudo install -dm 755 /etc/apt/keyrings
curl -fSs https://mise.jdx.dev/gpg-key.pub | sudo tee /etc/apt/keyrings/mise-archive-keyring.asc 1> /dev/null
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.asc] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
sudo apt update -y
sudo apt install -y mise

# activate if "mise activate" is not in the .bashrc
if ! grep -q "mise activate" ~/.bashrc; then
  echo 'eval "$(/usr/bin/mise activate bash)"' >> ~/.bashrc
fi

# autocompletion
sudo apt install -y bash-completion
mkdir -p ~/.local/share/bash-completion/completions/
mise completion bash --include-bash-completion-lib > ~/.local/share/bash-completion/completions/mise
mise use -g usage
