#!/bin/sh

PROG_NAME="shttp"
DATA_DIR="${XDG_DATA_HOME:-"$HOME/.local/share"}"
BIN_DIR="${XDG_DATA_BIN:-"$HOME/.local/bin"}"

if [ "$1" = "clean" ]; then
  echo "* uninstalling $PROG_NAME"
  # shellcheck disable=2115
  rm -rf "$DATA_DIR/$PROG_NAME"
  rm -f "$BIN_DIR/shttp"
else
  echo "* installing $PROG_NAME"
  mkdir -p "$DATA_DIR/$PROG_NAME"
  mkdir -p "$BIN_DIR"
  cp -r lib/* "$DATA_DIR/$PROG_NAME"
  install -m 755 shttp.sh "$BIN_DIR/shttp"
  echo "* make sure to add $BIN_DIR to your PATH variable"
fi

echo "all done :)"
