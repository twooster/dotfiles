if command -s exa >/dev/null
  alias ls 'exa -g'
else
  alias ls "-hb --color"
end
