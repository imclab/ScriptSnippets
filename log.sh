#!/bin/bash

_V=0
_T=0

while getopts "vt" OPTION
do
  case $OPTION in
    v) _V=1
      ;;
    t) _T=1
      ;;
  esac
done


function log () {
  if [[ $_V -eq 1 ]]; then
    echo "$@"
  fi
}


log "some text ${_T}"
