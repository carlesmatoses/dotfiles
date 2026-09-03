#!/usr/bin/env bash
set -e

echo "=== Installing Hyprland Core Components ==="

# 1. Install Hyprland (Wayland compositor)
echo "-> Installing Hyprland..."
sudo pacman -S --needed --noconfirm hyprland

# 2. Install Waybar (status bar for Wayland compositors)
echo "-> Installing Waybar..."
sudo pacman -S --needed --noconfirm waybar

# 3. Install Hyprpaper (wallpaper utility for Hyprland)
echo "-> Installing Hyprpaper..."
sudo pacman -S --needed --noconfirm hyprpaper

# 4. Install Hyprlock (screen locker for Hyprland)
echo "-> Installing Hyprlock..."
sudo pacman -S --needed --noconfirm hyprlock

echo "-> Linking Hyprland configuration..."
rm -rf ~/.config/hypr
ln -sf ~/github/dotfiles/.config/hypr ~/.config/hypr

# Resolve this machine's monitor config by hostname (falls back to carles-lpt's auto-detect config)
MONITORS_DIR=~/.config/hypr/monitors
DEVICE=$(cat /etc/hostname)
if [ -f "$MONITORS_DIR/$DEVICE.conf" ]; then
    ln -sf "$MONITORS_DIR/$DEVICE.conf" "$MONITORS_DIR/active.conf"
else
    echo "⚠ No monitor config found for device '$DEVICE', falling back to carles-lpt.conf"
    ln -sf "$MONITORS_DIR/carles-lpt.conf" "$MONITORS_DIR/active.conf"
fi

# Resolve this machine's keyboard layout by hostname (falls back to carles-lpt's layout)
KEYBOARD_DIR=~/.config/hypr/keyboard
if [ -f "$KEYBOARD_DIR/$DEVICE.conf" ]; then
    ln -sf "$KEYBOARD_DIR/$DEVICE.conf" "$KEYBOARD_DIR/active.conf"
else
    echo "⚠ No keyboard config found for device '$DEVICE', falling back to carles-lpt.conf"
    ln -sf "$KEYBOARD_DIR/carles-lpt.conf" "$KEYBOARD_DIR/active.conf"
fi

echo "-> Linking Waybar configuration..."
rm -rf ~/.config/waybar
ln -sf ~/github/dotfiles/.config/waybar ~/.config/waybar

echo "✅ Hyprland core components installed successfully!"
