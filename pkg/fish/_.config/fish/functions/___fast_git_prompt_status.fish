function __fast_git_prompt_status
  if command -sq jj ; and  jj root --quiet &>/dev/null
    jj log --ignore-working-copy --no-graph --color always -r @ -T '
        surround(
            " -- ",
            "",
            separate(
                " ",
                bookmarks.join(", "),
                coalesce(
                    surround(
                        "\"",
                        "\"",
                        if(
                            description.first_line().substr(0, 24).starts_with(description.first_line()),
                            description.first_line().substr(0, 24),
                            description.first_line().substr(0, 23) ++ "…"
                        )
                    ),
                    "[undesc]"
                ),
                change_id.shortest() ++ ":" ++ commit_id.shortest(),
                if(conflict, "✖"),
                if(empty, "⊔"),
                if(divergent, "Đ"),
                if(hidden, "⤌"),
            )
        )
    '
  else
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
end
