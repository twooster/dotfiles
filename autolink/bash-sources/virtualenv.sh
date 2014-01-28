#-------------------------------------------------------------------------------
# VIRTUALENV STUFF
#-------------------------------------------------------------------------------
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=~/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=`which python`
    export VIRTUALENVWRAPPER_VIRTUALENV=`which python`
    export VIRTUALENVWRAPPER_VIRTUALENV_ARGS="-m virtualenv --no-site-packages"
    . /usr/local/bin/virtualenvwrapper.sh

    alias wo="workon"
    alias woff="deactivate"
fi
