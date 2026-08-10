#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd "$(dirname "$0")" && pwd)
script="$script_dir/../packages/bk-log/files/usr/bin/bk-log"

bash -n "$script"
if rg -n -i 'curl|wget|pastebin|http://' "$script"; then
  echo 'bk-log contains an upload path' >&2
  exit 1
fi
