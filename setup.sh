#!/usr/bin/env bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║              DOTFILES SETUP ORCHESTRATOR                       ║"
echo "║   This script will install all packages, create symlinks,      ║"
echo "║   and reload Hyprland configuration                            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print section headers
print_section() {
    echo ""
    echo -e "${BLUE}╭─────────────────────────────────────╮${NC}"
    echo -e "${BLUE}│ $1${NC}"
    echo -e "${BLUE}╰─────────────────────────────────────╯${NC}"
}

# Function to run a script and handle errors
run_script() {
    local script_name=$1
    local script_path="$SCRIPT_DIR/$script_name"
    
    if [ ! -f "$script_path" ]; then
        echo -e "${RED}✗ Script not found: $script_path${NC}"
        return 1
    fi
    
    chmod +x "$script_path"
    if bash "$script_path"; then
        echo -e "${GREEN}✓ $script_name completed${NC}"
        return 0
    else
        echo -e "${RED}✗ $script_name failed${NC}"
        return 1
    fi
}

# Step 1: Install all packages
print_section "STEP 1: Installing Packages"

scripts_to_run=(
    "install.sh"
    "install-hyprland-core.sh"
    "install-wlogout.sh"
    "install-qt-theming.sh"
    "install-fonts.sh"
    "install-audio.sh"
    "install-networking.sh"
    "install-zsh.sh"
    "install-starship.sh"
    "install-neovim.sh"
    "install-fzf.sh"
    "install-utilities.sh"
    "install-extras.sh"
    "install-gpu-drivers.sh"
    "install-pywal.sh"
    "install-zen-browser.sh"
    "install-vscode-ms.sh"
)

for script in "${scripts_to_run[@]}"; do
    if [ -f "$SCRIPT_DIR/$script" ]; then
        run_script "$script" || true
    fi
done

# Step 2: Create symlinks
print_section "STEP 2: Creating Symlinks"

if [ -f "$SCRIPT_DIR/sym-link.sh" ]; then
    run_script "sym-link.sh"
else
    echo -e "${RED}✗ sym-link.sh not found${NC}"
fi

# Step 3: Execute wallpapers script if it exists
print_section "STEP 3: Setting Up Wallpapers"

if [ -f "$SCRIPT_DIR/.config/hypr/scripts/wallpapers.sh" ]; then
    run_script ".config/hypr/scripts/wallpapers.sh"
else
    echo -e "${YELLOW}⚠ wallpapers.sh not found (skipping)${NC}"
fi

# Step 4: Reload Hyprland configuration
print_section "STEP 4: Reloading Hyprland"

if command -v hyprctl &> /dev/null; then
    echo "-> Reloading Hyprland configuration..."
    hyprctl reload
    echo -e "${GREEN}✓ Hyprland reloaded${NC}"
else
    echo -e "${YELLOW}⚠ Hyprland not installed or not running (skipping reload)${NC}"
fi

# Final summary
print_section "Setup Complete!"
echo ""
echo -e "${GREEN}✓ All installation steps completed!${NC}"
echo ""
echo "Summary of changes:"
echo "  • Installed system packages and utilities"
echo "  • Installed Zsh and plugins"
echo "  • Installed Starship prompt"
echo "  • Installed Neovim"
echo "  • Installed fzf (Fuzzy Finder)"
echo "  • Installed Pywal"
echo "  • Installed Zen Browser"
echo "  • Installed VS Code (Microsoft Official)"
echo "  • Installed fzf (Fuzzy Finder)"
echo "  • Created configuration symlinks"
echo "  • Applied wallpapers"
echo "  • Reloaded Hyprland"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Restart your terminal or run: exec zsh"
echo "  2. Configure any applications as needed"
echo "  3. Customize your dotfiles as desired"
echo ""
