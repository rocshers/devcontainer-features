#!/usr/bin/env bash

set -e

# Clean up
rm -rf /var/lib/apt/lists/*

UV_VERSION="${VERSION:-"0.7.4"}"

architecture="$(uname -m)"
os="$(uname -s)"

# Normalize Operating System names
case "$os" in
    Linux*) os="unknown-linux-gnu";;
    Darwin*) os="apple-darwin";;
    *) echo "(!) OS ${os} unsupported"; exit 1 ;;
esac

# Normalize architecture names
case ${architecture} in
    x86_64 | x86-64 | x64 | amd64) architecture="x86_64";;
    i386 | i486 | i686 | i786 | x86) architecture="i686";;
    aarch64 | arm64 | armv8*) architecture="aarch64";;
    aarch32 | armv7* | armvhf*) architecture="armv7"; os="${os}eabihf";;
    ppc64) architecture=powerpc64;;
    ppc64le) architecture=powerpc64le;;
    s390x) architecture=s390x;;
    *) echo "(!) Architecture ${architecture} unsupported"; exit 1 ;;
esac

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

uv_url="https://github.com/astral-sh/uv"

echo "Installing uv ${UV_VERSION}..."
mkdir /tmp/uv

uv_filename="uv-${architecture}-${os}.tar.gz"
echo "Downloading ${uv_filename}..."
curl -sSL -o ${uv_filename} "${uv_url}/releases/download/${UV_VERSION}/${uv_filename}"
tar -xzf ${uv_filename} --strip-components 1 -C /usr/local/bin
rm -rf /tmp/uv

# Clean up
rm -rf /var/lib/apt/lists/*

uv --version

enable_autocompletion() {
    command=$1
    ${command} bash >> /usr/share/bash-completion/completions/uv
    ${command} zsh >> /usr/share/zsh/vendor-completions/_uv
    ${command} fish >> /usr/share/fish/completions/uv.fish
}

mkdir -p /usr/share/fish/completions/
enable_autocompletion "uv generate-shell-completion"
enable_autocompletion "uvx --generate-shell-completion"

echo "Done!"