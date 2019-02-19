DOTFILES_DIR="$( cd -P "$( dirname -- "$0" )" && pwd )"
find "$HOME" -path "${DOTFILES_DIR}" -prune -o -lname "${DOTFILES_DIR}/*" -type l -exec rm -v '{}' +
