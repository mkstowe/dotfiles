#!/usr/bin/env bash
set -euo pipefail

target="${1:-}"
raw_dir="${2:-$HOME/Pictures/screenshots}"
prefix="${3:-screenshot}"

if [[ -z "$target" ]]; then
  echo "usage: screenshot_capture.sh <target> [save_dir] [prefix]" >&2
  exit 2
fi

case "$raw_dir" in
  '~')
    save_dir="$HOME"
    ;;
  \~/*)
    save_dir="$HOME/${raw_dir#\~/}"
    ;;
  '$HOME')
    save_dir="$HOME"
    ;;
  '$HOME/'*)
    save_dir="$HOME/${raw_dir#\$HOME/}"
    ;;
  *)
    save_dir="$raw_dir"
    ;;
esac

mkdir -p "$save_dir"
file="$save_dir/${prefix}-${target}-$(date +%Y-%m-%d_%H-%M-%S).png"
exec grimblast --notify save "$target" "$file"
