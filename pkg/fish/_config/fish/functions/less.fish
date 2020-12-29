if command -s bat >/dev/null
  alias less 'bat -p'
else
  functions --erase less
end
