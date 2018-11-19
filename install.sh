#!/bin/bash

if [ "$( uname )" = "Darwin" ]; then
    LINK_FLAGS=-hs
else
    LINK_FLAGS=-ns
fi

export DOTFILES_DIR="$( cd "$( dirname -- "${BASH_SOURCE[0]}" )" && pwd )"
export AUTOLINK_DIR="${DOTFILES_DIR}/link"
export AUTORUN_DIR="${DOTFILES_DIR}/run"

VERBOSE=

autolink_all()
{
    local default_strategy="link"
    if [ "$3" = "merge-recursive" ] ; then
      default_strategy=merge-recursive
    fi
    debug Autolinking all in $1 to $2 with strategy ${default_strategy}
    local file
    find "$1" -maxdepth 1 -mindepth 1 -not -path '\.*' -print0 \
    | while IFS= read -d '' -r file ; do
        local name="${file##*/}"
        if [[ "${name}" == __* ]] ; then
            # __foo -> foo
            # therefore, ___foo -> _foo
            name="${name#__}"
        elif [[ "${name}" == _* ]] ; then
            # _foo -> .foo
            name=".${name#_}"
        fi
        local target="$2/${name}"

        if [ -d "${file}" ] ; then
            local strategy="${default_strategy}"
	    if [ -e "${file}/.dotfiles-strategy" ] ; then
                strategy="$( cat "${file}/.dotfiles-strategy" )"
            fi
            if [ "${strategy}" = "merge" -o "${strategy}" = "merge-recursive" ] ; then
                if [ ! -d "${target}" ]; then
                    if [ -e "${target}" ]; then
                      fatal "Destination folder ${target} (for ${file}) exists but is not a directory!"
                    fi
                    mkdir "${target}" || fatal Could not create directory "${target}"
                fi
                autolink_all "${file}" "${target}" "${strategy}"
                continue
            fi
        fi
        link "${file}" "${target}"
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
    echo x WARN "$@" >&2
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
    info Renaming existing $1 to $1~$i...
    mv -n "$1" "$1~$i" || warn Backup failed
}

link()
{
    local source="$1"
    local target="$2"
    debug Linking "${source}" to "${target}"
    # Note we have to test for symlink in case the symlink is dead
    if [ -L "${target}" ]; then
        # Symbolic link, so...
        local rl=$( readlink "${target}" )
        case "${rl}" in
          "${AUTOLINK_DIR}"*)
            #debug Removing existing autolink ${target}
            #rm "${target}" || warn Removal failed: ${target}
            : # noop
            ;;
          *)
            backup_rename "${target}"
            ;;
        esac
    elif [ -e "${target}" ]; then
        backup_rename "${target}"
    fi

    if [ ! -e "${target}" ]; then
        info LINK ${source} to ${target}
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
autolink_all "${AUTOLINK_DIR}" "${HOME}" "link"

info SOURCE bashrc
. ~/.bashrc

info STOP
