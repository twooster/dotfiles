#!/bin/bash

VER=$( tmux -V | cut -c 6- )
CONF_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

BEFORE_19=$( echo "${VER} < 1.9" | bc )

if [ "${BEFORE_19}" -eq 1 ]; then
  tmux source-file "${CONF_DIR}/before-1.9.conf"
else
  tmux source-file "${CONF_DIR}/after-1.9.conf"
fi

:
