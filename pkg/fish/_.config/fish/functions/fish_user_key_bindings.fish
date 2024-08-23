function fish_user_key_bindings
  bind \cq 'clear' 'commandline -f repaint'

  ### fzf ###
  bind \ct '__fzf_find_file'
  bind \cr '__fzf_reverse_isearch'
  bind \cg '__fzf_cd'
  bind \cG '__fzf_cd --hidden'

  if bind -M insert >/dev/null 2>/dev/null
      bind -M insert \ct '__fzf_find_file'
      bind -M insert \cr '__fzf_reverse_isearch'
      bind -M insert \cg '__fzf_cd'
      bind -M insert \cG '__fzf_cd --hidden'
  end

  if set -q FZF_COMPLETE
      bind \t '__fzf_complete'
  end
  ### fzf ###
end
