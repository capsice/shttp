#!/bin/sh

# shellcheck shell=dash

PORT=8080
BIND=localhost
PROG_NAME="shttp"
DATA_DIR="${XDG_DATA_HOME:-"$HOME/.local/share"}"

help() {
  cat <<- EOF
Usage $PROG_NAME [ -p {PORT} ] [ -b {BIND} ]

where: -p = PORT (number)
       -b = BIND (addr/if)

example: $PROG_NAME -p 8080 -b 0.0.0.0

EOF
  exit 1
}

die() {
  echo "$@" >&2
  exit 1
}

[ ! -d "$DATA_DIR/$PROG_NAME" ] \
  && die "shttp not installed." \
    "please install it with ./install.sh"

while getopts "p:b:" opt; do
  case "$opt" in
    p) PORT="$OPTARG" ;;
    b) BIND="$OPTARG" ;;
    *) help ;;
  esac
done

echo "* listening on http://$BIND:$PORT"

socat TCP-LISTEN:"$PORT",bind="$BIND",reuseaddr,fork \
  EXEC:"$DATA_DIR/$PROG_NAME/handler.sh" 2>&1
