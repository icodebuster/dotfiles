# Taps
# Third-party formula/cask lines below carry `trusted: true` themselves
# (Homebrew's Tap Trust feature). `dart-lang/dart` is trusted at the tap
# level since fvm pulls Dart SDK formulae from it dynamically by version.
tap "antoniorodr/memo"
tap "dart-lang/dart", trusted: true
tap "leoafarias/fvm"
tap "nikitabobko/tap"
tap "openclaw/tap"
tap "steipete/tap"

# Shell and prompt
brew "zsh"                          # UNIX shell
brew "starship"                     # Cross-shell prompt
brew "zsh-autosuggestions"          # Fish-like autosuggestions for zsh
brew "zsh-syntax-highlighting"      # Fish-like syntax highlighting for zsh
brew "zoxide"                       # Smarter cd command
brew "fzf"                          # Fuzzy finder
brew "atuin"                        # Shell history search
brew "tmux"                         # Terminal multiplexer
brew "zellij"                       # Terminal multiplexer (layout-first)
brew "bash"                         # Updated Bash shell

# CLI tools
brew "eza"                          # Modern replacement for ls (also does tree)
brew "bat"                          # cat with syntax highlighting
brew "htop"                         # Interactive process viewer
brew "jq"                           # Command-line JSON processor
brew "wget"                         # Internet file retriever
brew "fastfetch"                    # System info (like neofetch, faster)
brew "git-extras"                   # Extra git utilities
brew "gh"                           # GitHub CLI
brew "duti"                         # Set default apps for file types on macOS
brew "stow"                         # Symlink farm manager (for dotfiles)
brew "direnv"                       # Environment variable manager loader that loads .envrc on the current directory.

# Media and files
brew "ffmpeg"                       # Audio/video processing toolkit
brew "imagemagick"                  # Image manipulation tools
brew "czkawka"                      # Duplicate file finder

# Dev - Ruby
brew "rbenv"                        # Ruby version manager

# Dev - Python
brew "pyenv-virtualenv"             # Pyenv plugin for virtualenvs (includes pyenv)
brew "python"                       # Latest Python runtime (auto-upgrades)
brew "pipx"                         # Install Python CLI tools in isolated envs
brew "uv"                           # Fast Python package installer (Rust)

# Dev - Go
brew "go"                           # Go programming language

# Dev - JavaScript / Node
brew "fnm"                          # Fast Node version manager (Rust)
brew "pnpm"                         # Fast package manager
brew "yarn"                         # JavaScript package manager

# Dev - Mobile
brew "fastlane"                     # Build and release mobile apps
brew "leoafarias/fvm/fvm", trusted: true  # Flutter SDK version manager
brew "ideviceinstaller"             # Manage apps on iOS devices
brew "watchman"                     # File watcher (used by React Native)

# Dev - Java / Android
brew "openjdk@17"                   # Java 17 runtime (used by gradle)
brew "gradle"                       # Build automation tool (use ./gradlew per project)

# Dev - Other
brew "awscli"                       # AWS command-line interface

# AI / Productivity
brew "antoniorodr/memo/memo", trusted: true   # Manage Apple Notes and Reminders from CLI
brew "openclaw/tap/gogcli", trusted: true     # Google CLI (Gmail, Calendar, Drive) — formerly steipete/tap/gogcli
brew "steipete/tap/imsg", trusted: true       # Send/read iMessage from terminal
brew "steipete/tap/summarize", trusted: true  # Summarize links to clean text

# Fonts
cask "font-hack-nerd-font"              # Hack Nerd Font
cask "font-fira-code-nerd-font"         # Fira Code Nerd Font
cask "font-jetbrains-mono-nerd-font"    # JetBrains Mono Nerd Font
cask "font-meslo-lg-nerd-font"          # Meslo LG Nerd Font
cask "font-caskaydia-cove-nerd-font"    # Cascadia Code Nerd Font (Microsoft)
cask "font-geist-mono-nerd-font"        # Geist Mono Nerd Font (Vercel)
cask "font-monaspice-nerd-font"         # Monaspace Nerd Font (GitHub)
cask "font-iosevka-nerd-font"           # Iosevka Nerd Font
cask "font-victor-mono-nerd-font"       # Victor Mono Nerd Font (cursive italics)
cask "font-commit-mono-nerd-font"       # Commit Mono Nerd Font
cask "font-zed-mono-nerd-font"          # Zed Mono Nerd Font
cask "font-sf-mono-nerd-font-ligaturized" # SF Mono with ligatures
cask "font-sauce-code-pro-nerd-font"    # Source Code Pro Nerd Font (Adobe)
cask "font-roboto-mono-nerd-font"       # Roboto Mono Nerd Font (Google)
cask "font-symbols-only-nerd-font"      # Nerd Font icons only (patch any font)

# Apps
# App casks are managed via casks.json + bootstrap.sh's interactive installer,
# not listed here directly.

# ---------------------------------------------------------------------------
# Redundant or rarely used — uncomment if needed
# ---------------------------------------------------------------------------

# Dev - Python
# cask "anaconda"                    # Redundant: conflicts with pyenv approach

# CI / Testing
# brew "gitlab-runner"               # Niche: usually only needed on CI machines
