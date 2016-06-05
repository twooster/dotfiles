#!/bin/bash

UNAME=`uname`
if [ "$UNAME" = "Darwin" ]; then
    LINK_FLAGS=-hs
else
    LINK_FLAGS=-ns
fi

export DOTFILES_TARGET="$HOME"
export DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export AUTOLINK_DIR="$DOTFILES_DIR/autolink"
export AUTORUN_DIR="$DOTFILES_DIR/autorun"

VERBOSE=

autolink_all()
{
    for file in $( find "$AUTOLINK_DIR" -maxdepth 1 -mindepth 1 ); do
        link "${file}" ".${file##*/}"
    done
}

autorun_all()
{
    for file in $( find "$AUTORUN_DIR" -mindepth 1 -executable ); do
        debug Running autorun file $file
        ${file}
    done
}

debug()
{
    [ -z "$VERBOSE" ] || echo +++ "$@"
}

info()
{
    echo --- "$@"
}

fatal()
{
    echo XXX FATAL ERROR: "$@" &>2
    exit 1
}

backup_rename()
{
    local i=0
    while [[ -e "$1~$i" ]]; do
        let i=i+1
    done
    debug Renaming existing file $1 to $1~$i...
    mv "$1" "$1~$i" || fatal Unable to rename $1 to $1~$i
}

link()
{
    debug Linking $1 to $2
    local source="$1"
    local target="$DOTFILES_TARGET/${2-$1}"
    # Note we have to test for symlink in case the symlink is dead
    if [ -e "$target" -o -h "$target" ]; then
        if [ -h "$target" ]; then
            # Symbolic link, so...
            local rl=$( readlink "$target" )
            if [[ "$rl" == "$AUTOLINK_DIR"* ]]; then
                # Kill an existing link to a dotfile
                debug Killing Existing autolink for $target
                rm "$target" || warn Removal failed, skipping
            else
                info Backing up existing link for $target
                backup_rename "$target" || warn Backup failed, skipping
            fi
        else
            info Backing up existing file for $target
            backup_rename "$target" || warn Backup failed, skipping
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
autorun_all
info Autolinking all autolink files
autolink_all
info Re-sourcing bashrc
. ~/.bashrc
