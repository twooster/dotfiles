AUTOLINK_DIR='./home'
: ${TARGET="$HOME"}
: ${AUTOLINK=1}
: ${SUBMODULE_UPDATE=1}
: ${FORCE=}

main()
{
    while getopts "fAaMmt:" OPTION
    do
        case $OPTION in
            A   ) AUTOLINK=;;
            a   ) AUTOLINK=1;;
            M   ) SUBMODULE_UPDATE=;;
            m   ) SUBMODULE_UPDATE=1;;
            f   ) FORCE=1;;
            t   ) TARGET="$OPTARG";;
            *   ) fatal Unknown option chosen;;
        esac
    done
    [ -n "$AUTOLINK" ] && autolink
    [ -n "$SUBMODULE_UPDATE" ] && submodule-update
}

autolink()
{
    (
        cd "$AUTOLINK_DIR"
        dotlink-pwd-files
    )
}

submodule-update()
{
    git submodule update --init
}

dotlink-pwd-files()
{
    for file in $( find . -depth 1 ); do
        dotlink ${file#./}
    done
}

dotlink()
{
    link "$1" ".$1"
}

warn()
{
    echo "$*" >&2
}

fatal()
{
    warn $@
    exit 1
}

link()
{
    local flags=-s
    local source="$1"
    local target="$TARGET/${2-$1}"
    [ "x$FORCE" == x ] || flags=${flags}fF
    ln $flags "$source" "$target" || warn "Unable to link $source to $target"
}



main "$@"
