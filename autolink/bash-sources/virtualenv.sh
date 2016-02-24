#-------------------------------------------------------------------------------
# VIRTUALENV STUFF
#-------------------------------------------------------------------------------
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
  PY3=`which python3`
  MODARGS=""
  if [ ! -z "$PY3" ]; then
    if "$PY3" -m venv -h &> /dev/null; then
      PYTHON="$PY3"
      MODULE=venv
    elif "$PY3" -m virtualenv -h &> /dev/null; then
      PYTHON="$PY3"
      MODULE=virtualenv
    fi
  fi
  if [ -z "$PYTHON" ]; then
    PY2=`which python`
    if "$PY2" -m virtualenv -h &> /dev/null; then
      PYTHON="$PY2"
      MODULE=virtualenv
      MODARGS="--no-site-packages"
    fi
  fi

  if [ ! -z "$PYTHON" ]; then
    export WORKON_HOME=~/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON="$PYTHON"
    export VIRTUALENVWRAPPER_VIRTUALENV="$PYTHON"
    export VIRTUALENVWRAPPER_VIRTUALENV_ARGS="-m $MODULE $MODARGS"

    if [ -z "${PROJECT_HOME+x}" ]; then
      export PROJECT_HOME="$HOME/projects"
    fi
    . /usr/local/bin/virtualenvwrapper.sh

    alias wo="workon"
    alias woff="deactivate"
  fi
fi
