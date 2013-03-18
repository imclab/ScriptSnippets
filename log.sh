#!/bin/bash

_V=0

while getopts "v" OPTION
do
  case $OPTION in
    v) _V=1
      ;;
  esac
done


function log () {
  if [[ $_V -eq 1 ]]; then
    echo "$@"
  fi
}


log "some text"
