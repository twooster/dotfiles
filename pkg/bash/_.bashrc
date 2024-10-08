#-------------------------------------------------------------------------------
# BASH INITIALIZATION
#-------------------------------------------------------------------------------

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# the basics
HOME=~
UNAME="$(uname)"

# readline config
[ -r ~/.inputrc ] && : INPUTRC="${HOME}/.inputrc"

# Enable readline command-line editing
set -o emacs

# Notify of background-job completion immediately
set -o notify

# Add extended globbing
shopt -s globstar 2> /dev/null

# "Better" completion
set completion-ignore-case On

# History settings
shopt -s histappend
# enable strings with !
set -o histexpand

# Disable core dumps:
ulimit -S -c 0
# Sensible umask
umask 0022

# Disable flood-control CTRL-S
stty -ixon

unset HISTSIZE
unset HISTFILESIZE
HISTFILE="$HOME/.bash_history"
HISTIGNORE="cd:ls:bg:fg:clear:exit:gp:gs:ll:..:u"
HISTCONTROL=ignoredups

export PATH="/usr/local/bin:${PATH}:/usr/local/sbin:/usr/sbin:/sbin"
[ -d "${HOME}/.local/bin" ] && PATH="${HOME}/.local/bin:${PATH}"
[ -d "${HOME}/bin" ] && PATH="${HOME}/bin:${PATH}"

# enable en_US locale w/ utf-8 encodings if not already configured
export LANG="en_US.UTF-8"
export LANGUAGE="en"

# Export UID for docker happiness
export UID

# always use PASSIVE mode ftp
export FTP_PASSIVE=1

# Is this even necessary?
case "${TERM}" in
  tmux*)
    export TERM=screen-256color
    ;;
  screen*)
    export TERM=screen-256color
    ;;
  *)
    export TERM=xterm-256color
    ;;
esac
export CLICOLOR=yes

#-------------------------------------------------------------------------------
# PAGER / EDITOR
#-------------------------------------------------------------------------------


export EDITOR="$(command -v vim vi nvim nano pico | head -1)"
export VISUAL="${EDITOR}"

# PAGER
if command -v less > /dev/null ; then
    export PAGER=less
    export LESS="-FiRwX"

    if command -v source-highlight > /dev/null ; then
      export LESSOPEN="|$HOME/bin/lesspipe-highlight.sh %s"
    fi
else
    export PAGER=more
fi

#export GIT_PAGER="${PAGER}"
#export MANPAGER="${PAGER}"

#-------------------------------------------------------------------------------
# FINALIZE SETUP
#-------------------------------------------------------------------------------

for file in "${HOME}/.bash-sources/"*.{sh,bash} ; do
    . "${file}"
done

[ -r "${HOME}/.bash_local" ] && . "${HOME}/.bash_local"

:
