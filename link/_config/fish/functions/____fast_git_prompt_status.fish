function __fast_git_prompt_status
  set branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)

  if test "$status" = 0
    set diverge ""
    set dirty ""
    set git_result ""

    if git diff --no-ext-diff --cached --quiet 2>/dev/null 2>/dev/null
      set dirty (set_color red)"⚒"
    end


    set aheadbehind (git rev-list --count --left-right '@{u}...HEAD' 2>/dev/null)
    switch "$aheadbehind"
      case '' \
           '0	0'
          set diverge ""
          #set diverge (set color yellow)"●"
      case '0	*' # ahead of upstream
          set diverge (set_color yellow)"↑"
      case '*	0' # behind upstream
          set diverge (set_color yellow)"↓"
      case '*'         # diverged from upstream
          set diverge (set_color yellow)"↕"
    end

    printf " %s%s%s" (set_color green)"$branch" "$diverge" "$dirty"
  end
end
