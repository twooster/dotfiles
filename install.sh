#!/bin/bash

UNAME=`uname`
if [ "$UNAME" = "Darwin" ]; then
    LINK_FLAGS=-hs
else
    LINK_FLAGS=-ns
fi

export DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export AUTOLINK_DIR="$DOTFILES_DIR/autolink"
export AUTORUN_DIR="$DOTFILES_DIR/autorun"

VERBOSE=

autolink_all()
{
    for file in $( find "$1" -maxdepth 1 -mindepth 1 ); do
        local dest="$2/.${file##*/}"
        info Autolinking "${dest}"
        link "${file}" "${dest}"
    done
}

autorun_all()
{
    for file in $( find "$1" -mindepth 1 -executable ); do
        info Autorunning $file
        ${file}
    done
}

info()
{
    echo + "$@"
}

debug()
{
    [ -z "$VERBOSE" ] || echo ++ "$@"
}

fatal()
{
    echo +++ FATAL ERROR: "$@" &>2
    exit 1
}

backup_rename()
{
    local i=0
    while [[ -e "$1~$i" ]]; do
        let i=i+1
    done
    debug Renaming existing file $1 to $1~$i...
    mv "$1" "$1~$i"
}

link()
{
    local source="$1"
    local target="$2"
    # Note we have to test for symlink in case the symlink is dead
    if [ -e "$target" -o -h "$target" ]; then
        if [ -h "$target" ]; then
            # Symbolic link, so...
            local rl=$( readlink "$target" )
            if [[ "$rl" == "$AUTOLINK_DIR"* ]]; then
                # Kill an existing link to a dotfile
                debug Removing existing autolink $target
                rm "$target" || warn Removal failed
            else
                info Backing up existing normal link $target
                backup_rename "$target" || warn Backup failed
            fi
        else
            info Backing up existing file $target
            backup_rename "$target" || warn Backup failed
        fi
    fi
    if [ ! -f "$target" ]; then
        ln $LINK_FLAGS "$source" "$target" || warn Unable to link $1 to $2
    fi
}

while getopts "fvt:" OPTION
do
    case $OPTION in
        v   ) VERBOSE=1;;
        t   ) DOTFILES_TARGET="$OPTARG";;
        *   ) fatal Unknown option chosen;;
    esac
done
info Updating all submodules
git submodule update --init
info Autorunning all autorun scripts
autorun_all "${AUTORUN_DIR}"
info Autolinking all autolink files
autolink_all "${AUTOLINK_DIR}" "${HOME}"
info Re-sourcing bashrc
. ~/.bashrc
