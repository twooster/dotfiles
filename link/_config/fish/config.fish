set PATH $HOME/.gem/ruby/*/bin $PATH

if command -s direnv >/dev/null
  eval (direnv hook fish)
end
