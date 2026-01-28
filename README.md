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
- **`setup.sh`** - Main orchestrator that runs all installation scripts in the correct order, creates symlinks, and reloads Hyprland

### Installation Scripts (Modular)
- **`install.sh`** - System setup and Paru installation
- **`install-hyprland-core.sh`** - Hyprland, Waybar, Rofi, Hyprpaper
- **`install-wlogout.sh`** - wlogout (Wayland logout dialog)
- **`install-qt-theming.sh`** - Kvantum, Qt5/Qt6 tools and Wayland support
- **`install-fonts.sh`** - JetBrains Mono Nerd Font
- **`install-audio.sh`** - PipeWire audio system (with conflict handling)
- **`install-networking.sh`** - NetworkManager and clipboard utilities
- **`install-zsh.sh`** - Zsh shell and Oh My Zsh configuration
- **`install-starship.sh`** - Starship prompt for terminal styling
- **`install-neovim.sh`** - Neovim editor
- **`install-utilities.sh`** - System utilities (htop, nvtop, neofetch, rofi-emoji, clipse, pavucontrol)
- **`install-fzf.sh`** - fzf (Fuzzy Finder) command-line tool
- **`install-extras.sh`** - Extra applications (Sioyek PDF reader, OpenSSH)
- **`install-gpu-drivers.sh`** - GPU driver detection and installation (NVIDIA)
- **`install-pywal.sh`** - Pywal color scheme generator
- **`install-zen-browser.sh`** - Zen browser (privacy-focused)
- **`install-vscode-ms.sh`** - VS Code Microsoft Official build

### Configuration
- **`sym-link.sh`** - Creates symlinks for all dotfiles configuration
- **`wallpapers.sh`** - Sets up wallpapers (if it exists in your dotfiles)

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

1. **Install Packages** - Runs all installation scripts
2. **Create Symlinks** - Sets up configuration files
3. **Setup Wallpapers** - Applies wallpapers via `wallpapers.sh`
4. **Reload Hyprland** - Reloads configuration with `hyprctl reload`

## Manual Installation

If you prefer to install components individually, you can run each script separately:

```bash
./install.sh                    # System setup and Paru
./install-hyprland-core.sh      # Hyprland compositor
./install-wlogout.sh            # wlogout logout dialog
./install-qt-theming.sh         # Qt theming
./install-fonts.sh              # Fonts
./install-audio.sh              # PipeWire audio
./install-networking.sh         # NetworkManager
./install-zsh.sh                # Zsh setup
./install-starship.sh           # Starship prompt
./install-neovim.sh             # Neovim
./install-utilities.sh          # System utilities
./install-fzf.sh                # fzf (Fuzzy Finder)
./install-extras.sh             # Extra applications
./install-gpu-drivers.sh        # GPU drivers
./install-pywal.sh              # Pywal
./install-zen-browser.sh        # Zen Browser
./install-vscode-ms.sh          # VS Code
./sym-link.sh                   # Create symlinks
./wallpapers.sh                 # Apply wallpapers (if exists)
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

- Edit individual `.sh` files to add/remove packages
- Modify `sym-link.sh` to change which dotfiles are linked
- Create `wallpapers.sh` in this directory for custom wallpaper setup
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
├── install-hyprland-core.sh        # Hyprland, Waybar, Rofi, Hyprpaper
├── install-wlogout.sh              # wlogout logout dialog
├── install-qt-theming.sh           # Qt theming
├── install-fonts.sh                # Fonts
├── install-audio.sh                # PipeWire audio
├── install-networking.sh           # NetworkManager
├── install-zsh.sh                  # Zsh setup
├── install-starship.sh             # Starship prompt
├── install-neovim.sh               # Neovim setup
├── install-utilities.sh            # System utilities
├── install-fzf.sh                  # fzf (Fuzzy Finder)
├── install-extras.sh               # Extra applications
├── install-gpu-drivers.sh          # GPU drivers
├── install-pywal.sh                # Pywal setup
├── install-zen-browser.sh          # Zen Browser setup
├── install-vscode-ms.sh            # VS Code setup
├── sym-link.sh                     # Symlink creator
├── wallpapers.sh                   # Wallpaper setup (create as needed)
├── .config/                        # Configuration files
│   ├── hypr/                       # Hyprland config
│   ├── waybar/                     # Waybar config
│   ├── rofi/                       # Rofi config
│   ├── nvim/                       # Neovim config
│   └── ... (other configs)
└── README.md                       # This file
```

## License

These are personal dotfiles. Feel free to use and modify them for your own setup.
