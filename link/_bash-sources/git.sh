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

  __u_dir() {
    local dir=$( dirname "${PWD}" )
    local chg=$PWD

    while : ; do
      if [ -e "${dir}/.git" -o -e "${dir}/.ustop" ] ; then
        chg="${dir}"
        break
      fi
      if [ "${dir}" = "/" ] ; then break ; fi
      dir=$( dirname "${dir}" )
    done

    echo "${chg}"
  }

  __u_completion() {
    COMPREPLY=( $( cd "$( __u_dir )"; compgen -d "${COMP_WORDS[COMP_CWORD]}" ) )
  }

  u() {
    cd "$( __u_dir )/$1"
  }

  complete -o filenames -o nospace -F _u_completion u
fi
