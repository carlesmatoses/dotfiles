#!/bin/bash

# install-neovim.sh - Neovim installation script for different operating systems

set -e

echo "Installing Neovim..."

detect_arch() {
    case $(uname -m) in
        x86_64) echo "x86_64" ;;
        aarch64|arm64) echo "arm64" ;;
        *) echo "unsupported" ;;
    esac
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux - Use official binary for latest version
    ARCH=$(detect_arch)
    if [[ "$ARCH" == "unsupported" ]]; then
        echo "Unsupported architecture"
        exit 1
    fi

    echo "Installing latest Neovim binary..."
    curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz"
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf "nvim-linux-${ARCH}.tar.gz"

    # Create symlink for global access
    sudo ln -sf /opt/nvim-linux-${ARCH}/bin/nvim /usr/local/bin/nvim

    # Install Python support via package manager
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y python3-pip
        pip3 install --user pynvim
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y python3-pip
        pip3 install --user pynvim
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm python-pip
        pip install --user pynvim
    fi

    # Clean up
    rm "nvim-linux-${ARCH}.tar.gz"

    echo "Added to PATH. Neovim installed to /opt/nvim-linux-${ARCH}/"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if command -v brew &> /dev/null; then
        brew install neovim
    else
        echo "Homebrew not found. Installing via pre-built archive..."
        ARCH=$(detect_arch)
        if [[ "$ARCH" == "unsupported" ]]; then
            echo "Unsupported architecture"
            exit 1
        fi
        curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-macos-${ARCH}.tar.gz"
        tar xzf "nvim-macos-${ARCH}.tar.gz"
        sudo mv "nvim-macos-${ARCH}" /opt/nvim
        echo 'export PATH="$PATH:/opt/nvim/bin"' >> ~/.zshrc
        echo "Please restart your shell or run: source ~/.zshrc"
    fi
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    # Windows (Git Bash/Cygwin)
    if command -v choco &> /dev/null; then
        choco install neovim -y
    elif command -v winget &> /dev/null; then
        winget install Neovim.Neovim
    elif command -v scoop &> /dev/null; then
        scoop install neovim
    else
        echo "Please install Chocolatey, Winget, or Scoop to install Neovim on Windows"
        echo "Or download manually from: https://github.com/neovim/neovim/releases"
        exit 1
    fi
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

echo "Neovim installation completed!"
echo "Run 'nvim --version' to verify the installation."