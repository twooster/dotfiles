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

  git-cleanup-branches() {
    git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d
  }

  ogh() {
    local remote_branch="$( git rev-parse --abbrev-ref --symbolic-full-name @{u} )"
    if [ -z "$remote_branch" ] ; then
      echo "Unable to detect upstream branch. Maybe you need to push?"
      return 1
    fi
    local remote="${remote_branch%/*}"
    local branch="${remote_branch#*/}"
    local remote_url="$( git remote get-url "$remote" )"
    case "$remote_url" in
      http*)
        :
        ;;
      *)
        remote_url="$( echo "$remote_url" | sed -r 's#^([^@]+@)?([^:]+):#\2/#' )"
          remote_url="https://${remote_url%.git}/compare/${branch}?expand=1"
        ;;
    esac
    open "${remote_url}"
  }

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
