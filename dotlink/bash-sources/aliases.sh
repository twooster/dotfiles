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
alias t='tmux'
alias be='bundle exec'
alias up='cd `git rev-parse --show-toplevel`'

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

servedir() {
    python -m SimpleHTTPServer ${1:-8080}
}
