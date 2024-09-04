if command -s lsd >/dev/null
  alias ls 'lsd'
  alias tree 'lsd --tree'
else if command -s exa >/dev/null
  alias ls 'exa -g'
  alias tree 'exa -T'
else
  alias ls "ls -hb --color"
end
