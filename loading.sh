#!/usr/bin/env bash

function loading {
  local cols alph shps orig shuf mask repl
  local alp1 alp2 alp3 alp4

  if [[ " $* " == *' -f '* ||" $* " == *' --fin '* || " $* " == *' fin '* ]]
  then
    kill "$LOADING_PID" &>/dev/null
    unset LOADING_PID &>/dev/null
    if [[ -f "$TMPDIR/LOADING_PID" ]]; then
      kill "$(<"$TMPDIR/LOADING_PID")" &>/dev/null
      rm -f "$TMPDIR/LOADING_PID"
    fi
    echo -ne '\r\033[K'
    return
  fi

  # Parse arguments: fps (integer), cvrg (boolean)
  fps=20; [[ "$*" =~ ([0-9]+) ]] && fps="${BASH_REMATCH[0]}"
  [[ " $* " == *' -c '* || " $* " == *' --converge '* || " $* " == *' converge '* ]] \
    && cvrg=TRUE

  # Determine symbol alphabet:
  shps=()
  alp1="■ ▪ ▬ ▮ ◆ ◢ ◣ ◥ ◤ ●◗◖●◀▲▼▶"
  alp2=" $( printf ".·:⠇˙%.0s" {1..5} )"
  alp3=" $( printf "▁▂▃▅▇%.0s" {1..5} )"
  alp4=" $( printf "_⎽-⎻⎺%.0s" {1..5} )"
  [[ " $* " == *' -s '* || " $* " == *' --shapes '* || " $* " == *' shapes '* ]] && \
    shps+=( "${alp1}" )
  [[ " $* " == *' -d '* || " $* " == *' --dots '* || " $* " == *' dots '* ]] && \
    shps+=( "${alp2}" )
  [[ " $* " == *' -b '* || " $* " == *' --bars '* || " $* " == *' bars '* ]] && \
    shps+=( "${alp3}" )
  [[ " $* " == *' -l '* || " $* " == *' --lines '* || " $* " == *' lines '* ]] && \
    shps+=( "${alp4}" )
  ! (( ${#shps[@]} )) &&
    shps+=( "${alp1}" "${alp2}" "${alp3}" "${alp4}" )
  shps="${shps[$(( RANDOM % ${#shps[@]} ))]}"

  cols="$( tput cols )" # Record width (in char columns) of current terminal pane.
  alph="$( echo {a..z} | tr -d ' ' )" # Construct full alphabet string, a-z.

  # Construct a string of length matching width of terminal pane, random chars a-z:
  # shellcheck disable=SC2005,SC2018
  orig="$( echo "$( LC_ALL=true tr -dc 'a-z' </dev/urandom | head -c "${cols}" )" )"
  shuf="${orig}"

  while true
  do # Pick 10 random chars from alphabet:
    # shellcheck disable=SC2005,SC2018
    mask="$( echo "$( LC_ALL=true tr -dc 'a-z' </dev/urandom | head -c 10 )" )"
    repl="$( rev <<< "${mask}" )" # Reverse mask to perform random swap of chars.

    [[ "${cvrg}" != TRUE ]] && shuf="${orig}" # If not converging, reset shuf to orig.

    if [[ -n "${repl}" && -n "${shps}" ]]; then
      shuf="$( sed "y/${mask}/${repl}/" <<< "${shuf}" )" # Perform random char swap.
      echo -ne "$( sed "y/${alph}/${shps}/" <<< "${shuf}" )\r"
      # Print, replacing a-z chars with shpses, and overwriting last lnes of output.
    fi

    sleep "$( bc -l <<< "1/${fps}" )" # Sleep long enough to establish correct FPS.
  done &

  export LOADING_PID="$!"
  echo "$LOADING_PID" > "$TMPDIR/LOADING_PID"
}

loading "$@"
