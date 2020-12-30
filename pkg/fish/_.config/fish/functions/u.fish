function u
  set cd_target (git rev-parse --show-toplevel 2>/dev/null ; or echo "$PWD")
  cd "$cd_target"
end
