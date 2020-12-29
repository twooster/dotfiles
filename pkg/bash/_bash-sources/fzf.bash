# Setup fzf
# ---------
for fzf_path in "${HOME}/.local/fzf" "${HOME}/.local/.fzf" "$HOME"/.local/opt/fzf "${HOME}/.fzf" ; do
  if [ -d "${fzf_path}" ] ; then
    if ! command -v fzf &>/dev/null ; then
      PATH="${fzf_path}/bin:${PATH}"
    fi

    # Auto-completion
    # ---------------
    [[ $- == *i* ]] && source "${fzf_path}/shell/completion.bash" 2> /dev/null

    # Key bindings
    # ------------
    source "${fzf_path}/shell/key-bindings.bash"

    break
  fi

  if command -v fd &>/dev/null ; then
    export FZF_DEFAULT_COMMAND='fd --follow --type file 2>/dev/null'
    export FZF_ALT_C_COMMAND='fd --follow --type directory --exclude "{.git,node_modules}/*" 2>/dev/null'
  elif command -v rg &>/dev/null ; then
    export FZF_DEFAULT_COMMAND='rg --files --follow -g "!{.git,node_modules}/*" 2> /dev/null'
  fi
  if [ -n "${FZF_DEFAULT_COMMAND}" ] ; then
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
  fi
  if [ -n "${TMUX}" ] ; then
    :
    #export FZF_TMUX=1
  fi
done
