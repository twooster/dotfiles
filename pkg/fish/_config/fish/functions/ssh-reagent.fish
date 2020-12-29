function ssh-reagent -a flag
  if test "x$flag" != 'x-f' -a -S "$SSH_AUTH_SOCK"
    if test "x$flag" != 'x-q'
      echo "Socket for ssh-agent already exists; use -f to force"
    end
    return
  end

  set -x SSH_AGENT_PID ''
  set -x SSH_AUTH_SOCK ''

  for agent in /tmp/ssh-*/agent.*
    env SSH_AUTH_SOCK=$agent ssh-add -l >/dev/null 2>&1
    # ssh-add can return exit code 1 if the agent has no identities, but
    # exit code 2 means it wasn't able to establish a connection
    if test "$status" -ne 2
      set SSH_AUTH_SOCK $agent
      break
    end
  end

  if test -z "$SSH_AUTH_SOCK"
    if test "x$flag" != 'x-q'
      echo "Cannot find ssh-agent - restart ssh-agent, or forward it with ssh -A"
    end
  else
    set SSH_AGENT_PID (string replace -r '.*agent\.' '' "$SSH_AUTH_SOCK")
    echo "Found new ssh-agent (pid: $SSH_AGENT_PID)"

    if test -n "$TMUX"
      tmux set-environment SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
      tmux set-environment SSH_AGENT_PID "$SSH_AGENT_PID"
      echo "Re-set tmux env variables for SSH_AUTH_SOCK and SSH_AGENT_PID"
    end
  end
end
