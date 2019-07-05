function kx
  set -l ktx (kubectl config get-contexts -oname | fzf)
  or return 1
  kubectl config use-context $ktx
end
