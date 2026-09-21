#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Rectangle has no CLI/URL-scheme hook for exporting its config (only GUI
# buttons in Preferences > General), but it natively auto-loads this exact
# filename from its Application Support folder on launch, then renames it
# with a timestamp so it isn't reapplied on subsequent launches. So export
# stays a manual, occasional step (like scripts/editors.sh's export), while
# restore is fully automatable and is what bootstrap.sh calls.
APP_CONFIG_DIR="$HOME/Library/Application Support/Rectangle"
APP_CONFIG_FILE="$APP_CONFIG_DIR/RectangleConfig.json"
REPO_FILE="$DOTFILES_DIR/rectangle/RectangleConfig.json"
DEFAULT_EXPORT_SOURCE="$HOME/Downloads/RectangleConfig.json"

export_rectangle() {
  local src="${1:-$DEFAULT_EXPORT_SOURCE}"

  if [[ ! -f "$src" ]]; then
    echo "ERROR: no exported config found at $src" >&2
    echo "In Rectangle: Preferences > General > Export, save as RectangleConfig.json," >&2
    echo "then run: $(basename "$0") export [path-to-file]" >&2
    exit 1
  fi

  echo "==> Importing exported config from $src..."
  mkdir -p "$(dirname "$REPO_FILE")"
  jq . "$src" > "$REPO_FILE"
  echo "  $(basename "$REPO_FILE")"
}

restore_rectangle() {
  if [[ ! -f "$REPO_FILE" ]]; then
    echo "==> Skipping Rectangle (no config in dotfiles)"
    return
  fi

  echo "==> Restoring Rectangle settings..."
  mkdir -p "$APP_CONFIG_DIR"
  cp "$REPO_FILE" "$APP_CONFIG_FILE"

  if pgrep -qx Rectangle; then
    killall Rectangle
    sleep 1
  fi
  open -ga Rectangle

  echo "  Rectangle (re)launched and will pick up the config automatically."
}

cmd="${1:-}"

case "$cmd" in
  export)
    export_rectangle "${2:-}"
    echo "==> Export complete. Review changes with: git diff rectangle/"
    ;;
  restore)
    restore_rectangle
    echo "==> Restore complete."
    ;;
  *)
    echo "Usage: $(basename "$0") {export [path]|restore}"
    echo ""
    echo "  export   Copy an already-exported RectangleConfig.json into dotfiles repo"
    echo "           (default source: ~/Downloads/RectangleConfig.json)"
    echo "  restore  Push dotfiles repo config into Rectangle's config folder and relaunch it"
    exit 1
    ;;
esac
