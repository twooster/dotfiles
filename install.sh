#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR="$( cd "$( dirname -- "${BASH_SOURCE[0]}" )" && pwd )"
LINK_DIR="${SCRIPT_DIR}/link"
TARGET_DIR="$HOME"
STRATEGY_FILE=".dotfiles-strategy"

if [[ "$( uname )" = "Darwin" ]]; then
    LINK_FLAGS=-hs
else
    LINK_FLAGS=-ns
fi

VERBOSE=
DRY_RUN=

cmd() {
    printf "  run: %s\n" "$*"
    if [[ -z "$DRY_RUN" ]] ; then
        "$@"
    fi
}

warn() {
    printf " warn: %s\n" "$*" >&2
}

info() {
    printf " info: %s\n" "$*"
}

debug() {
    if [[ -n "$VERBOSE" ]] ; then
        printf "debug: %s\n" "$*"
    fi
}

fatal() {
    printf "fatal: %s\n" "$*" >&2
    exit 1
}

link_dir()
{
    local source="$1"
    local target="$2"
    local strategy="$3"
    if [[ -e "${source}/${STRATEGY_FILE}" ]] ; then
        strategy="$( cat "${source}/${STRATEGY_FILE}" )"
    fi

    if [[ "$strategy" = "link" ]] ; then
        link "$source" "$target"
        return 0
    fi

    local substrategy
    if [[ "$strategy" != "merge-recursive" ]] ; then
        substrategy="link"
    fi

    if [[ -e "$target" ]] ; then
        if [[ ! -d "$target" ]] ; then
            fatal "Target folder ${target} (for ${source}) exists but is not a directory!"
        fi
    else
        cmd mkdir -p "$target" || fatal "Could not create directory ${target}"
    fi

    local src
    find "$source" -maxdepth 1 -mindepth 1 -not -name "$STRATEGY_FILE" -print0 \
    | while IFS= read -d '' -r src ; do
        local name="${src##*/}"
        if [[ "$name" == __* ]] ; then
            # __foo -> foo
            # therefore, ___foo -> _foo
            name="${name#__}"
        elif [[ "$name" == _* ]] ; then
            # _foo -> .foo
            name=".${name#_}"
        fi
        local target="$2/${name}"

        if [[ ! -d "$src" ]] ; then
            link "$src" "$target"
        else
            link_dir "$src" "$target" "$substrategy"
        fi
    done
}

backup_rename()
{
    local file="$1"
    local i=0
    while [[ -e "${file}~${i}" ]] ; do
        let i=i+1
    done
    info "Backup existing ${file} to ${file}~${i}"
    cmd mv -n "$file" "${file}~${i}" || \
      warn "Backup failed"
}

link()
{
    local source="$1"
    local target="$2"
    debug "Linking ${source} to ${target}"
    # Note we have to test for symlink in case the symlink is dead
    if [[ -L "$target" ]]; then
        # Symbolic link, so...
        local rl=$( readlink "$target" )
        case "$rl" in
          "$LINK_DIR"*)
            debug "Skipping existing link ${target}"
            return
            ;;
          *)
            backup_rename "$target"
            ;;
        esac
    elif [[ -e "$target" ]]; then
        backup_rename "$target"
    fi

    if [[ ! -e "$target" ]]; then
        cmd ln "$LINK_FLAGS" "$source" "$target" || \
          warn "ln failed ${source} to ${target}"
    else
        warn "Target exists, skipping: ${source} to ${target}"
    fi
}

while getopts "dvt:" opt ; do
    case "$opt" in
        d) DRY_RUN=1 ;;
        v) VERBOSE=1 ;;
        t) TARGET_DIR="$OPTARG" ;;
        *) fatal "Unknown option chosen ${opt}" ;;
    esac
done

info "Updating submodules"
cmd git submodule update --init
info "Installing dotfiles"
link_dir "$LINK_DIR" "$TARGET_DIR" "merge"
info "Complete"
