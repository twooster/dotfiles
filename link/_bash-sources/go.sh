if [ -d "${HOME}/.go/current" ] ; then
  export GOROOT="${HOME}/.go/current"
fi

if [ -d "${HOME}/go" ] ; then
  export GOPATH="${HOME}/go"
  export PATH="${PATH}:${GOPATH}/bin"
fi
