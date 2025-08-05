#!/bin/bash
# filepath: /srv/dotfiles/install-zsh.sh

set -e

echo "Installing Zsh..."

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v apt-get &> /dev/null; then
        # Debian/Ubuntu
        sudo apt-get update
        sudo apt-get install -y zsh
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL
        sudo yum install -y zsh
    elif command -v dnf &> /dev/null; then
        # Fedora
        sudo dnf install -y zsh
    elif command -v pacman &> /dev/null; then
        # Arch Linux
        sudo pacman -S --noconfirm zsh
    elif command -v zypper &> /dev/null; then
        # openSUSE
        sudo zypper install -y zsh
    elif command -v apk &> /dev/null; then
        # Alpine Linux
        sudo apk add zsh
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS (Zsh is pre-installed on macOS Catalina+)
    if command -v brew &> /dev/null; then
        # Install latest version via Homebrew
        brew install zsh
    else
        echo "Zsh is pre-installed on macOS. Using system version."
    fi
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    # Windows
    echo "Zsh installation on Windows requires WSL or Git Bash with zsh package"
    echo "Please install WSL2 for the best Zsh experience on Windows"
    exit 1
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

# Install Oh My Zsh (optional but recommended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
    echo "Please log out and log back in for the shell change to take effect"
fi

echo "Zsh installation completed!"
echo "Current shell: $SHELL"
echo "Zsh location: $(which zsh)"