if command -s direnv >/dev/null
  eval (direnv hook fish)
end

contains "$HOME/go/bin" $fish_user_paths; or set -Ua fish_user_paths "$HOME/go/bin"
contains "$HOME/.cargo/bin" $fish_user_paths; or set -Ua fish_user_paths "$HOME/.cargo/bin"
