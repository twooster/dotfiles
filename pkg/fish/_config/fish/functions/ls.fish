if command -s exa >/dev/null
  alias ls 'exa -g'
else
  alias ls "ls -hb --color"
end
