#!/usr/bin/env bash

set -e

echo "Detecting distribution..."

# Determine the distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Failed to detect Linux distribution."
    exit 1
fi

echo "Detected distribution: $DISTRO"
echo "Installing Graphviz..."

case "$DISTRO" in
    ubuntu|debian)
        sudo apt update
        sudo apt install -y graphviz
        ;;
    fedora)
        sudo dnf install -y graphviz
        ;;
    centos|rhel)
        sudo yum install -y epel-release
        sudo yum install -y graphviz
        ;;
    arch)
        sudo pacman -Sy --noconfirm graphviz
        ;;
    alpine)
        sudo apk add graphviz
        ;;
    *)
        echo "Distribution $DISTRO is not supported by this script."
        exit 1
        ;;
esac

# Verify installation
if command -v dot > /dev/null; then
    echo "Graphviz installed successfully."
    dot -V
else
    echo "Error: dot not found after installation."
    exit 1
fi

echo "Done!"
