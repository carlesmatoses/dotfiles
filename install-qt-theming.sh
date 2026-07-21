#!/usr/bin/env bash
set -e

echo "=== Installing Qt Theming Components ==="

# 1. Install Kvantum (Qt theming engine)
echo "-> Installing Kvantum..."
sudo pacman -S --needed --noconfirm kvantum

# 2. Install qt5ct and qt6ct (Qt configuration tools)
echo "-> Installing qt5ct and qt6ct..."
sudo pacman -S --needed --noconfirm qt5ct qt6ct

# 3. Install Qt Wayland support
echo "-> Installing Qt Wayland support..."
sudo pacman -S --needed --noconfirm qt5-wayland qt6-wayland

echo "-> Linking Kvantum configuration..."
rm -rf ~/.config/Kvantum
ln -sf ~/github/dotfiles/.config/Kvantum ~/.config/Kvantum

echo "-> Linking qt5ct/qt6ct configuration..."
rm -rf ~/.config/qt5ct
ln -sf ~/github/dotfiles/.config/qt5ct ~/.config/qt5ct
rm -rf ~/.config/qt6ct
ln -sf ~/github/dotfiles/.config/qt6ct ~/.config/qt6ct

echo "-> Linking kdeglobals..."
rm -rf ~/.config/kdeglobals
ln -sf ~/github/dotfiles/.config/kdeglobals/kdeglobals ~/.config/kdeglobals

echo "✅ Qt theming components installed successfully!"
