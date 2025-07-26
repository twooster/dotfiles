function fish_user_key_bindings
  bind \cq 'clear' 'commandline -f repaint'

  ### fzf ###
  bind \ct '_fzf_search_directory'
  bind \cg 'set -l target_dir (fzf_fd_opts={-t,d,-L} _fzf_search_directory); and test -n $target_dir; and cd $target_dir'
  bind \cG 'set -l target_dir (fzf_fd_opts={-t,d,-L,-H} _fzf_search_directory); and test -n $target_dir; and cd $target_dir'
  bind \cr '_fzf_search_history'
  #  bind \ee edit_cmd

  if bind -M insert >/dev/null 2>/dev/null
      bind -M insert \ct '_fzf_search_directory'
      #      bind -M insert \cg 'set -l target_dir (fzf_fd_opts={-t,d,-L} _fzf_search_directory); and test -n $target_dir; and cd $target_dir'
      #      bind -M insert \cG 'set -l target_dir (fzf_fd_opts={-t,d,-L,-H} _fzf_search_directory); and test -n $target_dir; and cd $target_dir'
      bind -M insert \cr '_fzf_search_history'
  end
  ### fzf ###
end
