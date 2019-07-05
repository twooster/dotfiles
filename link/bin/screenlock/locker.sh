#!/usr/bin/env bash

IMG_FORMAT=png
IMG_PATH="${XDG_RUNTIME_DIR:-${HOME}}/sleepshot.${IMG_FORMAT}"

INHIBIT_TIME=0.5
SLEEP_TIMEOUT=300

BACKLIGHT_CMD="$HOME/bin/backlight"
BACKLIGHT=100
LOCKER_CMD=( i3lock --nofork --ignore-empty-password --color=000033 --image="${IMG_PATH}" )
# Run before starting the locker
pre_lock() {
  BACKLIGHT=$( "${BACKLIGHT_CMD}" )

  import \
    -window root \
    -colorspace Gray \
    -filter gaussian \
    -define filter:blur=12 \
    -resize '100%' \
    "${IMG_PATH}"

  if [ "${BACKLIGHT}" -gt 20 ] ; then
    "${BACKLIGHT_CMD}" 20
  else
    BACKLIGHT=
  fi
}

# Run after the locker exits
post_lock() {
  if [ -n "${BACKLIGHT}" ] ; then
    "${BACKLIGHT_CMD}" "${BACKLIGHT}"
  fi

  if [ -e "${IMG_PATH}" ] ; then
    rm -f -- "${IMG_PATH}"
  fi
}

LOCK_PID=
SLEEP_PID=
kill_pids() {
  kill $LOCK_PID $SLEEP_PID
}

###############################################################################

pre_lock

# kill locker if we get killed
trap 'kill_pids' TERM INT

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

  if [ "$SLEEP_TIMEOUT" -gt 0 ] ; then
    ( sleep ${SLEEP_TIMEOUT} && systemctl suspend ) &
    SLEEP_PID=$!
  fi
fi

wait "${LOCK_PID}" # for locker to exit
kill "${SLEEP_PID}"

post_lock
