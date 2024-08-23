function fish_prompt --description 'Write out the prompt'
  #Save the return status of the previous command
  set stat $status

  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end

  if not set -q __fish_color_blue
    set -g __fish_color_blue (set_color -o blue)
  end

  #Set the color for the status depending on the value
  set __fish_color_status (set_color -o green)
  if test $stat -gt 0
    set __fish_color_status (set_color -o red)
  end

  set hn $custom_hostname
  if not test -n "$hn"
    set hn (prompt_hostname)
  end


  switch "$USER"
  case root toor
    if not set -q __fish_prompt_cwd
      if set -q fish_color_cwd_root
        set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
      else
        set -g __fish_prompt_cwd (set_color $fish_color_cwd)
      end
    end

    printf '%s@%s %s%s%s# ' \
      $USER $hn \
      "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal"

  case '*'
    if not set -q __fish_prompt_cwd
      set -g __fish_prompt_cwd (set_color $fish_color_cwd)
    end

    set gs (__fast_git_prompt_status)
    printf '%s %s%s@%s %s%s%s\n%s%s%-3d%s> ' \
      (date "+%H:%M") \
      "$__fish_color_blue" $USER $hn \
      "$__fish_prompt_cwd" (prompt_pwd) \
      "$gs" \
      "$__fish_prompt_normal" \
      "$__fish_color_status" "$stat" \
      "$__fish_prompt_normal"
  end
end
