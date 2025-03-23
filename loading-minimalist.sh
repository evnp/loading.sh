#!/usr/bin/env bash

# loading.sh 0.0.2

set -euo pipefail

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
