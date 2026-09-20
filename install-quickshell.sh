#!/usr/bin/env bash
set -e

echo "=== Installing Quickshell (Bar, Launcher, Notifications, Power Menu) ==="

echo "-> Installing Quickshell..."
sudo pacman -S --needed --noconfirm quickshell

echo "-> Linking Quickshell configuration..."
rm -rf ~/.config/quickshell
ln -sf ~/github/dotfiles/.config/quickshell ~/.config/quickshell

# Quickshell replaces these outright.
#
# The notification daemons matter most: Quickshell owns
# org.freedesktop.Notifications now, and any other daemon on the system would
# win the race for that bus name at login, leaving Quickshell's notifications
# silently invisible. wlogout is simply superseded by PowerMenu.qml.
echo "-> Removing superseded packages..."
for pkg in dunst mako swaync wlogout; do
    if pacman -Qq "$pkg" >/dev/null 2>&1; then
        echo "   removing $pkg"
        sudo pacman -Rns --noconfirm "$pkg"
    fi
done

# dunst also ships a systemd user unit that D-Bus activates it on demand.
# Removing the package takes the unit with it, but mask it as well in case a
# dependency pulls dunst back in later.
if systemctl --user list-unit-files dunst.service >/dev/null 2>&1; then
    systemctl --user mask dunst.service >/dev/null 2>&1 || true
fi

echo "✅ Quickshell installed successfully!"
echo "   Started via 'exec-once = qs' in .config/hypr/hyprland.conf"
