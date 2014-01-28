if [ "$UNAME" = Darwin ]; then
    # put ports on the paths if /opt/local exists
    [ -x /opt/local -a ! -L /opt/local ] && {
        PORTS=/opt/local

        # setup the PATH and MANPATH
        PATH="$PORTS/bin:$PORTS/sbin:$PATH"
        MANPATH="$PORTS/share/man:$MANPATH"

        # nice little port alias
        alias port="sudo nice -n +18 $PORTS/bin/port"
    }

    # setup java environment. puke.
    JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
    ANT_HOME="/Developer/Java/Ant"
    export ANT_HOME JAVA_HOME
    LS_FLAGS="-hBG"

    pman() {
    man -t "${1}" | open -f -a /Applications/Preview.app/
    }
fi
