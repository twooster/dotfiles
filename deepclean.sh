DOTFILES_DIR="$( cd -P "$( dirname -- "$0" )" && pwd )"
find "$HOME" -lname "${DOTFILES_DIR}/*" -type l -exec rm -v '{}' +
