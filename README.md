# dotfiles

Personal macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick start (new machine)

```bash
git clone git@github.com:icodebuster/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

This will:

1. Install Homebrew (if missing)
2. Install all packages from the `Brewfile`
3. Bail if there are uncommitted changes in package directories
4. Optionally back up existing dotfiles before overwriting
5. Symlink all configs to the right places via `stow --adopt`
6. Optionally restore Cursor & VS Code settings and extensions
7. Create a `~/.secrets` template for API keys

## Stow packages

Stow creates symlinks from this repo into two targets: `~/.config` and `$HOME`.

### `CONFIG_PKGS` → `~/.config`

| Package     | Repo Path              | Symlink Target                   |
| ----------- | ---------------------- | -------------------------------- |
| `aerospace` | `aerospace.toml`       | `~/.config/aerospace.toml`       |
| `atuin`     | `atuin/config.toml`    | `~/.config/atuin/config.toml`    |
| `ghostty`   | `ghostty/config`       | `~/.config/ghostty/config`       |
| `starship`  | `starship.toml`        | `~/.config/starship.toml`        |
| `zellij`    | `zellij/config.kdl`    | `~/.config/zellij/config.kdl`    |
| `zellij`    | `zellij/layouts/*.kdl` | `~/.config/zellij/layouts/*.kdl` |

### `HOME_PKGS` → `$HOME`

| Package | Repo Path           | Symlink Target        |
| ------- | ------------------- | --------------------- |
| `git`   | `.gitconfig`        | `~/.gitconfig`        |
| `git`   | `.gitignore_global` | `~/.gitignore_global` |
| `zsh`   | `.zshrc`            | `~/.zshrc`            |
| `zsh`   | `.config/zsh/*.zsh` | `~/.config/zsh/*.zsh` |

## Editor configs (Cursor & VS Code)

Editor settings live in `cursor/` and `vscode/` but are **not stow-managed** — macOS stores them in `~/Library/Application Support/`. The `scripts/editors.sh` script handles syncing.

```bash
# Pull current settings from the apps into the repo
./scripts/editors.sh export

# Push repo settings into the apps + install extensions
./scripts/editors.sh restore
```

Each editor directory contains:

| File               | Purpose                                  |
| ------------------ | ---------------------------------------- |
| `settings.json`    | Editor settings                          |
| `keybindings.json` | Custom keybindings (Cursor only)         |
| `extensions.txt`   | Extension IDs for automated install      |
| `extensions.md`    | Categorized extension list for reference |

## Homebrew (Brewfile)

The `Brewfile` tracks all formulae, casks, and fonts. To see what's changed since the last snapshot:

```bash
brew-dump           # show new/stale packages vs Brewfile
brew-dump --write   # overwrite Brewfile with current state, show git diff
```

`brew-dump` (no flag) is non-destructive — it only prints the diff so you can manually update the curated Brewfile. `--write` replaces it entirely with `brew bundle dump --describe`.

## Manual stow usage

```bash
cd ~/dotfiles

# Link ~/.config packages
stow -t "$HOME/.config" aerospace atuin ghostty starship zellij

# Link $HOME packages
stow -t "$HOME" zsh git

# Unlink a package
stow -D -t "$HOME/.config" ghostty
stow -D -t "$HOME" zsh
```

## Adding a new config

1. Create a directory named after the tool (e.g. `foo/`)
2. Place the config file inside it:
   - For `~/.config/foo/config.toml` → `foo/config.toml` (flat, no `.config/` nesting)
   - For `~/.foorc` → `foo/.foorc` (mirrors path relative to `$HOME`)
3. Add the package name to the correct array in `bootstrap.sh`:
   - `CONFIG_PKGS` for `~/.config` targets
   - `HOME_PKGS` for `$HOME` targets
