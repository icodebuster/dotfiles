# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Bootstrap & Setup

```bash
# Full setup from scratch
./bootstrap.sh

# Restow all symlinks without reinstalling Homebrew packages
stow --adopt -t ~/.config aerospace atuin ghostty starship zellij && git checkout -- .
stow --adopt -t ~ zsh git ssh && git checkout -- .

# Restow private submodule (after git submodule update --init)
stow --adopt -t ~ dotfiles-private && git -C dotfiles-private checkout -- .
chmod 400 ~/.ssh/*.pem

# Sync editor settings (Cursor & VS Code)
./scripts/editors.sh export   # pull from app → repo
./scripts/editors.sh restore  # push from repo → app + install extensions

# Sync Rectangle settings (export the config from the app's UI first)
./scripts/rectangle.sh export   # copy an already-exported RectangleConfig.json → repo
./scripts/rectangle.sh restore  # push from repo → Rectangle's config folder + relaunch
```

## Package Architecture

GNU Stow manages symlinks using a two-tier strategy defined in `bootstrap.sh`:

**CONFIG_PKGS** — packages that target `~/.config`. Files inside the package folder are linked under `~/.config/`. Some packages use a subdirectory (e.g. `atuin/atuin/`) so the tool's config lands in `~/.config/atuin/`; others place files directly (e.g. `starship/starship.toml` → `~/.config/starship.toml`). Never place a `.config/<name>/` path inside these packages — the stow target is already `~/.config`.
- `aerospace`, `atuin`, `ghostty`, `starship`, `zellij`

**HOME_PKGS** — packages that mirror the `$HOME` tree. Can contain both `~/` dotfiles and `~/.config/` subdirectories in the same package.
- `zsh`, `git`, `ssh` (`ssh/.ssh/config` → `~/.ssh/config`)

**Decision rule**: If a tool uses *only* `~/.config/<tool>/` → `CONFIG_PKGS`. If it uses `~/` dotfiles or a mix → `HOME_PKGS`.

**Bootstrap adopt pattern**: `stow --adopt` is always followed immediately by `git checkout -- .` to prevent existing system files from overwriting repo versions.

**`dotfiles-private` submodule** — a separate **private** Git repo added as a submodule at the repo root. Stowed to `$HOME` like a `HOME_PKGS` package. Contains sensitive files that should not be in a public repo:
- `.ssh/config.private` — SSH host definitions (IPs, usernames, key paths)
- `.ssh/*.pem` — SSH private keys
- `.secrets` — shell environment secrets (tokens, API keys)

The `ssh/` package commits only the public SSH config (`ssh/.ssh/config`) which `Include`s `~/.ssh/config.private` from the private submodule. Bootstrap automatically runs `chmod 400` on PEM files after stowing since Git doesn't preserve permissions.

## Adding a New Config Package

1. Create a folder named after the tool (e.g., `neovim/`)
2. Place files at the path they should appear, relative to the stow target (e.g., `neovim/init.lua` → `~/.config/neovim/init.lua`)
3. Add the package name to `CONFIG_PKGS` or `HOME_PKGS` in `bootstrap.sh`
4. Run `stow --adopt -t ~/.config neovim && git checkout -- .`

## Zsh Configuration Structure

`~/.zshrc` is a thin loader. All logic lives in `zsh/.config/zsh/`:

| File | Purpose |
|------|---------|
| `core.zsh` | Locale, keybindings, `AUTO_CD` |
| `completion.zsh` | Zsh completion system |
| `history.zsh` | History size, dedup, sharing |
| `tools.zsh` | Tool init: Starship, Zoxide, FZF, Atuin, syntax highlighting |
| `dev_config.zsh` | Version managers: rbenv, pyenv, fnm, Go, Flutter, Java (lazy-loaded) |
| `aliases.zsh` | 38 shell aliases |
| `functions.zsh` | Helper functions: `xc`, `vc`, `git-local-email`, `dev`, `smartech-add-device` |
| `env_paths.zsh` | Extra PATH entries |
| `secrets.zsh` | Sources `~/.secrets` (not committed) |

**Performance patterns**: Slow `eval` calls (Starship, Zoxide, Atuin) are cached in `~/.cache/zsh-eval-cache/` via `_cached_eval()` in `tools.zsh`. Version managers (rbenv, pyenv, Java) use lazy-load stubs that initialize only on first use.

## Editor Configs (Cursor & VS Code)

These are **not stow-managed** because macOS stores them in `~/Library/Application Support/`. The `scripts/editors.sh` script handles export/restore:

- Cursor: `~/Library/Application Support/Cursor/User/`
- VS Code: `~/Library/Application Support/Code/User/`

Config files live in `cursor/` and `vscode/` directories in the repo:

| File | Cursor | VS Code |
|------|--------|---------|
| `settings.json` | ✓ | ✓ |
| `keybindings.json` | ✓ | — |
| `extensions.txt` | ✓ | ✓ |
| `extensions.md` | ✓ | ✓ |

## Rectangle Config

Rectangle stores its settings in the `com.knollsoft.Rectangle` macOS preferences domain, but it also has a native config JSON format (Preferences > General > Export/Import) that it auto-loads from `~/Library/Application Support/Rectangle/RectangleConfig.json` on launch — so it's **not stow-managed**, and `scripts/rectangle.sh` doesn't touch `defaults`/`plutil` at all:

- `export [path]` — copies an already-exported config (default source: `~/Downloads/RectangleConfig.json`) into `rectangle/RectangleConfig.json`. Manual/occasional, like `editors.sh export` — Rectangle has no CLI/URL-scheme hook for triggering its own Export button, so you export from the app's UI first.
- `restore` — copies `rectangle/RectangleConfig.json` into Rectangle's config folder and relaunches it; Rectangle picks up the file automatically on launch (then timestamps/retires it so it isn't reapplied next time). Fully automated — this is what `bootstrap.sh` calls.

## Environment Variables

- `DOTFILES_DIR` — set in `.zshrc` to the repo root (resolved from the `.zshrc` symlink). Available to all shell functions.

## Key Files

- `Brewfile` — taps, CLI/dev `brew` formulae, and font casks; update with `brew bundle dump --force` (app casks live in `casks.json` instead — see below)
- `casks.json` — manifest of app casks (name, description, `default`, optional `trusted`); `bootstrap.sh` installs `default: true` entries silently and prompts per-app for the rest. Hand-edit the `default` flags to change what installs without asking
- `bootstrap.sh` — idempotent setup script; safe to re-run
- `rectangle/RectangleConfig.json` — Rectangle app settings; sync with `scripts/rectangle.sh` (see Rectangle Config above)
- `.stow-local-ignore` — files Stow skips (README, Brewfile, bootstrap.sh, .git, config-plan.md)
- `git/.gitignore_global` — global git ignore patterns
- `zellij/zellij/layouts/dev.kdl` — Zellij layout launched by the `dev` shell function
