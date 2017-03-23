#!/bin/bash

if [ "$TERM" != "${TERM/256color/}" ]; then
  FORMAT=esc256
else
  FORMAT=esc
fi

SH_ARGS=( --failsafe -f "${FORMAT}" "--style-file=${FORMAT}.style" )
for source in "$@"; do
  case $source in
    *ChangeLog|*changelog)
      source-highlight "${SH_ARGS[@]}" --lang-def=changelog.lang -i "$source"
      ;;
    *Makefile|*makefile)
      source-highlight "${SH_ARGS[@]}" --lang-def=makefile.lang -i "$source"
      ;;
    *.tar|*.tgz|*.gz|*.bz2|*.xz)
      lesspipe "$source"
      ;;
    *)
      source-highlight "${SH_ARGS[@]}" --infer-lang -i "$source"
      ;;
    esac
done
