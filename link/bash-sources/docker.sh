dclog () {
  docker-compose logs "--tail=${2:-50}" -f "$1"
}

docker-volumes-dangling() {
  docker volume ls -f dangling=true
}

docker-remove-dangling-volumes() {
  local volumes="$(docker volume ls -f dangling=true -q)"
  if [ "${volumes}" = "" ]; then
    echo "No volumes to remove. Aborting."
    return
  fi
  printf "%s\n" "${volumes}"
  read -p 'The above volumes will all be removed; continue? [y/N] ' yn
  if [ "${yn}" = "y" ]; then
    echo 'Deleting...'
    docker volume rm ${volumes} && echo Done.
  else
    echo 'Aborted.'
  fi
}
