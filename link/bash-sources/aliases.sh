#-------------------------------------------------------------------------------
# GENERAL ALIASES
#-------------------------------------------------------------------------------
alias more="less"
alias vimrc="vim ~/.vimrc"
alias sr='ssh-reagent'
alias :q='exit'
#alias rc='be rails c'
#alias rs='be rails s'
#alias r='be rails'
alias v='vim'
alias be='bundle exec'

alias ..='cd ..'
alias ...='cd ../..'

servedir() {
    python -m SimpleHTTPServer ${1:-8080}
}
