alias cdc="cd ~/causes"

function sc() {
    local skip=test_history

    if [ "${1:0:2}" == "--" ]; then
        skip=${1:2}
        shift
    fi

    SKIP_CHECKS=$skip "$@"
}

function prodcon() {
    local server="${1:-cauapp01}"
    ssh -t "dev@${server}" prodcon causes $2
}
