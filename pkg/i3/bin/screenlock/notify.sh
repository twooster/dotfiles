#!/bin/sh
XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-$HOME}"

if ! [ -e "${XDG_RUNTIME_DIR}/screenlock.flag" ] ; then
  notify-send \
    -u critical \
    -i system-lock-screen \
    -t 5000 \
    -- "*** LOCKING SCREEN IN ${1:-30} SECS ***"
fi
