#!/bin/sh

# shellcheck shell=dash

PROG_NAME="shttp"
DATA_DIR="${XDG_DATA_HOME:-"$HOME/.local/share"}"
HTTP_VERSION="HTTP/1.1"

read -r message

req_method="$(echo "$message" | awk '{print $1}')"
req_path="$(echo "$message" | awk '{print $2}')"
req_version="$(echo "$message" | awk '{print $3}' | tr -d '\r')"

# 1: status
# 2: body?
# 3: mime?
send() {
  local status_message body headers content_type content_length
  status_message="$(grep "^$1" "$DATA_DIR/$PROG_NAME/status_codes")"

  echo "* $req_method $req_path: $status_message" >&2

  body="${2:-"$status_message"}"
  content_type="${3:-"text/plain"}"
  content_length="${#body}"

  headers="$(
    printf "%s\r\n%s\r\n%s" \
      "content-type: $content_type" \
      "content_length: $((content_length + 2))" \
      "allow: GET"
  )"

  printf "%s %s\r\n%s\r\n\r\n%s\r\n" \
    "$HTTP_VERSION" "${status_message:-$1}" \
    "$headers" "$body"

  exit
}

get_mimetype() {
  case "$1" in
    *.js) echo "application/javascript" ;;
    *.html) echo "text/html" ;;
    *.css) echo "text/css" ;;
    *) file --mime-type "$1" | awk '{print $2}' || send 500 ;;
  esac
}

[ "$req_version" != "$HTTP_VERSION" ] \
  && send 505

[ "$req_method" != "GET" ] \
  && send 405

file_path="$(realpath "$(pwd)$req_path")"

[ -d "$file_path" ] \
  && file_path="$file_path/index.html"

[ ! -e "$file_path" ] \
  && [ -e "$file_path.html" ] \
  && file_path="$file_path.html"

[ ! -e "$file_path" ] \
  && send 404

case "$file_path" in
  $(pwd)/*)
    content="$(tr -d "\0" < "$file_path")" || send 401
    mime="$(get_mimetype "$file_path")"
    send 200 "$content" "$mime"
    ;;

  *) send 401;;
esac