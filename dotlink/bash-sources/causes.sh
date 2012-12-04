alias cdc="cd ~/causes"

function sc() {
    eval "SKIP_CHECKS=test_history $@"
}

function prodcon() {
    local server="${1:-cauapp01}"
    ssh -t "dev@${server}" prodcon causes $2
}
