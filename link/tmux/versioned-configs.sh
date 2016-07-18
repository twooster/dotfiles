#!/bin/bash
TMUX_VER=$( tmux -V | cut -c 6- )
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

_load_tmux_configs() {
  for file in $@; do
    basename=$( basename "${file}" )
    noext=${basename%.conf}
    case "${noext}" in
      after-*)
        ver=${noext#after-}
        [ $( echo "${TMUX_VER} >= ${ver}" | bc ) -eq 1 ] && tmux source-file "${file}"
        ;;
      before-*)
        ver=${noext#before-}
        [ $( echo "${TMUX_VER} < ${ver}" | bc ) -eq 1 ] && tmux source-file "${file}"
        ;;
      *)
        tmux source-file "${file}"
    esac
  done
}

_load_tmux_configs "${SCRIPT_DIR}/*.conf"
