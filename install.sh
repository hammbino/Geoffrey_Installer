#!/usr/bin/env bash
set -euo pipefail

ZIP_URL="https://github.com/hammbino/Geoffrey_Public/archive/refs/heads/main.zip"
TARGET="$HOME/Repos/Geoffrey"

say() {
  printf '%s\n' "$1"
}

ask_yes() {
  prompt="$1"
  default="${2:-yes}"
  printf '%s [%s]: ' "$prompt" "$default" >&2
  read -r answer
  answer="${answer:-$default}"
  case "$answer" in
    y|yes|Y|YES) return 0 ;;
    *) return 1 ;;
  esac
}

ensure_macos() {
  if [ "$(uname -s)" != "Darwin" ]; then
    say "This Geoffrey installer is for Mac."
    say "Download Geoffrey from https://github.com/hammbino/Geoffrey_Public and run ./bin/geoffrey bootstrap."
    exit 1
  fi
}

ensure_basic_tools() {
  if ! command -v curl >/dev/null 2>&1; then
    say "curl is required and was not found."
    exit 1
  fi
  if ! command -v ditto >/dev/null 2>&1; then
    say "ditto is required and was not found."
    exit 1
  fi
}

download_geoffrey() {
  mkdir -p "$HOME/Repos"
  tmp_dir="$(mktemp -d)"
  zip_file="$tmp_dir/geoffrey.zip"

  say "Downloading Geoffrey..."
  curl -fL "$ZIP_URL" -o "$zip_file"

  say "Unpacking Geoffrey..."
  ditto -x -k "$zip_file" "$tmp_dir"
  extracted="$(find "$tmp_dir" -maxdepth 1 -type d -name 'Geoffrey_Public-*' | head -n 1)"
  if [ -z "$extracted" ]; then
    say "Download finished, but Geoffrey could not be found inside the zip."
    exit 1
  fi

  if [ -e "$TARGET" ]; then
    backup="$TARGET.backup.$(date +%Y%m%d-%H%M%S)"
    say "A Geoffrey folder already exists. Moving it to:"
    say "$backup"
    mv "$TARGET" "$backup"
  fi

  mv "$extracted" "$TARGET"
  say "Geoffrey is ready at:"
  say "$TARGET"
}

run_geoffrey() {
  cd "$TARGET"
  ./bin/geoffrey bootstrap
}

ensure_macos
ensure_basic_tools
download_geoffrey
run_geoffrey

