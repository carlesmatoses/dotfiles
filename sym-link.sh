#!/bin/bash

# Ensure the config directory exists
mkdir -p ~/.config

# Hyprland
ln -sf ~/github/dotfiles/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf

# -Wofi style
ln -sf ~/github/dotfiles/.config/wofi/style.css ~/.config/wofi/style.css
ln -sf ~/github/dotfiles/.config/wofi/config ~/.config/wofi/config

# Starship
ln -sf ~/github/dotfiles/.config/starship.toml ~/.config/starship.toml

# Zsh
ln -sf ~/github/dotfiles/.zshrc ~/.zshrc

# Htop
ln -sf ~/github/dotfiles/.config/htop/htoprc ~/.config/htop/htoprc

# Kitty
ln -sf ~/github/dotfiles/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf

echo "All symbolic links created!"
