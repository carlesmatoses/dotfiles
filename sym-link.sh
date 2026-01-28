#!/bin/bash

# Ensure the config directory exists
mkdir -p ~/.config

# Hyprland
rm -rf ~/.config/hypr
ln -sf ~/github/dotfiles/.config/hypr ~/.config/hypr

# Waybar
rm -rf ~/.config/waybar
ln -sf ~/github/dotfiles/.config/waybar ~/.config/waybar

# Kdeglobals
mkdir -p ~/.config/kdeglobals
rm -f ~/.config/kdeglobals/kdeglobals
ln -sf ~/github/dotfiles/.config/kdeglobals/kdeglobals ~/.config/kdeglobals

# GTK
rm -rf ~/.config/gtk-3.0
ln -sf ~/github/dotfiles/.config/gtk-3.0 ~/.config/gtk-3.0
rm -rf ~/.config/gtk-4.0
ln -sf ~/github/dotfiles/.config/gtk-4.0 ~/.config/gtk-4.0

# QT ct
rm -rf ~/.config/qt6ct
ln -sf ~/github/dotfiles/.config/qt6ct ~/.config/qt6ct
rm -rf ~/.config/qt5ct
ln -sf ~/github/dotfiles/.config/qt5ct ~/.config/qt5ct

# Kvantum
rm -rf ~/.config/Kvantum
ln -sf ~/github/dotfiles/.config/Kvantum ~/.config/Kvantum

# -Wofi style
mkdir -p ~/.config/wofi
rm -f ~/.config/wofi/style.css
ln -sf ~/github/dotfiles/.config/wofi/style.css ~/.config/wofi/style.css
rm -f ~/.config/wofi/config
ln -sf ~/github/dotfiles/.config/wofi/config ~/.config/wofi/config
rm -f ~/.config/wofi/wofi-power-menu.toml
ln -sf ~/github/dotfiles/.config/wofi/wofi-power-menu.toml ~/.config/wofi/wofi-power-menu.toml
rm -f ~/.config/wofi-power-menu.toml
ln -sf ~/github/dotfiles/.config/wofi/wofi-power-menu.toml ~/.config/wofi-power-menu.toml

# Rofi
rm -rf ~/.config/rofi
ln -sf ~/github/dotfiles/.config/rofi ~/.config/rofi

# Starship
rm -f ~/.config/starship.toml
ln -sf ~/github/dotfiles/.config/starship.toml ~/.config/starship.toml

# Zsh
rm -f ~/.zshrc
ln -sf ~/github/dotfiles/.zshrc ~/.zshrc

# Btop
mkdir -p ~/.config/btop
rm -f ~/.config/btop/btoprc
ln -sf ~/github/dotfiles/.config/btop/btoprc ~/.config/btop/btoprc

# Kitty
mkdir -p ~/.config/kitty
rm -f ~/.config/kitty/kitty.conf
ln -sf ~/github/dotfiles/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf

# wlogout
rm -rf ~/.config/wlogout
ln -sf ~/github/dotfiles/.config/wlogout ~/.config/wlogout

# wal 
rm -rf ~/.config/wal
ln -sf ~/github/dotfiles/.config/wal ~/.config/wal

# Custom Applications
mkdir -p ~/.local/share/applications
rm -f ~/.local/share/applications/7z-2.desktop
ln -sf ~/github/dotfiles/.config/applications/7z-2.desktop ~/.local/share/applications/7z-2.desktop
rm -f ~/.local/share/applications/7z.desktop
ln -sf ~/github/dotfiles/.config/applications/7z.desktop ~/.local/share/applications/7z.desktop
rm -f ~/.local/share/applications/calendar.desktop
ln -sf ~/github/dotfiles/.config/applications/calendar.desktop ~/.local/share/applications/calendar.desktop
rm -f ~/.local/share/applications/gmail.desktop
ln -sf ~/github/dotfiles/.config/applications/gmail.desktop ~/.local/share/applications/gmail.desktop
rm -f ~/.local/share/applications/revolut.desktop
ln -sf ~/github/dotfiles/.config/applications/revolut.desktop ~/.local/share/applications/revolut.desktop

echo "All symbolic links created!"
