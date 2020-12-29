#-------------------------------------------------------------------------------
# BASH COMPLETION
#-------------------------------------------------------------------------------

# File completion: ignore backups, CVS directories, python bytecode, vim swap
FIGNORE="~:CVS:#:.pyc:.swp:.swa:apache-solr-*"

[ -z "$BASH_COMPLETION" ] && {
    bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
    test -n "$PS1" && test $bmajor -gt 1 && {
        # search for a bash_completion file to source
        for f in /usr/local/etc/bash_completion \
                 /usr/pkg/etc/bash_completion \
                 /etc/bash_completion
        do
            [ -r "$f" ] && {
                . "$f"
                break
            }
        done
    }
    unset bash bmajor bminor
}
