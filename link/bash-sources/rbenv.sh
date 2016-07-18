if [ -d "${HOME}/.rbenv" ]; then
  PATH="${HOME}/.rbenv/bin:${PATH}"
  which rbenv > /dev/null && eval "$(rbenv init -)"
fi
