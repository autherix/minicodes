#!/usr/bin/env bash

apt --purge remove -y rustc cargo
apt install -y build-essential pkg-config libssl-dev

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source "$HOME/.cargo/env"

# Rustup, rustc and cargo are installed and in PATH
echo "Rustup, rustc and cargo are installed and in PATH"
exit 0