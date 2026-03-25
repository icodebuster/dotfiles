#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

CURSOR_APP_DIR="$HOME/Library/Application Support/Cursor/User"
VSCODE_APP_DIR="$HOME/Library/Application Support/Code/User"

CURSOR_REPO_DIR="$DOTFILES_DIR/cursor"
VSCODE_REPO_DIR="$DOTFILES_DIR/vscode"

CURSOR_FILES=(settings.json keybindings.json)
VSCODE_FILES=(settings.json)

copy_settings() {
  local src_dir="$1" dest_dir="$2"
  shift 2
  local files=("$@")

  for f in "${files[@]}"; do
    if [[ -f "$src_dir/$f" ]]; then
      cp "$src_dir/$f" "$dest_dir/$f"
      echo "  $f"
    fi
  done
}

export_editor() {
  local name="$1" app_dir="$2" repo_dir="$3" cli="$4"
  shift 4
  local files=("$@")

  echo "==> Exporting $name settings..."
  mkdir -p "$repo_dir"
  copy_settings "$app_dir" "$repo_dir" "${files[@]}"

  if command -v "$cli" &>/dev/null; then
    "$cli" --list-extensions | sort > "$repo_dir/extensions.txt"
    echo "  extensions.txt ($(wc -l < "$repo_dir/extensions.txt") extensions)"
  else
    echo "  ⚠ $cli CLI not found, skipping extensions"
  fi
}

restore_editor() {
  local name="$1" app_dir="$2" repo_dir="$3" cli="$4"
  shift 4
  local files=("$@")

  if [[ ! -d "$repo_dir" ]]; then
    echo "==> Skipping $name (no config in dotfiles)"
    return
  fi

  echo "==> Restoring $name settings..."
  mkdir -p "$app_dir"
  copy_settings "$repo_dir" "$app_dir" "${files[@]}"

  if [[ -f "$repo_dir/extensions.txt" ]] && command -v "$cli" &>/dev/null; then
    echo "  Installing extensions..."
    local installed failed=0
    installed=$("$cli" --list-extensions)
    while IFS= read -r ext; do
      [[ -z "$ext" ]] && continue
      if echo "$installed" | grep -qi "^${ext}$"; then
        continue
      fi
      "$cli" --install-extension "$ext" --force 2>/dev/null || ((failed++))
    done < "$repo_dir/extensions.txt"
    echo "  extensions synced ($( [[ $failed -gt 0 ]] && echo "$failed failed, " )$(wc -l < "$repo_dir/extensions.txt") total)"
  elif ! command -v "$cli" &>/dev/null; then
    echo "  ⚠ $cli CLI not found, skipping extensions"
  fi
}

cmd="${1:-}"

case "$cmd" in
  export)
    export_editor "Cursor" "$CURSOR_APP_DIR" "$CURSOR_REPO_DIR" "cursor" "${CURSOR_FILES[@]}"
    export_editor "VS Code" "$VSCODE_APP_DIR" "$VSCODE_REPO_DIR" "code" "${VSCODE_FILES[@]}"
    echo "==> Export complete. Review changes with: git diff cursor/ vscode/"
    ;;
  restore)
    restore_editor "Cursor" "$CURSOR_APP_DIR" "$CURSOR_REPO_DIR" "cursor" "${CURSOR_FILES[@]}"
    restore_editor "VS Code" "$VSCODE_APP_DIR" "$VSCODE_REPO_DIR" "code" "${VSCODE_FILES[@]}"
    echo "==> Restore complete."
    ;;
  *)
    echo "Usage: $(basename "$0") {export|restore}"
    echo ""
    echo "  export   Copy current editor settings + extensions into dotfiles repo"
    echo "  restore  Push dotfiles repo settings into editors + install extensions"
    exit 1
    ;;
esac
