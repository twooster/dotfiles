if [ -d "${HOME}/.go/current" ] ; then
  export GOROOT="${HOME}/.go/current"
  export GOPATH="${HOME}/go"
  export PATH="${PATH}:${GOROOT}/bin"
fi
