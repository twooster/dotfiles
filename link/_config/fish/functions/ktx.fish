function ktx
  if test (count $argv) -eq 0
    kubectl config current-context
  else
    kubectl config use-context $argv
  end
end
