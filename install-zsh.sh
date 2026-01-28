#!/bin/bash
# filepath: /srv/dotfiles/install-zsh.sh

set -e

echo "=== Installing Zsh ==="

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
echo "-> Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "ℹ️  Oh My Zsh installed."
else
    echo "ℹ️  Oh My Zsh already installed."
fi

# Install Oh My Zsh plugins
echo "-> Installing Oh My Zsh plugins..."
mkdir -p "$HOME/.oh-my-zsh/custom/plugins"

# Clone zsh-autosuggestions
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    echo "ℹ️  zsh-autosuggestions installed."
else
    echo "ℹ️  zsh-autosuggestions already installed."
fi

# Clone zsh-syntax-highlighting
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    echo "ℹ️  zsh-syntax-highlighting installed."
else
    echo "ℹ️  zsh-syntax-highlighting already installed."
fi

# Clone zsh-completions
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-completions "$HOME/.oh-my-zsh/custom/plugins/zsh-completions"
    echo "ℹ️  zsh-completions installed."
else
    echo "ℹ️  zsh-completions already installed."
fi

# Change default shell to zsh
echo "-> Setting Zsh as default shell..."
ZSH_PATH=$(which zsh)

if [ -z "$ZSH_PATH" ]; then
    echo "✗ Error: Zsh not found in PATH"
    exit 1
fi

if [ "$SHELL" != "$ZSH_PATH" ]; then
    echo "Changing default shell from $SHELL to $ZSH_PATH..."
    chsh -s "$ZSH_PATH" || sudo chsh -s "$ZSH_PATH" $USER
    echo "✅ Default shell changed to Zsh"
    echo ""
    echo "⚠️  IMPORTANT: You need to restart your terminal or log out and back in for changes to take effect."
else
    echo "ℹ️  Zsh is already your default shell."
fi

echo ""
echo "✅ Zsh installation completed!"
echo "   Current shell: $SHELL"
echo "   Zsh location: $ZSH_PATH"