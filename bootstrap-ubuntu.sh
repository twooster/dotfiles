#!/usr/bin/env bash
set -eo pipefail

sudo apt update
sudo apt install -y git
git clone https://github.com/twooster/dotfiles "$HOME/dotfiles" || { echo "dotfiles directory already exists?" ; exit 1 ; }
cd "$HOME/dotfiles"
./install -s bootstrap-ubuntu
