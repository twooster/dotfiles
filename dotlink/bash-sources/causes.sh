alias cdc="cd ~/causes"

function sc() {
    local skip=test_history

    if [ "${1:0:2}" == "--" ]; then
        skip=${1:2}
        shift
    fi

    local args
    printf -v args "%q " "$@"
    eval SKIP_CHECKS="$skip" $args
}

function wip() {
  SKIP_CHECKS=all git commit -m "WIP WIP WIP $@"
}

function prodcon() {
    ssh -t "dev@${1:-caujob02.prod.causes.com}" prodcon causes ${RAILS_ENV:-prodro}
}

function prodro() {
  prodcon
}

function prodrw() {
  RAILS_ENV=prodrw prodcon
}
