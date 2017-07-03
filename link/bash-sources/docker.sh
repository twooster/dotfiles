alias dc="docker-compose"

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

docker-remove-matching-images() {
  matching_images="$( docker images | cut -d' ' -f1 | grep -E -e "$1" )"

  echo Will erase:
  echo ${matching_images}
  read -p "Okay? [y/N]" yn
  if [ $yn = 'y' ]; then
    docker rmi ${matching_images}
  fi
}
