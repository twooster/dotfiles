for dir in "$HOME/.fzf" "$HOME/.local/fzf" "$HOME/.local/opt/fzf" "$HOME/.local/.fzf"
  if test -d $dir
    set -xg PATH $dir/bin $PATH
    break
  end
end
