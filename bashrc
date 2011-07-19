alias gs='git status'
alias gai='git add -i'
alias gau='git add -u'
alias gco='git checkout'
alias gcm='git commit -m'
alias more="less"
alias mmore="more"

# don't do this for dumb terminals
if [ "$TERM" != "dumb" ]; then
 if [ $(uname) == "Linux"  ]; then
   # Linux
   alias ls='ls -F --color=auto'
   alias ll='ls -lhF --color=auto'
   alias la='ls -Fa --color=auto'
   LS_COLORS='di=33:fi=0:ln=95:pi=5:so=5:bd=5:cd=5:or=37:mi=0:ex=31:*.rpm=90'
 else
   # OS X   
   alias ls='ls -FG'
   alias ll='ls -lhFG'
   alias la='ls -aFG'
   export LSCOLORS=dxfxcxdxbxegedabagacad
 fi
 #This is for everyone       
 export CLICOLOR=1
fi

export PATH=~/bin:/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

#
# Functions
apply_ssh()
{
  ssh $1 "cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub
}

pman()
{
  man -t "${1}" | open -f -a /Applications/Preview.app/
}

#
# Shell options
shopt -s histappend
set +o histexpand     # enable strings with !
set completion-ignore-case On

export PAGER="less"
export CLICOLOR="yes"
export HISTSIZE=10
export HISTFILESIZE=4096
export HISTIGNORE="cd:ls:[bf]g:clear:exit:gp:gs:ll"
export HISTCONTROL=ignoredups
# export LESSOPEN="| ~/.lesspipe.sh %s"
# export LESSCOLORIZER="pygmentize-2.7"
# export LESS=' -R '

# Tab completion for ssh hosts, from:
#  http://feeds.macosxhints.com/~r/macosxhints/recent/~3/257065700/article.php
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh

. ~/.git-completion.bash

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

if [ -s ~/.rvm/scripts/rvm ] ; then source ~/.rvm/scripts/rvm ; fi

. ~/.prompt.bash
