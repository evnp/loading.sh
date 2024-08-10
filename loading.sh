#!/usr/bin/env bash

function loading { local fps cvrg dots cols alph shap orig rand mask repl
  if [[ "$1" == 'stop' ]]
  then
    kill "$LOADING_PID" &>/dev/null
    kill "$(<"$TMPDIR/LOADING_PID")" &>/dev/null
    unset LOADING_PID &>/dev/null
    rm -f "$TMPDIR/LOADING_PID"
    echo -ne '\r\033[K'
    return
  fi

  # Parse arguments: fps (integer), cvrg (boolean), dots (boolean)
  fps="$1"; ! [[ "${fps}" =~ ^[0-9]+$ ]] && \
    echo "loading: first argument (fps) must be an integer" && exit 1
  cvrg=FALSE; [[ " $* " == *' --converge '* ]] && cvrg=TRUE
  dots=FALSE; [[ " $* " == *' --dots '* ]] && dots=TRUE

  cols="$( tput cols )" # Record width (in char columns) of current terminal pane.
  alph="$( echo {a..z} | tr -d ' ' )" # Construct full alphabet string, a-z.

  shap="■ ▪ ▬ ▮ ◆ ◢ ◣ ◥ ◤ ●◗◖●◀▲▼▶" # Determine symbol alphabet.
  [[ "${dots}" == TRUE ]] && shap=" $( printf ".·:⠇˙%.0s" {1..5} )"

  # Construct a string of length matching width of terminal pane, random chars a-z:
  # shellcheck disable=SC2005,SC2018
  orig="$( echo "$( LC_ALL=true tr -dc 'a-z' </dev/urandom | head -c "${cols}" )" )"
  rand="${orig}"

  while true
  do # Pick 10 random chars from alphabet:
    # shellcheck disable=SC2005,SC2018
    mask="$( echo "$( LC_ALL=true tr -dc 'a-z' </dev/urandom | head -c 10 )" )"
    repl="$( rev <<< "${mask}" )" # Reverse mask to perform random swap of chars.

    [[ "${cvrg}" != TRUE ]] && rand="${orig}" # If not converging, reset rand to orig.
    rand="$( sed "y/${mask}/${repl}/" <<< "${rand}" )" # Perform random swap of chars.
    echo -ne "$( sed "y/${alph}/${shap}/" <<< "${rand}" )\r"
    # Print, replacing a-z chars with shapes, and overwriting last line of output.

    sleep "$( bc -l <<< "1/${fps}" )" # Sleep long enough to establish correct FPS.
  done &

  export LOADING_PID="$!"
  echo "$LOADING_PID" > "$TMPDIR/LOADING_PID"
}

loading "$@"
