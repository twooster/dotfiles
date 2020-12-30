if test -d "$HOME/.go/current"
  set -x GOROOT "$HOME/.go/current"
end

if test -d "$HOME/go"
  set -x GOPATH "$HOME/go"
end
