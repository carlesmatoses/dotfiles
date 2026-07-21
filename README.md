# Dotfiles Setup Guide

This repository contains automated installation and configuration scripts for setting up a complete Linux development environment with Hyprland, Zsh, Neovim, and various utilities.

## Quick Start

Run the main orchestrator script to install everything and set up your environment:

```bash
chmod +x setup.sh
./setup.sh
```

## Scripts Overview

### Main Orchestrator
- **`setup.sh`** - Main orchestrator that runs all installation scripts in the correct order and reloads Hyprland

### Installation Scripts (Modular)
Each script installs its package(s) **and** links its own configuration from this repo — there's no separate symlink step.

- **`install.sh`** - System setup and Paru installation
- **`install-hyprland-core.sh`** - Hyprland, Waybar, Hyprpaper, Hyprlock (links `.config/hypr`, `.config/waybar`, and resolves the per-machine `monitors/active.conf`)
- **`install-rofi.sh`** - Rofi application launcher (links `.config/rofi`)
- **`install-wlogout.sh`** - wlogout (Wayland logout dialog)
- **`install-qt-theming.sh`** - Kvantum, Qt5/Qt6 tools, Wayland support, kdeglobals
- **`install-gtk-theming.sh`** - GTK 3/4 theming config
- **`install-fonts.sh`** - JetBrains Mono Nerd Font
- **`install-audio.sh`** - PipeWire audio system (with conflict handling)
- **`install-networking.sh`** - NetworkManager and clipboard utilities
- **`install-zsh.sh`** - Zsh shell and Oh My Zsh configuration (links `.zshrc`)
- **`install-starship.sh`** - Starship prompt for terminal styling
- **`install-neovim.sh`** - Neovim editor
- **`install-kitty.sh`** - Kitty terminal
- **`install-tmux.sh`** - Tmux terminal multiplexer
- **`install-utilities.sh`** - System utilities (btop, htop, nvtop, neofetch, rofi-emoji, clipse, pavucontrol)
- **`install-blender.sh`** - Blender 3D suite
- **`install-fzf.sh`** - fzf (Fuzzy Finder) command-line tool
- **`install-extras.sh`** - Extra applications (Sioyek PDF reader, OpenSSH)
- **`install-gpu-drivers.sh`** - GPU driver detection and installation (NVIDIA)
- **`install-pywal.sh`** - Pywal color scheme generator
- **`install-wallpapers.sh`** - Downloads the wallpaper set used by `wallpapers.sh`
- **`install-zen-browser.sh`** - Zen browser (privacy-focused)
- **`install-vscode-ms.sh`** - VS Code Microsoft Official build
- **`install-desktop-entries.sh`** - Links custom `.desktop` launchers (7z, Calendar, Gmail, Revolut)

### Configuration
- **`.config/hypr/scripts/wallpapers.sh`** - Picks a random wallpaper, applies it via hyprpaper/hyprlock, and regenerates the Pywal color scheme

## What Gets Installed

### Core System
- Hyprland (Wayland compositor)
- Waybar (status bar)
- Rofi (application launcher)
- Dolphin (file manager)

### Development
- Neovim
- Visual Studio Code (Microsoft Official)
- Git + utilities

### Terminal
- Zsh with Oh My Zsh
- Zsh plugins: autosuggestions, syntax-highlighting, completions
- Starship prompt

### Utilities
- Pywal (color scheme generator)
- Zen Browser (privacy-focused browser)
- NetworkManager
- PipeWire (audio)
- htop, nvtop, neofetch
- Rofi emoji picker
- OpenSSH
- wl-clipboard (Wayland clipboard)
- clipse (clipboard manager)

### Fonts
- JetBrains Mono Nerd Font

## Installation Steps

The `setup.sh` script performs the following steps in order:

1. **Install Packages** - Runs all installation scripts (each also links its own config)
2. **Setup Wallpapers** - Applies wallpapers via `wallpapers.sh`
3. **Reload Hyprland** - Reloads configuration with `hyprctl reload`

## Manual Installation

If you prefer to install components individually, you can run each script separately:

```bash
./install.sh                    # System setup and Paru
./install-hyprland-core.sh      # Hyprland compositor
./install-rofi.sh               # Rofi launcher
./install-wlogout.sh            # wlogout logout dialog
./install-qt-theming.sh         # Qt theming
./install-gtk-theming.sh        # GTK theming
./install-fonts.sh              # Fonts
./install-audio.sh              # PipeWire audio
./install-networking.sh         # NetworkManager
./install-zsh.sh                # Zsh setup
./install-starship.sh           # Starship prompt
./install-neovim.sh             # Neovim
./install-kitty.sh              # Kitty terminal
./install-tmux.sh               # Tmux
./install-utilities.sh          # System utilities
./install-blender.sh            # Blender
./install-fzf.sh                # fzf (Fuzzy Finder)
./install-extras.sh             # Extra applications
./install-gpu-drivers.sh        # GPU drivers
./install-pywal.sh              # Pywal
./install-wallpapers.sh         # Download wallpaper set
./install-zen-browser.sh        # Zen Browser
./install-vscode-ms.sh          # VS Code
./install-desktop-entries.sh    # Custom .desktop launchers
./.config/hypr/scripts/wallpapers.sh  # Apply a wallpaper + regenerate colors
hyprctl reload                  # Reload Hyprland
```

## Prerequisites

- Arch Linux (or Arch-based distribution)
- `sudo` access
- Internet connection
- Basic knowledge of your system

## Notes

- The scripts use `paru` as an AUR helper. It will be installed automatically if not present.
- Some scripts use `sudo` for system-wide package installation.
- Hyprland must be running for the final reload step to work.
- VS Code from `install-vscode-ms.sh` is the official Microsoft build (binary), not the AUR packaged version.

## Customization

- Edit individual `.sh` files to add/remove packages or change which dotfiles they link
- Edit `.config/hypr/scripts/wallpapers.sh` for custom wallpaper behavior
- Edit configuration files in `.config/` directory

## Troubleshooting

- If a script fails, check the error message and install any missing dependencies
- Make sure you're using an Arch-based Linux distribution
- Ensure `paru` is installed for AUR packages
- Run scripts with elevated privileges if permission errors occur

## Directory Structure

```
dotfiles/
├── setup.sh                        # Main orchestrator
├── install.sh                      # System setup & Paru
├── install-hyprland-core.sh        # Hyprland, Waybar, Hyprpaper, Hyprlock
├── install-rofi.sh                 # Rofi launcher
├── install-wlogout.sh              # wlogout logout dialog
├── install-qt-theming.sh           # Qt theming
├── install-gtk-theming.sh          # GTK theming
├── install-fonts.sh                # Fonts
├── install-audio.sh                # PipeWire audio
├── install-networking.sh           # NetworkManager
├── install-zsh.sh                  # Zsh setup
├── install-starship.sh             # Starship prompt
├── install-neovim.sh               # Neovim setup
├── install-kitty.sh                # Kitty terminal
├── install-tmux.sh                 # Tmux
├── install-utilities.sh            # System utilities
├── install-blender.sh              # Blender
├── install-fzf.sh                  # fzf (Fuzzy Finder)
├── install-extras.sh               # Extra applications
├── install-gpu-drivers.sh          # GPU drivers
├── install-pywal.sh                # Pywal setup
├── install-wallpapers.sh           # Wallpaper set downloader
├── install-zen-browser.sh          # Zen Browser setup
├── install-vscode-ms.sh            # VS Code setup
├── install-desktop-entries.sh      # Custom .desktop launchers
├── .config/                        # Configuration files
│   ├── hypr/                       # Hyprland config (+ scripts/wallpapers.sh)
│   ├── waybar/                     # Waybar config
│   ├── rofi/                       # Rofi config
│   ├── nvim/                       # Neovim config
│   └── ... (other configs)
└── README.md                       # This file
```

## License

These are personal dotfiles. Feel free to use and modify them for your own setup.
