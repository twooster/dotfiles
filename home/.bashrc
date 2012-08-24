# the basics
: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# readline config
: ${INPUTRC=~/.inputrc}

# Bring in system bashrc
test -r /etc/bashrc && . /etc/bashrc
# Notify of background-job completion immediately
set -o notify
# Disable core dumps:
ulimit -S -c 0
# Sensible umask
umask 0022
# Disable flood-control CTRL-S
stty -ixon

shopt -s histappend
set +o histexpand     # enable strings with !
set completion-ignore-case On

HISTSIZE=1000
HISTFILESIZE=40960
HISTIGNORE="cd:ls:[bf]g:clear:exit:gp:gs:ll"
HISTCONTROL=ignoredups

#-------------------------------------------------------------------------------
# PATH SETUP
#-------------------------------------------------------------------------------

PATH="/usr/local/bin:$PATH:/usr/local/sbin:/usr/sbin:/sbin"
test -d "$HOME/bin" && PATH="$HOME/bin:$PATH"

#-------------------------------------------------------------------------------
# ENVIRONMENT CONFIGURATION
#-------------------------------------------------------------------------------

# detect interactive shell
case "$-" in
    *i*) INTERACTIVE=yes ;;
    *)   unset INTERACTIVE ;;
esac

# detect login shell
case "$0" in
    -*) LOGIN=yes ;;
    *)  unset LOGIN ;;
esac

# enable en_US locale w/ utf-8 encodings if not already configured
: ${LANG:="en_US.UTF-8"}
: ${LANGUAGE:="en"}
: ${LC_CTYPE:="en_US.UTF-8"}
: ${LC_ALL:="en_US.UTF-8"}
export LANG LANGUAGE LC_CTYPE LC_ALL

# always use PASSIVE mode ftp
: ${FTP_PASSIVE:=1}
export FTP_PASSIVE

# ignore backups, CVS directories, python bytecode, vim swap files
FIGNORE="~:CVS:#:.pyc:.swp:.swa:apache-solr-*"
export CLICOLOR="yes"

#-------------------------------------------------------------------------------
# ALIASES
#-------------------------------------------------------------------------------
alias gs='git status'
alias gap='git add -p'
alias gai='git add -i'
alias gau='git add -u'
alias gco='git checkout'
alias gcm='git commit -m'
alias gl='git log --graph --oneline --decorate'
alias more="less"
alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'

alias wo="workon"
alias woff="deactivate"
alias workoff="deactivate"

#-------------------------------------------------------------------------------
# PAGER / EDITOR
#-------------------------------------------------------------------------------

# See what we have to work with ...
HAVE_VIM=$(command -v vim)
HAVE_GVIM=$(command -v gvim)

# EDITOR
test -n "$HAVE_VIM" &&
EDITOR=vim ||
EDITOR=vi
export EDITOR

# PAGER
if test -n "$(command -v less)" ; then
    PAGER="less -FirSwX"
else
    PAGER=more
fi
MANPAGER="$PAGER"
export PAGER MANPAGER

# Ack
ACK_PAGER="$PAGER"
ACK_PAGER_COLOR="$PAGER"
export ACK_PAGER ACK_PAGER_COLOR

#-------------------------------------------------------------------------------
# BASH COMPLETION
#-------------------------------------------------------------------------------

test -z "$BASH_COMPLETION" && {
    bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
    test -n "$PS1" && test $bmajor -gt 1 && {
        # search for a bash_completion file to source
        for f in /usr/local/etc/bash_completion \
                 /usr/pkg/etc/bash_completion \
                 /etc/bash_completion
        do
            test -f $f && {
                . $f
                break
            }
        done
    }
    unset bash bmajor bminor
}

# Tab completion for ssh hosts, from:
#  http://feeds.macosxhints.com/~r/macosxhints/recent/~3/257065700/article.php
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh

. ~/.git-completion.bash

#-------------------------------------------------------------------------------
# LS AND DIRCOLORS
#-------------------------------------------------------------------------------

# we always pass these to ls(1)
LS_COMMON="-hBG --color"

# if the dircolors utility is available, set that up to
dircolors="$(type -P gdircolors dircolors | head -1)"
test -n "$dircolors" && {
    COLORS=/etc/DIR_COLORS
    test -e "/etc/DIR_COLORS.$TERM"   && COLORS="/etc/DIR_COLORS.$TERM"
    test -e "$HOME/.dircolors"        && COLORS="$HOME/.dircolors"
    test ! -e "$COLORS"               && COLORS=
}
unset dircolors

# setup the main ls alias if we've established common args
test -n "$LS_COMMON" && alias ls="command ls $LS_COMMON"

# these use the ls aliases above
alias ll="ls -l"
alias l.="ls -d .*"

#-------------------------------------------------------------------------------
# MISCELLANEOUS FUNCTIONS
#-------------------------------------------------------------------------------

apply_ssh() {
  ssh $1 "cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub
}

pman() {
  man -t "${1}" | open -f -a /Applications/Preview.app/
}

servedir() {
    python -m SimpleHTTPServer ${1-8080}
}

#-------------------------------------------------------------------------------
# MACOS X / DARWIN SPECIFIC
#-------------------------------------------------------------------------------

if [ "$UNAME" = Darwin ]; then
    # put ports on the paths if /opt/local exists
    test -x /opt/local -a ! -L /opt/local && {
        PORTS=/opt/local

        # setup the PATH and MANPATH
        PATH="$PORTS/bin:$PORTS/sbin:$PATH"
        MANPATH="$PORTS/share/man:$MANPATH"

        # nice little port alias
        alias port="sudo nice -n +18 $PORTS/bin/port"
    }

    # setup java environment. puke.
    JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
    ANT_HOME="/Developer/Java/Ant"
    export ANT_HOME JAVA_HOME
fi

#-------------------------------------------------------------------------------
# VIRTUALENV STUFF
#-------------------------------------------------------------------------------

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=~/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=`which python`
    export VIRTUALENVWRAPPER_VIRTUALENV=`which python`
    export VIRTUALENVWRAPPER_VIRTUALENV_ARGS="-m virtualenv --no-site-packages"
    source /usr/local/bin/virtualenvwrapper.sh
fi

#-------------------------------------------------------------------------------
# FINALIZE SETUP
#-------------------------------------------------------------------------------

. ~/.prompt.bash
[ -f "$HOME/.bash_local" ] && . "$HOME/.bash_local"
