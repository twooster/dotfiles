if command -v kubectl 2>&1 >/dev/null ; then
  alias kc=kubectl

  source <(kubectl completion bash)

  $( complete -p kubectl | sed -E s/kubectl$/kc/ )

  ktx() {
    if [ $# -eq 0 ] ; then
      kubectl config current-context
    else
      kubectl config use-context "$@"
    fi
  }

#  _ktx_complete() {
#    declare -p | grep COMP > ~/whatever
#    COMP_CWORD=2
#    __start_kubectl kubectl use-context "$3"
#  }
#
#  complete -o default -F _ktx_complete ktx
fi
