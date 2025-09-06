#!/bin/bash

# Ensure the config directory exists
mkdir -p ~/.config

# Hyprland
ln -sf ~/github/dotfiles/.config/hypr ~/.config/hypr

# Waybar
ln -sf ~/github/dotfiles/.config/waybar ~/.config/waybar

# Kdeglobals
ln -sf ~/github/dotfiles/.config/kdeglobals/kdeglobals ~/.config/kdeglobals

# GTK
ln -sf ~/github/dotfiles/.config/gtk-3.0 ~/.config/gtk-3.0
ln -sf ~/github/dotfiles/.config/gtk-4.0 ~/.config/gtk-4.0

# QT ct
ln -sf ~/github/dotfiles/.config/qt6ct ~/.config/qt6ct
ln -sf ~/github/dotfiles/.config/qt5ct ~/.config/qt5ct

# Kvantum
ln -sf ~/github/dotfiles/.config/Kvantum ~/.config/Kvantum

# -Wofi style
ln -sf ~/github/dotfiles/.config/wofi/style.css ~/.config/wofi/style.css
ln -sf ~/github/dotfiles/.config/wofi/config ~/.config/wofi/config
ln -sf ~/github/dotfiles/.config/wofi/wofi-power-menu.toml ~/.config/wofi/wofi-power-menu.toml
ln -sf ~/github/dotfiles/.config/wofi/wofi-power-menu.toml ~/.config/wofi-power-menu.toml

# Rofi
ln -sf ~/github/dotfiles/.config/rofi ~/.config/rofi

# Starship
ln -sf ~/github/dotfiles/.config/starship.toml ~/.config/starship.toml

# Zsh
ln -sf ~/github/dotfiles/.zshrc ~/.zshrc

# Htop
ln -sf ~/github/dotfiles/.config/htop/htoprc ~/.config/htop/htoprc

# Kitty
ln -sf ~/github/dotfiles/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf

# wlogout
ln -sf ~/github/dotfiles/.config/wlogout ~/.config/wlogout

# wal 
ln -sf ~/github/dotfiles/.config/wal ~/.config/wal

echo "All symbolic links created!"
