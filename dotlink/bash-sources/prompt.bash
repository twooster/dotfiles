        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

function parse_git_branch() {
  local git_status
  git_status="$(git status 2> /dev/null)" || return
  local branch_pattern="^# On branch ([^${IFS}]*)"
  local remote_pattern="# Your branch is (.*) of"
  local diverge_pattern="# Your branch and (.*) have diverged"

  local state remote branch
  if [[ ! ${git_status}} =~ "working directory clean" ]]; then
    state="${LIGHT_RED}⚡"
  fi
  # add an else if or two here if you want to get more specific
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="${YELLOW}↑"
    else
      remote="${YELLOW}↓"
    fi
  fi
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="${YELLOW}↕"
  fi
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
  fi
  # Causes pairing helpers
  local solo_name=$(git config solo.name)
  local current_name=$(git config user.name)
  local pair
  if [[ -n ${solo_name} && ${solo_name} != ${current_name} ]]; then
      pair="$WHITE + ${current_name#* + }"
  fi
  echo " [${branch}]${remote}${state}${pair}"
}

function prompt_func() {
    local previous_return_value=$?
    local venv=""

    if [[ -n "$VIRTUAL_ENV" ]]; then
        venv="${RED}$(basename ${VIRTUAL_ENV})${LIGHT_GRAY}:"
    fi
    
    local prompt="${LIGHT_GRAY}\u@\h ${venv}${BLUE}\w${GREEN}$(parse_git_branch)${COLOR_NONE}"
    if test $previous_return_value -eq 0
    then
        PS1="${prompt}\n# "
    else
        PS1="${prompt}\n${LIGHT_RED}*${COLOR_NONE} "
    fi
}

PROMPT_COMMAND=prompt_func
