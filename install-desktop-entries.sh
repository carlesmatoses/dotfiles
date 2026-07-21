#!/usr/bin/env bash
set -e

echo "=== Linking Custom Desktop Entries ==="

mkdir -p ~/.local/share/applications

for entry in 7z calendar gmail revolut; do
    echo "-> Linking $entry.desktop..."
    rm -f ~/.local/share/applications/"$entry".desktop
    ln -sf ~/github/dotfiles/.config/applications/"$entry".desktop ~/.local/share/applications/"$entry".desktop
done

echo "✅ Custom desktop entries linked successfully!"
