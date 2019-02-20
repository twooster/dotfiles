#!/usr/bin/env bash
: ${XDG_CACHE_HOME:="$HOME/.cache"}

set -e
set +x

systemctl --user enable \
  sleep.target \
  watch-sleep.service \
  xrandr-on-wake.service

mkdir -p "$HOME/.cache"
mkdir -p "$HOME/.local"
mkdir -p "${XDG_CACHE_HOME}"/vim/{undo,swap,backup}


which git || sudo apt install git
which go || sudo apt install golang
which fzf || {
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.local/fzf
  cd "$HOME"/.local/fzf
  ./install --no-fish --no-bash --no-zsh --xdg
}
which rustup || { curl https://sh.rustup.rs -sSf | sh -s ; }
which ambr || cargo install amber
which bat || cargo install bat
which exa || cargo install exa
which fd || cargo install fd-find
which rg || cargo install ripgrep
