function ogh
  set remote_branch (git rev-parse --abbrev-ref --symbolic-full-name '@{u}')
  if test -z "$remote_branch"
    echo "Unable to detect upstream branch. Maybe you need to push?"
    return 1
  end

  set remote (string replace -r "/.*" "" "$remote_branch")
  set branch (string replace -r ".*/" "" "$remote_branch")
  set remote_url (git remote get-url "$remote")
  switch "$remote_url"
  case "http*"
    # noop
  case "*"
    set remote_url ( \
      string replace -r \
          '^([^@]+@)?([^:]+):(.*?)(.git)?$' \
          'https://$2/$3/compare' \
          "$remote_url"
    )
    set remote_url "$remote_url/$branch?expand=1"
  end
  xdg-open "$remote_url"
end
