function ogh
  set remote_branch (git rev-parse --abbrev-ref --symbolic-full-name '@{u}')
  if test -z "$remote_branch"
    echo "Unable to detect upstream branch. Maybe you need to push?"
    return 1
  end

  set remote (string replace -r "/.*" "" "$remote_branch")
  set branch (string sub -s (string length "$remote//") "$remote_branch")
  set remote_url (git remote get-url "$remote")
  switch "$remote_url"
  case "https://github.com/*.git"
    set remote_url (string sub -l (math (string length "$remote_url") - 4) "$remote_url")
  case "https://github.com/*"
    # noop
  case "git@github.com:*.git"
    set remote_url "https://github.com/"(string sub -s 16 "$remote_url" -l (math (string length "$remote_url") - 19))
  case "git@github.com:*"
    set remote_url "https://github.com/"(string sub -s 16 "$remote_url")
  case "*"
    echo "Remote URL does not seem to be GitHub-like: $remote_url"
    return 1
  end

  set remote_url "$remote_url/compare/$branch?expand=1"
  xdg-open "$remote_url"
end
