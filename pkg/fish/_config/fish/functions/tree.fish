if command -s exa >/dev/null
  alias tree 'exa -T'
else
  functions -e tree
end
