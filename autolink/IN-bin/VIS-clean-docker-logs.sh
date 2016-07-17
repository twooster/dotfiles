#!/bin/bash

if [ $# -lt 1 ]; then
  echo Supply container name or --all to clear all logs
  exit 1
fi

name=$1
if [ "${name}" = "-a" -o "${name}" = "--all" ]; then
  name=
fi


for container_id in $(docker ps -a --filter="name=${name}" -q); do
  file=$(docker inspect "${container_id}" | grep -G '"LogPath": "*"' | sed -e 's/.*"LogPath": "//g' | sed -e 's/",//g')

  if [ -f "${file}" ]; then
    rm "${file}";
  fi
done
