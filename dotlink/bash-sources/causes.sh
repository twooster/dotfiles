alias cdc="cd ~/causes"

function prodcon() {
    local server="${1:-cauapp01}"
    ssh -t "dev@${server}" prodcon causes $2
}
