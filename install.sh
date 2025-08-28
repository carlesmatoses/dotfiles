#!/usr/bin/env bash
set -e

echo "=== Installing modules for Hyprland setup ==="

# Update system
sudo pacman -Syu --noconfirm

# 1. Install Kvantum (Qt theming engine)
echo "-> Installing Kvantum..."
sudo pacman -S --needed --noconfirm kvantum

# 2. Install Waybar (status bar for Wayland compositors)
echo "-> Installing Waybar..."
sudo pacman -S --needed --noconfirm waybar

# 3. Install JetBrainsMono Nerd Font
echo "-> Installing JetBrainsMono Nerd Font..."
sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd

# 4. Install qt5ct and qt6ct (Qt configuration tools)s
echo "-> Installing qt5ct and qt6ct..."
sudo pacman -S --needed --noconfirm qt5ct qt6ct

# 5. Install Zsh
echo "-> Installing Zsh..."
sudo pacman -S --needed --noconfirm zsh

# 6. Install Oh My Zsh
echo "-> Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh already installed."
fi

# 7. Install Starship prompt
echo "-> Installing Starship..."
sudo pacman -S --needed --noconfirm starship

# 8. Install PDF reader
sudo pacman -S --needed --noconfirm sioyek

# 9. App editor
sudo pacman -S --needed --noconfirm menulibre

echo "✅ All modules installed successfully!"
