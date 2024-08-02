#!/bin/bash

set -e

PARENT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
LOG_FILE="$PARENT_DIR/install_log.txt"
cat /dev/null > "$LOG_FILE"

log() {
    echo -e "$1"
    echo -e "$(date): $1" >> "$LOG_FILE"
}

error() {
    log "ERROR: $1" >&2
    exit 1
}

cleanup() {
    log "All done, consider removing the install log. Have a nice day!"
}

command_exists() {
	command -v "$1" &>/dev/null
}

package_exists() {
	dpkg -s "$1" &>/dev/null
}

install_package() {
	if package_exists "$1"; then
		log "Package $1 already installed"
	else
		log "Installing package: $1"
		sudo apt install --yes -qq "$1" || error "Insalling package $1"
	fi
}

cd "$PARENT_DIR"

log "Updating packages..."
sudo apt update -q || error "Failed to update"

log "Installing tools..."
tools=(stow zip xclip zsh bat fzf fd-find git make ninja-build gettext cmake unzip build-essential gawk curl fontconfig tmux ripgrep python3 python3-pip python3-venv lua5.1 liblua5.1-dev)
for tool in "${tools[@]}"; do
    install_package "$tool"
done

log "Stowing the dotfiles"
make || error "Failure to stow files"

if command_exists nvim; then
	log "Neovim is already installed"
else
	log "Installing neovim..."
	git clone https://github.com/neovim/neovim
	cd neovim && make CMAKE_BUILD_TYPE=Release
	cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
	cd "$PARENT_DIR"
	rm -rf neovim
fi

if command_exists gh; then
	log "Github CLI is already installed"
else
	log "Installing Github CLI..."
	(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
		&& sudo mkdir -p -m 755 /etc/apt/keyrings \
		&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
		&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
		&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
		&& sudo apt update \
		&& sudo apt install gh -y
fi

if command_exists lazygit; then
  log "Lazygit already installed"
else
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit*
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
    	log "Oh My Zsh is already installed."
else
	log "Installing ohmyzsh..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
	log "zsh-syntax-highlighting already exists."
else
	log "Installing zsh plugin zsh-syntax-highlighting..."
	git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  rm "$HOME/.zshrc"
fi

if command_exists rustup; then
  log "Rust is alreadu installed"
else
  log "Installing rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

if [ -d "$HOME/.nvm" ]; then
  log "Nvm is already installed"
else
  log "Installing NVM and latest node..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install node
fi

if command_exists go; then
  log "Go is already installed"
else
  log "Installing go"
  DOWNLOAD_URL="https://go.dev/dl/go1.22.5.linux-amd64.tar.gz"
  INSTALL_PATH="/usr/local"
  curl -sSL -o go.tar.gz "$DOWNLOAD_URL"
  sudo tar -C "$INSTALL_PATH" -xzf go.tar.gz
  rm go.tar.gz
fi

cleanup

