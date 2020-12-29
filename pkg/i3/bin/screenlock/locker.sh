#!/usr/bin/env bash

XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-$HOME}"
IMG_FORMAT=png
IMG_PATH="${XDG_RUNTIME_DIR}/sleepshot.${IMG_FORMAT}"

INHIBIT_TIME=0.5

LOCKER_CMD=( i3lock --nofork --ignore-empty-password --color=000033 --image="${IMG_PATH}" )
# Run before starting the locker
pre_lock() {
  import \
    -window root \
    -colorspace Gray \
    -filter gaussian \
    -define filter:blur=12 \
    -resize '100%' \
    "${IMG_PATH}"

  touch "${XDG_RUNTIME_DIR}/screenlock.flag"
}

LOCK_PID=
# Run after the locker exits
post_lock() {
  rm -f -- "${XDG_RUNTIME_DIR}/screenlock.flag"

  if ! [ -z "$LOCK_PID" ] ; then
    kill $LOCK_PID
    LOCK_PID=
  fi

  if [ -e "${IMG_PATH}" ] ; then
    rm -f -- "${IMG_PATH}"
  fi
}


###############################################################################

pre_lock

trap 'post_lock' EXIT

if [ -e /dev/fd/${XSS_SLEEP_LOCK_FD:--1} ] ; then
  # lock fd is open, make sure the locker does not inherit a copy
  "${LOCKER_CMD[@]}" ${XSS_SLEEP_LOCK_FD}<&- &
  LOCK_PID=$!

  sleep "${INHIBIT_TIME}"

  # now close our fd (only remaining copy) to indicate we're ready to sleep
  eval "exec ${XSS_SLEEP_LOCK_FD}<&-"
else
  "${LOCKER_CMD[@]}" &
  LOCK_PID=$!
fi

wait "${LOCK_PID}" # for locker to exit
LOCK_PID=
