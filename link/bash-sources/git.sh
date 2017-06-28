if command -v git > /dev/null ; then
  function git-spatch() {
    git stash save
    git stash pop stash@{1}
    git stash save --patch
    git stash save
    git stash pop stash@{2}
    git stash pop stash@{1}
  }

  __git_complete g _git

  alias g='git'
  alias gs='git status'
  alias gap='git add -p'
  alias gol='git log --graph --oneline --decorate'
  alias gca='git commit --amend'
  alias gsu='git submodule update --init'
  alias gc='git cached'

  gcm() {
    git commit -m "$*"
  }

  u() {
    local top=`git rev-parse --show-toplevel 2> /dev/null || pwd`
    cd "${top}/$1"
  }

  _u_completion() {
    local top=`git rev-parse --show-toplevel 2> /dev/null || pwd`
    COMPREPLY=( $( cd "$top"; compgen -d "${COMP_WORDS[COMP_CWORD]}" ) )
  }
  complete -o filenames -o nospace -F _u_completion u
fi
