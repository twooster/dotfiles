#!/usr/bin/env bash
: ${XDG_CACHE_HOME:="$HOME/.cache"}

set -e
set -o pipefail
set +x

systemctl --user enable \
  sleep.target \
  watch-sleep.service \
  xrandr-on-wake.service

mkdir -p "$HOME/.cache"
mkdir -p "$HOME/.local/opt"
mkdir -p "${XDG_CACHE_HOME}"/vim/{undo,swap,backup}


which git || sudo apt install git
which go || sudo apt install golang
which fzf || {
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.local/opt/fzf
  cd "$HOME"/.local/opt/fzf
  ./install --bin
}
which kubectx || {
  git clone --depth 1 https://github.com/ahmetb/kubectx "$HOME"/.local/opt/kubectx
  ln -s "$HOME"/.local/opt/kubectx/kubectx "$HOME"/.local/bin/kubectx
  ln -s "$HOME"/.local/opt/kubectx/kubens "$HOME"/.local/bin/kubens
}
which rustup || { curl https://sh.rustup.rs -sSf | sh -s ; }
which ambr || cargo install amber
which bat || cargo install bat
which exa || cargo install exa
which fd || cargo install fd-find
which rg || cargo install ripgrep
