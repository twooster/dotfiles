if command -s bat >/dev/null
  alias cat 'bat -p'
else
  functions --erase cat
end
