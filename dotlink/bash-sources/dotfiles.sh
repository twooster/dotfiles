updot() {
    (
        echo $DOTFILES_BASE
        cd $DOTFILES_BASE
        git pull
        ./install.sh
    )
}

