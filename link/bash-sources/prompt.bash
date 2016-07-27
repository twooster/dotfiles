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

parse_git_branch() {
  local git_status
  git_status="$(git status --no-short 2> /dev/null)" || return
  local branch_pattern="On branch ([^${IFS}]*)"
  local remote_pattern="Your branch is (ahead|behind)"
  local diverge_pattern="Your branch and (.*) have diverged"

  local state remote branch
  if [[ ! ${git_status}} =~ "working directory clean" ]]; then
    state="${LIGHT_RED}⚡"
  fi
  # add an else if or two here if you want to get more specific
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="${LIGHT_YELLOW}↑"
    else
      remote="${LIGHT_YELLOW}↓"
    fi
  fi
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="${LIGHT_YELLOW}↕"
  fi
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
  fi
  echo " [${branch}]${remote}${state}"
}

prompt_func() {
    local previous_return_value=$?
    local venv=""

    # Write history every prompt call
    history -a

    if [[ -n "$VIRTUAL_ENV" ]]; then
        venv="${RED}$(basename ${VIRTUAL_ENV})${LIGHT_GRAY}:"
    fi

    local prompt="${LIGHT_GRAY}\u@\h ${venv}${LIGHT_BLUE}\w${GREEN}$(parse_git_branch)${COLOR_NONE}"
    if test "${previous_return_value}" -eq 0; then
        PS1="${prompt}\n${BACK_GREEN}>>>${COLOR_NONE} "
    else
        local padded_rv=$(printf "%3d" "${previous_return_value}")
        PS1="${prompt}\n${BACK_RED}${padded_rv}${COLOR_NONE} "
    fi
}

PROMPT_COMMAND="prompt_func"
