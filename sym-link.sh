#!/bin/bash

# Ensure the config directory exists
mkdir -p ~/.config

# Hyprland
ln -sf ~/github/dotfiles/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf

# Waybar
ln -sf ~/github/dotfiles/.config/waybar/config ~/.config/waybar/config
ln -sf ~/github/dotfiles/.config/waybar/style.css ~/.config/waybar/style.css
ln -sf ~/github/dotfiles/.config/waybar/catppuccin.yaml ~/.config/waybar/catppuccin.yaml
ln -sf ~/github/dotfiles/.config/waybar/editorconfig ~/.config/waybar/editorconfig

# -Wofi style
ln -sf ~/github/dotfiles/.config/wofi/style.css ~/.config/wofi/style.css
ln -sf ~/github/dotfiles/.config/wofi/config ~/.config/wofi/config
ln -sf ~/github/dotfiles/.config/wofi/wofi-power-menu.toml ~/.config/wofi/wofi-power-menu.toml
ln -sf ~/github/dotfiles/.config/wofi/wofi-power-menu.toml ~/.config/wofi-power-menu.toml

# Rofi
ln -sf ~/github/dotfiles/.config/rofi/config.rasi ~/.config/rofi/config.rasi

# Starship
ln -sf ~/github/dotfiles/.config/starship.toml ~/.config/starship.toml

# Zsh
ln -sf ~/github/dotfiles/.zshrc ~/.zshrc

# Htop
ln -sf ~/github/dotfiles/.config/htop/htoprc ~/.config/htop/htoprc

# Kitty
ln -sf ~/github/dotfiles/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf

echo "All symbolic links created!"
