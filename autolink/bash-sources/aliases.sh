#-------------------------------------------------------------------------------
# ALIASES
#-------------------------------------------------------------------------------
alias more="less"

alias ll="ls -l"
alias l.="ls -d .*"
alias la="ls -a"
alias vimrc="vim ~/.vimrc"
alias sr='ssh-reagent'
alias :q='exit'
alias rc='be rails c'
alias rs='be rails s'
alias r='be rails'
alias v='vim'
alias be='bundle exec'

[ -n `command -v git` ] && {
    alias g='git'
    alias gs='git status'
    alias gap='git add -p'
    alias gau='git add -u'
    alias gco='git checkout'
    alias gcm='git commit -m'
    alias gol='git log --graph --oneline --decorate'
    alias gca='git commit --amend'
    alias gsu='git submodule update --init'
    alias gc='git cached'
    alias ..='cd ..'
}

gr() {
  ssh-reagent
  git review
}

t() {
  local top=`git rev-parse --show-toplevel 2> /dev/null || pwd`
  cd ${top}/$1
}

_t_completion() {
  local top=`git rev-parse --show-toplevel 2> /dev/null || pwd`
  COMPREPLY=( $( cd "$top"; compgen -d "${COMP_WORDS[COMP_CWORD]}" ) )
}
complete -o filenames -o nospace -F _t_completion t

servedir() {
    python -m SimpleHTTPServer ${1:-8080}
}
