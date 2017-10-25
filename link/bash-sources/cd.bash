function __rebuild_dynamic_binpath() {
  # If remove ":_AAA_:*:_ZZZ_:" from within the PATH; helps in case
  # the path was modified between `cd`-ing
  if [[ "${PATH}" == *":_ZZZ_:"* ]] ; then
    # Ensure we have a leading colon for below matches
    if [[ "${PATH}" == "_AAA_:"* ]] ; then
      PATH="${PATH#*:_ZZZ_:}"
    else
      PATH="${PATH%:_AAA_:*}:${PATH#*:_ZZZ_:}"
    fi
  fi

  if [[ "${PWD}/" == "${HOME}/"* ]]; then
    local stack=( )
    local curdir="${PWD}"
    local idx

    while true ; do
      stack[${#stack[@]}]="${curdir}/bin"
      if [[ "${curdir}" == "${HOME}" ]] ; then break ; fi
      curdir="${curdir%/*}"  # dirname
    done

    PATH="_ZZZ_:${PATH}"
    for (( idx=${#stack[@]}-1 ; idx >= 0 ; idx-- )) ; do
      PATH="${stack[${idx}]}:${PATH}"
    done
    PATH="_AAA_:${PATH}"
  fi
}

function cd() {
  # If we're being called in a script context we're not going to bother, it's
  # only for "interactive" executions
  if [ "${#FUNCNAME[@]}" -gt 1 ]; then
    builtin cd "$@"
  else
    builtin cd "$@"
    __rebuild_dynamic_binpath
  fi
}

__rebuild_dynamic_binpath
