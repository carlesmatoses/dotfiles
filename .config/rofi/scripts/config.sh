#!/bin/bash

# Rofi script for editing configuration files
# Usage: rofi -modi 'Config:~/.config/rofi/scripts/config.sh' -show Config

if [ -z "$@" ]; then
    echo " Dotfiles"
    echo "󰒓 Hyprland Config"
    echo "󰒓 Hyprland Binds Config"
    echo "󰈙 Waybar Config"
    echo "󰙵 Waybar Modules"
    echo "󱄅 Kitty Config"
    echo "󰌋 Rofi Config"
    echo "󰕮 Starship Config"
else
    case "$@" in
        " Dotfiles")
            code ~/github/dotfiles
            ;;
        "󰒓 Hyprland Config")
            kitty nvim ~/.config/hypr/hyprland.conf
            ;;
        "󰒓 Hyprland Binds Config")
            kitty nvim ~/.config/hypr/configs/keybindings.conf
            ;;
        "󰈙 Waybar Config")
            kitty nvim ~/.config/waybar/config
            ;;
        "󰙵 Waybar Modules")
            kitty nvim ~/.config/waybar/modules.json
            ;;
        "󱄅 Kitty Config")
            kitty nvim ~/.config/kitty/kitty.conf
            ;;
        "󰌋 Rofi Config")
            kitty nvim ~/.config/rofi/config.rasi
            ;;
        "󰕮 Starship Config")
            kitty nvim ~/.config/starship.toml
            ;;
    esac
fi
