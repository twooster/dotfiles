updot() {
    (
        cd "$DOTFILES_BASE"
        git pull
        ./install.sh
    )
}

cddot() {
  cd "$DOTFILES_BASE"
}

eddot() {
  (cd "$DOTFILES"; vim)
}
