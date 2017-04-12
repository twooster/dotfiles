if command -v exa > /dev/null ; then
  alias ls="exa"
  alias ll="exa -lg"
else
  if [ "$UNAME" = Darwin ]; then
      LS_FLAGS="-hBG"
  else
      LS_FLAGS="-hb --color"
  fi
  alias ls="command ls $LS_FLAGS"
  unset LS_FLAGS

  alias ll="ls -l"
fi

alias l.="ls -d .*"
alias la="ls -a"
