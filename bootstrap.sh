#!/usr/bin/env bash
# Invoked as `zsh bootstrap.sh` or `source` under zsh? Re-exec with bash so
# `read -rp`, arrays, and `[[ ]]` behave as intended.
if [[ -z "${BASH_VERSION:-}" ]]; then
  exec /usr/bin/env bash "$0" "$@"
fi
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Setting up dotfiles from $DOTFILES_DIR"

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install packages from Brewfile
read -rp "==> Install Homebrew packages from Brewfile? [y/N] " brew_answer
if [[ "$brew_answer" =~ ^[Yy]$ ]]; then
  echo "==> Installing missing Homebrew packages..."
  brew bundle --no-upgrade --file="$DOTFILES_DIR/Brewfile"
fi

CONFIG_PKGS=(aerospace atuin ghostty starship zellij)
HOME_PKGS=(zsh git ssh)
PRIVATE_PKG="dotfiles-private"

if ! command -v stow &>/dev/null; then
  echo "ERROR: stow is not installed (needed to create symlinks)." >&2
  echo "Install it with: brew install stow" >&2
  exit 1
fi

if ! git -C "$DOTFILES_DIR" diff --quiet -- "${CONFIG_PKGS[@]}" "${HOME_PKGS[@]}"; then
  echo "WARNING: You have uncommitted changes in package directories." >&2
  echo "Commit or stash them first — bootstrap will overwrite them." >&2
  git -C "$DOTFILES_DIR" diff --stat -- "${CONFIG_PKGS[@]}" "${HOME_PKGS[@]}"
  exit 1
fi

read -rp "==> Back up existing dotfiles before overwriting? [y/N] " backup_answer
if [[ "$backup_answer" =~ ^[Yy]$ ]]; then
  BACKUP_DIR="$HOME/.dotfile_backup/$(date +%Y-%m-%d_%H%M%S)"
  backup_file() {
    local target="$1"
    [[ -e "$target" || -L "$target" ]] || return 0
    local resolved
    resolved="$(realpath "$target" 2>/dev/null)" || true
    if [[ -n "$resolved" && "$resolved" == "$DOTFILES_DIR"* ]]; then
      return 0
    fi
    local rel="${target#$HOME/}"
    mkdir -p "$(dirname "$BACKUP_DIR/$rel")"
    cp -a "$target" "$BACKUP_DIR/$rel"
    echo "  Backed up: ~/$rel"
  }
  echo "==> Backing up existing files to $BACKUP_DIR"
  for pkg in "${CONFIG_PKGS[@]}"; do
    while IFS= read -r -d '' file; do
      backup_file "$HOME/.config/${file#$DOTFILES_DIR/$pkg/}"
    done < <(find "$DOTFILES_DIR/$pkg" -type f -not -name '.DS_Store' -print0)
  done
  for pkg in "${HOME_PKGS[@]}"; do
    while IFS= read -r -d '' file; do
      backup_file "$HOME/${file#$DOTFILES_DIR/$pkg/}"
    done < <(find "$DOTFILES_DIR/$pkg" -type f -not -name '.DS_Store' -print0)
  done
fi

echo "==> Stowing dotfiles (repo always wins)..."
cd "$DOTFILES_DIR"
stow --adopt -R -v -t "$HOME/.config" "${CONFIG_PKGS[@]}"
stow --adopt -R -v -t "$HOME" "${HOME_PKGS[@]}"
git -C "$DOTFILES_DIR" checkout -- "${CONFIG_PKGS[@]}" "${HOME_PKGS[@]}"

# Private submodule (optional — skip if not cloned with --recurse-submodules)
if [[ -f "$DOTFILES_DIR/$PRIVATE_PKG/.ssh/config.private" ]]; then
  echo "==> Stowing private dotfiles..."
  stow --adopt -R -v -t "$HOME" "$PRIVATE_PKG"
  git -C "$DOTFILES_DIR/$PRIVATE_PKG" checkout -- .
  chmod 400 "$HOME"/.ssh/*.pem 2>/dev/null || true
else
  echo "==> Skipping private dotfiles (submodule not initialized)."
  echo "    Run: git submodule update --init"
fi

# Restore editor settings (Cursor, VS Code)
read -rp "==> Restore editor settings and extensions? [y/N] " editor_answer
if [[ "$editor_answer" =~ ^[Yy]$ ]]; then
  "$DOTFILES_DIR/scripts/editors.sh" restore
fi

# Set up secrets template if not provided by private submodule
if [[ ! -f "$HOME/.secrets" ]]; then
  cat > "$HOME/.secrets" <<'EOF'
export GITHUB_USERNAME=
export GITHUB_TOKEN=
EOF
  echo "==> Created ~/.secrets template — fill in your values."
  echo "    Or add .secrets to the dotfiles-private submodule."
fi

echo "==> Done! Restart your shell or run: source ~/.zshrc"
