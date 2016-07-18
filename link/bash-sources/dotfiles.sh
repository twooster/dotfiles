alias reload="exec bash -l"

updot() {
    (
        cd "$DOTFILES_BASE"
        git pull
        ./install.sh
    )
    reload
}

cddot() {
  cd "$DOTFILES_BASE"
}

eddot() {
  (cd "$DOTFILES"; vim)
}
