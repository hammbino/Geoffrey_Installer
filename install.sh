#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/hammbino/Geoffrey_Public.git"
ZIP_URL="https://github.com/hammbino/Geoffrey_Public/archive/refs/heads/main.zip"
TARGET="$HOME/Geoffrey"

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
}

backup_existing_target() {
  if [ -e "$TARGET" ]; then
    backup="$TARGET.backup.$(date +%Y%m%d-%H%M%S)"
    say "A Geoffrey folder already exists but is not update-ready. Moving it to:"
    say "$backup"
    mv "$TARGET" "$backup"
  fi
}

download_zip_fallback() {
  if ! command -v ditto >/dev/null 2>&1; then
    say "ditto is required for the zip fallback and was not found."
    exit 1
  fi

  backup_existing_target
  mkdir -p "$(dirname "$TARGET")"
  tmp_dir="$(mktemp -d)"
  zip_file="$tmp_dir/geoffrey.zip"

  say "Downloading Geoffrey zip fallback..."
  curl -fL "$ZIP_URL" -o "$zip_file"

  say "Unpacking Geoffrey..."
  ditto -x -k "$zip_file" "$tmp_dir"
  extracted="$(find "$tmp_dir" -maxdepth 1 -type d -name 'Geoffrey_Public-*' | head -n 1)"
  if [ -z "$extracted" ]; then
    say "Download finished, but Geoffrey could not be found inside the zip."
    exit 1
  fi

  mv "$extracted" "$TARGET"
  say "Geoffrey is ready at:"
  say "$TARGET"
  say "This zip fallback cannot use git pull updates. Re-run the installer later after Git is available."
}

install_or_update_geoffrey() {
  mkdir -p "$(dirname "$TARGET")"

  if command -v git >/dev/null 2>&1; then
    if [ -d "$TARGET/.git" ]; then
      say "Updating Geoffrey..."
      git -C "$TARGET" pull --ff-only
    else
      backup_existing_target
      say "Cloning Geoffrey..."
      git clone "$REPO_URL" "$TARGET"
    fi
    say "Geoffrey is ready at:"
    say "$TARGET"
    return 0
  fi

  say "Git was not found. Geoffrey will use the zip fallback this time."
  say "After setup, Geoffrey can help install Git so future updates are easier."
  download_zip_fallback
}

run_geoffrey() {
  cd "$TARGET"
  ./bin/geoffrey bootstrap
}

ensure_macos
ensure_basic_tools
install_or_update_geoffrey
run_geoffrey
