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

# 6.1. Install Oh My Zsh plugins
echo "-> Installing Oh My Zsh plugins..."
# Create custom plugins directory if it doesn't exist
mkdir -p "$HOME/.oh-my-zsh/custom/plugins"

# Clone zsh-autosuggestions
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
else
    echo "zsh-autosuggestions already installed."
fi

# Clone zsh-syntax-highlighting
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting already installed."
fi

# Clone zsh-completions
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-completions "$HOME/.oh-my-zsh/custom/plugins/zsh-completions"
else
    echo "zsh-completions already installed."
fi

# 7. Install Starship prompt
echo "-> Installing Starship..."
sudo pacman -S --needed --noconfirm starship

# 8. Install PDF reader
sudo pacman -S --needed --noconfirm sioyek

# 9. Install Rofi (application launcher/window switcher)
echo "-> Installing Rofi..."
sudo pacman -S --needed --noconfirm rofi

# 10. Install NetworkManager (network controller)
echo "-> Installing NetworkManager..."
sudo pacman -S --needed --noconfirm networkmanager networkmanager-applet
sudo systemctl enable NetworkManager

# 11. Install PipeWire (audio controller)
echo "-> Installing PipeWire..."
sudo pacman -S --needed --noconfirm pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber rtkit

# Remove conflicting PulseAudio if installed
if pacman -Qs pulseaudio > /dev/null; then
    echo "-> Removing conflicting PulseAudio packages..."
    sudo pacman -Rdd --noconfirm pulseaudio pulseaudio-alsa 2>/dev/null || true
fi

# Remove conflicting JACK if installed
if pacman -Qs jack2 > /dev/null; then
    echo "-> Removing conflicting JACK packages..."
    sudo pacman -Rdd --noconfirm jack2 2>/dev/null || true
fi

# Enable PipeWire services
echo "-> Enabling PipeWire services..."
systemctl --user enable pipewire pipewire-pulse wireplumber

# Mask PulseAudio to prevent conflicts
systemctl --user mask pulseaudio.service pulseaudio.socket 2>/dev/null || true

# Start PipeWire services immediately
echo "-> Starting PipeWire services..."
systemctl --user start pipewire pipewire-pulse wireplumber

# 12. Install Visual Studio Code
echo "-> Installing Visual Studio Code..."
sudo pacman -S --needed --noconfirm code

# 13. Install Neovim
echo "-> Installing Neovim..."
sudo pacman -S --needed --noconfirm neovim

# 14. Detect NVIDIA graphics and install driver if present
if lspci | grep -i 'nvidia' >/dev/null; then
    echo "-> NVIDIA graphics detected. Installing NVIDIA driver..."
    paru -S --needed --noconfirm nvidia
else
    echo "No NVIDIA graphics detected."
fi

# 15. Install wlogout (Wayland logout dialog)
# echo "-> Installing wlogout..."
# sudo pacman -S --needed --noconfirm wlogout

# 16. Install pavucontrol (PulseAudio volume control)
echo "-> Installing pavucontrol..."
sudo pacman -S --needed --noconfirm pavucontrol

# 17. Install Hyprpaper (wallpaper utility for Hyprland)
echo "-> Installing Hyprpaper..."
sudo pacman -S --needed --noconfirm hyprpaper

# 18. Install Paru (AUR helper)
if ! command -v paru &> /dev/null; then
    echo "-> Installing Paru (AUR helper)..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/paru
else
    echo "Paru is already installed."
fi

# 19. Install python-pywal (color scheme generator)
echo "-> Installing python-pywal..."
paru -S --needed --noconfirm python-pywal

echo "✅ All modules installed successfully!"
