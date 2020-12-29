#!/bin/bash
set -e

TMUX_VER=$( tmux -V | sed -E 's/tmux ([0-9]+(\.[0-9]+)).*/\1/' )
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

_load_tmux_configs() {
  for file in "$@"; do
    basename=$( basename "$file" )
    case "$basename" in
      *-to-*.conf)
        noext=${basename%.conf}
        minVer=${noext%-to-*}
        maxVer=${noext#*-to-}
        if [[ "$( echo "$TMUX_VER < $maxVer && $TMUX_VER >= $minVer" | bc )" -eq 1 ]]; then
          echo Load "$file"
          tmux source-file "$file"
        else
          echo Skip "$file"
        fi
        ;;
      *.conf)
        echo Load "$file"
        tmux source-file "$file"
        ;;
      *)
        ;;
    esac
  done
}

_load_tmux_configs "${SCRIPT_DIR}"/*.conf
