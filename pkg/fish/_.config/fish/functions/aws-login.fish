function aws-login --argument-names profile
  aws-okta write-to-credentials "$profile" "$HOME/.aws/credentials"
end
