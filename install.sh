#!/bin/bash
# filepath: /srv/dotfiles/install.sh

set -e

echo "Starting dotfiles installation..."

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Make scripts executable
chmod +x "$DOTFILES_DIR/install-zsh.sh"
chmod +x "$DOTFILES_DIR/install-neovim.sh"

# Install Zsh first (since it's the shell)
echo "=== Installing Zsh ==="
./install-zsh.sh

# Install Neovim
echo "=== Installing Neovim ==="
./install-neovim.sh

# Install Kickstart.nvim configuration
echo "=== Installing Kickstart.nvim configuration ==="
if [ -d "$HOME/.config/nvim" ]; then
    echo "Backing up existing nvim config to ~/.config/nvim.backup"
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
fi

echo "Cloning Kickstart.nvim to ~/.config/nvim"
git clone https://github.com/nvim-lua/kickstart.nvim.git "$HOME/.config/nvim"


# Create symlinks for config files
echo "=== Creating symlinks for config files ==="

# Backup existing files if they exist
backup_and_link() {
    local source="$1"
    local target="$2"
    
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up existing $target to $target.backup"
        mv "$target" "$target.backup"
    fi
    
    echo "Creating symlink: $target -> $source"
    ln -sf "$source" "$target"
}

# Symlink dotfiles
backup_and_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"


echo "Dotfiles installation completed!"
echo "Kickstart.nvim has been installed to ~/.config/nvim"
echo "Run 'nvim' to start using the new configuration"