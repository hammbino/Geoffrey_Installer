#!/usr/bin/env bash
set -euo pipefail

REPO="hammbino/Geoffrey-WhiteGlove"
TARGET="$HOME/Repos/Geoffrey-WhiteGlove"

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
    say "For another system, clone $REPO manually and run ./bin/geoffrey bootstrap."
    exit 1
  fi
}

ensure_git() {
  if command -v git >/dev/null 2>&1; then
    say "OK  Git installed"
    return 0
  fi

  say "Git is required. macOS will install it through Apple's Command Line Tools."
  say "A system installer window may open. Finish that install, then run this Geoffrey command again."
  xcode-select --install 2>/dev/null || true
  exit 1
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    say "OK  Homebrew installed"
    return 0
  fi

  say "Homebrew is not installed. Geoffrey can use it to install GitHub CLI and Node.js."
  if ! ask_yes "Install Homebrew now? yes/no" "yes"; then
    say "Stopped. Install Homebrew later from https://brew.sh, then run this again."
    exit 1
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  if ! command -v brew >/dev/null 2>&1; then
    say "Homebrew installed, but Terminal has not picked it up yet."
    say "Close Terminal, reopen it, and run this Geoffrey command again."
    exit 1
  fi
}

ensure_gh() {
  if command -v gh >/dev/null 2>&1; then
    say "OK  GitHub CLI installed"
  else
    ensure_homebrew
    say "Installing GitHub CLI..."
    brew install gh
  fi

  if gh auth status >/dev/null 2>&1; then
    say "OK  GitHub signed in"
  else
    say "GitHub sign-in is needed so this installer can clone Geoffrey's private repo."
    gh auth login --web
  fi
}

clone_or_update_geoffrey() {
  mkdir -p "$HOME/Repos"

  if [ -d "$TARGET/.git" ]; then
    say "Updating Geoffrey..."
    git -C "$TARGET" pull
  elif [ -e "$TARGET" ]; then
    say "The folder already exists but is not a Git repo:"
    say "$TARGET"
    say "Move or rename it, then run this Geoffrey command again."
    exit 1
  else
    say "Downloading Geoffrey..."
    gh repo clone "$REPO" "$TARGET"
  fi
}

run_geoffrey() {
  cd "$TARGET"
  ./bin/geoffrey bootstrap
}

ensure_macos
ensure_git
ensure_gh
clone_or_update_geoffrey
run_geoffrey

