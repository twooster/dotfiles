#-------------------------------------------------------------------------------
# SSH HELPERS
#-------------------------------------------------------------------------------

apply_ssh() {
  ssh $1 "cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub
}

ssh-reagent () {
  for agent in /tmp/ssh-*/agent.*; do
    export SSH_AUTH_SOCK=$agent
    if ssh-add -l 2>&1 > /dev/null; then
      echo Found working SSH Agent:
      ssh-add -l
      return
    fi
  done
  echo Cannot find ssh agent - maybe you should reconnect and forward it?
}

# Tab completion for ssh hosts, from:
#  http://feeds.macosxhints.com/~r/macosxhints/recent/~3/257065700/article.php
if [ -r "$HOME/.ssh/known_hosts" ]; then
  complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh apply_ssh
fi
