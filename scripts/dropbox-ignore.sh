#!/usr/bin/env bash
# =============================================================================
# Dropbox Ignore — mark heavy / regenerable paths so Dropbox skips them.
# Run from a project:  dropbox-ignore
# Or with a path:      dropbox-ignore ~/path/to/project
# Go `bin/` is only ignored when go.mod exists at the project root (avoids
# clobbering repos that version a bin/ directory).
# =============================================================================

set -euo pipefail

TARGET="${1:-.}"
TARGET="$(cd "$TARGET" && pwd)"

ignore_dir() {
  local p="$TARGET/$1"
  if [[ -d "$p" ]]; then
    xattr -w com.dropbox.ignored 1 "$p"
    echo "Ignored: $1"
  fi
}

ignore_file() {
  local p="$TARGET/$1"
  if [[ -f "$p" ]]; then
    xattr -w com.dropbox.ignored 1 "$p"
    echo "Ignored: $1"
  fi
}

# Python setuptools: *.egg-info at repo root (glob, not a literal name).
ignore_egg_info_dirs() {
  local d
  shopt -s nullglob
  for d in "$TARGET"/*.egg-info; do
    [[ -d "$d" ]] || continue
    xattr -w com.dropbox.ignored 1 "$d"
    echo "Ignored: $(basename "$d")"
  done
  shopt -u nullglob
}

ignore_ds_store_files() {
  local f
  while IFS= read -r -d '' f; do
    xattr -w com.dropbox.ignored 1 "$f"
    echo "Ignored: ${f#"$TARGET"/}"
  done < <(find "$TARGET" -name .DS_Store -type f -print0 2>/dev/null)
}

ignore_go_bin_if_module() {
  if [[ -f "$TARGET/go.mod" && -d "$TARGET/bin" ]]; then
    xattr -w com.dropbox.ignored 1 "$TARGET/bin"
    echo "Ignored: bin (Go module)"
  fi
}

echo "Running Dropbox ignore on: $TARGET"
echo "-------------------------------------"

# ---- Git ----
ignore_dir ".git"

# ---- Node / JavaScript / TypeScript ----
ignore_dir "node_modules"
ignore_dir "dist"
ignore_dir "build"
ignore_dir ".next"
ignore_dir ".nuxt"
ignore_dir ".cache"
ignore_dir ".parcel-cache"
ignore_dir "coverage"
ignore_dir ".turbo"
ignore_dir "out"
ignore_dir ".svelte-kit"

# ---- Python ----
ignore_dir ".venv"
ignore_dir "venv"
ignore_dir "__pycache__"
ignore_dir ".pytest_cache"
ignore_dir ".mypy_cache"
ignore_dir ".ruff_cache"
ignore_egg_info_dirs
ignore_dir ".eggs"
ignore_dir "htmlcov"

# ---- Go ----
ignore_dir "vendor"
ignore_go_bin_if_module

# ---- iOS / macOS ----
ignore_dir "Pods"
ignore_dir "Carthage"
ignore_dir ".build"
ignore_dir "DerivedData"

# ---- Android ----
ignore_dir ".gradle"
ignore_dir ".idea"
ignore_dir "captures"

# ---- General ----
ignore_ds_store_files
ignore_dir "tmp"
ignore_dir "temp"
ignore_dir "logs"

echo "-------------------------------------"
echo "Done. These paths will not sync to Dropbox."
echo ""
echo "NOTE: .env files are NOT ignored and will sync."
echo "This is intentional — they hold your local config."
