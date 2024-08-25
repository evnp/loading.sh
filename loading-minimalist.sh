#!/usr/bin/env bash

function loading {
  while true
  do
    echo -ne "$(
      LC_ALL=true tr -dc 'a-t' </dev/urandom \
      | head -c "$( tput cols )" \
      | sed 'y/abcdefghijklmnopqrstuvwxyz/■ ▪ ▬ ▮ ◆ ◢ ◣ ◥ ◤ ●◗◖●◀▲▼▶/'
    )\r"
  done &
}

loading "$@"
