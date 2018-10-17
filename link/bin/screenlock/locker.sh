#!/usr/bin/env bash

IMG_FORMAT=png
IMG_PATH="${XDG_RUNTIME_DIR:-${HOME}}/.sleepshot.${IMG_FORMAT}"

INHIBIT_TIME=0.5

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
  if [ -f "${IMG_PATH}" ] ; then
    rm "${IMG_PATH}"
  fi
  if [ -n "${BACKLIGHT}" ] ; then
    "${BACKLIGHT_CMD}" "${BACKLIGHT}"
  fi
}

###############################################################################

pre_lock

# kill locker if we get killed
trap 'kill %%' TERM INT

if [[ -e /dev/fd/${XSS_SLEEP_LOCK_FD:--1} ]]; then
    # lock fd is open, make sure the locker does not inherit a copy
    "${LOCKER_CMD[@]}" ${XSS_SLEEP_LOCK_FD}<&- &

    sleep "${INHIBIT_TIME}"

    # now close our fd (only remaining copy) to indicate we're ready to sleep
    exec ${XSS_SLEEP_LOCK_FD}<&-
else
    "${LOCKER_CMD[@]}" &
fi

wait # for locker to exit

post_lock
