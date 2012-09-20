#-------------------------------------------------------------------------------
# ALIASES
#-------------------------------------------------------------------------------
alias more="less"

alias ll="ls -l"
alias l.="ls -d .*"
alias la="ls -a"
alias reload=". ~/.bashrc"
alias vimrc="vim ~/.vimrc"
alias causes="cd ~/causes"

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
}

servedir() {
    python -m SimpleHTTPServer ${1-8080}
}

