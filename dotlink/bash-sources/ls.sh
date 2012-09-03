if [ "$UNAME" = Darwin ]; then
    LS_FLAGS="-hBG"
else
    LS_FLAGS="-hb --color"
fi

# setup the main ls alias if we've established common args
[ -n "$LS_FLAGS" ] && alias ls="command ls $LS_FLAGS"
