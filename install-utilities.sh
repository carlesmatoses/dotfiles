#!/usr/bin/env bash
set -e

echo "=== Installing System Utilities ==="

# 1. Install htop (process viewer)
echo "-> Installing htop..."
sudo pacman -S --needed --noconfirm htop

# 2. Install nvtop (GPU process viewer for NVIDIA/AMD/Intel)
echo "-> Installing nvtop (GPU process viewer)..."
sudo pacman -S --needed --noconfirm nvtop

# 3. Install Neofetch (system information tool)
echo "-> Installing Neofetch..."
if command -v paru &> /dev/null; then
    paru -S --needed --noconfirm neofetch
else
    sudo pacman -S --needed --noconfirm neofetch
fi

# 4. Install pavucontrol (audio volume control)
echo "-> Installing pavucontrol..."
sudo pacman -S --needed --noconfirm pavucontrol

# 5. Install rofi-emoji (emoji picker for Rofi)
echo "-> Installing rofi-emoji..."
if command -v paru &> /dev/null; then
    paru -S --needed --noconfirm rofi-emoji
fi

# 6. Install clipse (clipboard manager)
echo "-> Installing clipse (clipboard manager)..."
if command -v paru &> /dev/null; then
    paru -S --needed --noconfirm clipse
fi

echo "✅ System utilities installed successfully!"
