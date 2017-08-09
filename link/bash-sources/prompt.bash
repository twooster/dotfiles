         RED="\[\e[0;31m\]"
      YELLOW="\[\e[0;33m\]"
LIGHT_YELLOW="\[\e[1;33m\]"
       GREEN="\[\e[0;32m\]"
        BLUE="\[\e[0;34m\]"
  LIGHT_BLUE="\[\e[1;34m\]"
   LIGHT_RED="\[\e[1;31m\]"
 LIGHT_GREEN="\[\e[1;32m\]"
       WHITE="\[\e[1;37m\]"
  LIGHT_GRAY="\[\e[0;37m\]"
        CYAN="\[\e[0;36m\]"
    BACK_RED="\[\e[41m\]"
   BACK_CYAN="\[\e[46m\]"
  BACK_GREEN="\[\e[42m\]"
  COLOR_NONE="\[\e[0m\]"

__parse_git_branch() {
  local branch=
  local diverge=
  local dirty=

  branch="$( git rev-parse --abbrev-ref HEAD 2>/dev/null )"
  [ $? -eq 0 ] || return

  if git diff --no-ext-diff --cached --quiet || git diff --no-ext-diff --quiet ; then
    dirty="${LIGHT_RED}⚡"
  fi


  local count="$( git rev-list --count --left-right @{u}...HEAD 2>/dev/null )"
  case "$count" in
    "") # no upstream
      ;;
    "0	0") # equal to upstream
      #diverge="${LIGHT_YELLOW}●"
      ;;
    "0	"*) # ahead of upstream
      diverge="${LIGHT_YELLOW}↑"
      ;;
    *"	0") # behind upstream
      diverge="${LIGHT_YELLOW}↓"
      ;;
    *)      # diverged from upstream
      diverge="${LIGHT_YELLOW}↕"
  esac

  echo " [${branch}]${diverge}${dirty}"
}

__prompt_func() {
    local previous_return_value=$?
    local venv=""

    # Write history every prompt call
    history -a

    if [[ -n "${VIRTUAL_ENV}" ]]; then
        venv="${LIGHT_RED}$( basename -z -- ${VIRTUAL_ENV} )${LIGHT_GRAY}:"
    fi

    local user_color="${LIGHT_GRAY}"
    if [ "${UID}" = "0" ]; then
      user_color="${RED}"
    fi


    local prompt="${user_color}\u@\h ${venv}${LIGHT_BLUE}\w${GREEN}$(__parse_git_branch)${COLOR_NONE}"
    if [ "${previous_return_value}" = "0" ]; then
      PS1="${prompt}\n${BACK_GREEN}>>>${COLOR_NONE} "
    else
        local padded_rv=$(printf "%3d" "${previous_return_value}")
        PS1="${prompt}\n${BACK_RED}${padded_rv}${COLOR_NONE} "
    fi
    return ${previous_return_value}
}

PROMPT_COMMAND="__prompt_func"
