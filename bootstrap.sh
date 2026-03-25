#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

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
HOME_PKGS=(zsh git)

# Create symlinks via stow (--adopt resolves conflicts by pulling existing
# files into the package, then git checkout restores the repo versions)
if ! git -C "$DOTFILES_DIR" diff --quiet -- "${CONFIG_PKGS[@]}" "${HOME_PKGS[@]}"; then
  echo "WARNING: You have uncommitted changes in package directories."
  echo "Running bootstrap will DISCARD these changes via git checkout."
  git -C "$DOTFILES_DIR" diff --stat -- "${CONFIG_PKGS[@]}" "${HOME_PKGS[@]}"
  read -rp "Continue? [y/N] " answer
  [[ "$answer" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }
fi

echo "==> Stowing dotfiles..."
cd "$DOTFILES_DIR"
stow --adopt -v -t "$HOME/.config" "${CONFIG_PKGS[@]}"
stow --adopt -v -t "$HOME" "${HOME_PKGS[@]}"
git -C "$DOTFILES_DIR" checkout -- "${CONFIG_PKGS[@]}" "${HOME_PKGS[@]}"

# Restore editor settings (Cursor, VS Code)
read -rp "==> Restore editor settings and extensions? [y/N] " editor_answer
if [[ "$editor_answer" =~ ^[Yy]$ ]]; then
  "$DOTFILES_DIR/scripts/editors.sh" restore
fi

# Set up secrets template if it doesn't exist
if [[ ! -f "$HOME/.secrets" ]]; then
  cat > "$HOME/.secrets" <<'EOF'
export GITHUB_USERNAME=
export GITHUB_TOKEN=
EOF
  echo "==> Created ~/.secrets — fill in your values."
fi

echo "==> Done! Restart your shell or run: source ~/.zshrc"
