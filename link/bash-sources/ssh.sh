#-------------------------------------------------------------------------------
# SSH HELPERS
#-------------------------------------------------------------------------------

# TODO[tmw]: probably actually want to use ssh-copy-id
apply-ssh() {
  ssh $1 "cat >> ~/.ssh/authorized_keys" < ${2-~/.ssh/id_rsa.pub}
}

ssh-reagent() {
  if [ "$1" != '-f' -a -S "${SSH_AUTH_SOCK}" ] ; then
    if [ "$1" != '-q' ] ; then
      echo "Socket for ssh-agent already exists; use -f to force"
    fi
    return
  fi

  SSH_AGENT_PID=
  SSH_AUTH_SOCK=

  local agent
  for agent in /tmp/ssh-*/agent.* ; do
    SSH_AUTH_SOCK="${agent}" ssh-add -l > /dev/null 2>&1
    # ssh-add can return exit code 1 if the agent has no identities, but
    # exit code 2 means it wasn't able to establish a connection
    if [ $? -ne 2 ]; then
      SSH_AUTH_SOCK="${agent}"
      break
    fi
  done

  if [ -z "${SSH_AUTH_SOCK}" ] ; then
    if [ "$1" != '-q' ] ; then
      echo "Cannot find ssh-agent - restart ssh-agent, or forward it with ssh -A"
    fi
  else
    SSH_AGENT_PID="${SSH_AUTH_SOCK##*agent.}"
    export SSH_AUTH_SOCK SSH_AGENT_PID
    echo "Found new ssh-agent (pid: ${SSH_AGENT_PID})"

    if [ -n "${TMUX}" ]; then
      tmux set-environment SSH_AUTH_SOCK "${SSH_AUTH_SOCK}"
      tmux set-environment SSH_AGENT_PID "${SSH_AGENT_PID}"
      echo "Re-set tmux env variables for SSH_AUTH_SOCK and SSH_AGENT_PID"
    fi
  fi
}

ssh-reagent -q

alias sr='ssh-reagent'
