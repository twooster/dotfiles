#!/bin/bash

if [ "$( uname )" = "Darwin" ]; then
    LINK_FLAGS=-hs
else
    LINK_FLAGS=-ns
fi

export DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export AUTOLINK_DIR="${DOTFILES_DIR}/autolink"
export AUTORUN_DIR="${DOTFILES_DIR}/autorun"

VERBOSE=

autolink_all()
{
    debug Autolinking all in $1 to $2
    local file
    for file in $( find "$1" -maxdepth 1 -mindepth 1 ); do
        local trunc="${file##*/}"
        case "${trunc}" in
          IN-*)
              autolink_all "${file}" "$2/${trunc##IN-}"
              ;;
          VIS-*)
              link "${file}" "$2/${trunc##VIS-}"
              ;;
          *)
              link "${file}" "$2/.${trunc}"
            ;;
        esac
    done
}

autorun_all()
{
    local file
    for file in $( find "$1" -mindepth 1 -executable ); do
        info RUN ${file}
        ${file}
    done
}

warn()
{
    echo x WARN "$@" &>2
}

info()
{
    echo + "$@"
}

debug()
{
    [ -z "${VERBOSE}" ] || echo ++ "$@"
}

fatal()
{
    echo xx FATAL "$@" &>2
    exit 1
}

backup_rename()
{
    local i=0
    while [ -e "$1~$i" ]; do
        let i=i+1
    done
    info Renaming existing file $1 to $1~$i...
    mv "$1" "$1~$i" || warn Backup failed
}

link()
{
    local source="$1"
    local target="$2"
    info LINK ${source} to ${target}
    # Note we have to test for symlink in case the symlink is dead
    if [ -e "${target}" -o -h "${target}" ]; then
        if [ -h "${target}" ]; then
            # Symbolic link, so...
            local rl=$( readlink "${target}" )
            case "${rl}" in
              "${AUTOLINK_DIR}"*)
                debug Removing existing autolink ${target}
                rm "${target}" || warn Removal failed: ${target}
                ;;
              *)
                backup_rename "${target}"
                ;;
            esac
        else
            backup_rename "${target}"
        fi
    fi
    if [ ! -f "${target}" ]; then
        ln ${LINK_FLAGS} "${source}" "${target}" || warn ln failed ${source} to ${target}
    else
        warn Target exists, skipping: ${source} to ${target}
    fi
}

while getopts "vt:" opt
do
    case "${opt}" in
        v) VERBOSE=1 ;;
        t) DOTFILES_TARGET="${OPTARG}" ;;
        *) fatal Unknown option chosen ;;
    esac
done

info START

info GIT Updating submodules
git submodule update --init

autorun_all  "${AUTORUN_DIR}"
autolink_all "${AUTOLINK_DIR}" "${HOME}"

info SOURCE bashrc
. ~/.bashrc

info STOP
