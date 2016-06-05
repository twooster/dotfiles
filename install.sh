#!/bin/bash

UNAME=`uname`
if [ "$UNAME" = "Darwin" ]; then
    LINK_FLAGS=-hs
else
    LINK_FLAGS=-ns
fi

TARGET="$HOME"
DOTFILES_DIR="$PWD"
AUTOLINK_DIR="$DOTFILES_DIR/autolink"
AUTOLINK=1
SUBMODULE_UPDATE=1
FORCE=
VERBOSE=

main()
{
    while getopts "AaMmfvt:" OPTION
    do
        case $OPTION in
            A   ) AUTOLINK=;;
            a   ) AUTOLINK=1;;
            M   ) SUBMODULE_UPDATE=;;
            m   ) SUBMODULE_UPDATE=1;;
            L   ) NO_LOCAL_FILE=1;;
            S   ) NO_SOURCE_BASHRC=1;;
            f   ) FORCE=1;;
            v   ) VERBOSE=1;;
            t   ) TARGET="$OPTARG";;
            *   ) fatal Unknown option chosen;;
        esac
    done
    [ -n "$AUTOLINK" ] && autolink
    [ -n "$SUBMODULE_UPDATE" ] && submodule_update
    [ -z "$NO_LOCAL_FILE" ] && install_dotfiles_local_sh
    [ -z "$NO_SOURCE_BASHRC" ] && . ~/.bashrc
}

autolink()
{
    autolink_files_in "$AUTOLINK_DIR"
}

submodule_update()
{
    git submodule update --init
}

autolink_files_in()
{
    for file in $( find "$1" -maxdepth 1 -mindepth 1 ); do
        autolink_file ${file}
    done
}

autolink_file()
{
    link "$1" ".${1##*/}"
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

backup_rename()
{
    local i=0
    while [[ -e "$1~$i" ]]; do
        let i=i+1
    done
    echo Renaming existing file $1 to $1~$i...
    mv "$1" "$1~$i" || fatal Unable to rename $1 to $1~$i
}

link()
{
    local flags="$LINK_FLAGS"
    local source="$1"
    local target="$TARGET/${2-$1}"
    [ -n "$VERBOSE" ] && flags="$flags -v"
    # Note we have to test for symlink in case the symlink is dead
    if [[ -e "$target" || -h "$target" ]]; then
        if [ -n "$FORCE" ]; then
            flags="$flags -f"
        elif [ -h "$target" ]; then
            # Symbolic link, so...
            local rl=$( readlink "$target" )
            if [[ "$rl" == "$AUTOLINK_DIR"* ]]; then
                # Kill an existing link to a dotfile
                rm "$target" && [ -n "$VERBOSE" ] && echo Removed existing autolink link to $target
            else
                backup_rename "$target"
            fi
        else
            backup_rename "$target"
        fi
    fi
    ln $flags "$source" "$target"
}

install_dotfiles_local_sh()
{
    echo "export DOTFILES_BASE=\"$DOTFILES_DIR\" DOTFILES=\"$AUTOLINK_DIR\"" > "${AUTOLINK_DIR}/bash-sources/dotfiles-local-GENERATED.sh"
}

main "$@"
