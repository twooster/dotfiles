#-------------------------------------------------------------------------------
# ALIASES
#-------------------------------------------------------------------------------
alias more="less"

alias ll="ls -l"
alias l.="ls -d .*"
alias la="ls -a"
alias reload=". ~/.bashrc"

[ -n `command -v git` ] && {
    alias gs='git status'
    alias gap='git add -p'
    alias gai='git add -i'
    alias gau='git add -u'
    alias gco='git checkout'
    alias gcm='git commit -m'
    alias gol='git log --graph --oneline --decorate'
}

servedir() {
    python -m SimpleHTTPServer ${1-8080}
}

