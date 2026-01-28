#!/usr/bin/env bash
set -e

echo "=== Installing Audio System (PipeWire) ==="

# 1. Install PipeWire (audio controller)
echo "-> Installing PipeWire..."
sudo pacman -S --needed --noconfirm pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber rtkit

# 2. Remove conflicting PulseAudio if installed
if pacman -Qs pulseaudio > /dev/null; then
    echo "-> Removing conflicting PulseAudio packages..."
    sudo pacman -Rdd --noconfirm pulseaudio pulseaudio-alsa 2>/dev/null || true
fi

# 3. Remove conflicting JACK if installed
if pacman -Qs jack2 > /dev/null; then
    echo "-> Removing conflicting JACK packages..."
    sudo pacman -Rdd --noconfirm jack2 2>/dev/null || true
fi

# 4. Enable PipeWire services
echo "-> Enabling PipeWire services..."
systemctl --user enable pipewire pipewire-pulse wireplumber

# 5. Mask PulseAudio to prevent conflicts
systemctl --user mask pulseaudio.service pulseaudio.socket 2>/dev/null || true

# 6. Start PipeWire services immediately
echo "-> Starting PipeWire services..."
systemctl --user start pipewire pipewire-pulse wireplumber

echo "✅ Audio system (PipeWire) installed and configured successfully!"
