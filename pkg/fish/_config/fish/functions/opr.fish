function opr
  set remote_url (git remote get-url ( \
    git rev-parse --abbrev-ref '@{u}' 2>/dev/null ; \
    or or echo -n "origin/master" | \
    string replace -r '([^/]+)/.*' '$1' \
  ) | string replace -r '^.*[/@]github.com[:/]([^/]+/[^./]+).*$' 'https://github.com/$1/pulls' )

  if test $status -ne 0
    echo Does not appear to be a github repo
  end

  echo "Opening $remote_url"
  xdg-open $remote_url
end
