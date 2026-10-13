[[ -o interactive ]] && print "🟥 󰊠 icodebuster 󰊠 🟥"

# Dotfiles repo root (resolved from the .zshrc symlink)
export DOTFILES_DIR="${${(%):-%N}:A:h:h}"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load modular configs
source ~/.config/zsh/core.zsh
source ~/.config/zsh/completion.zsh
source ~/.config/zsh/history.zsh
source ~/.config/zsh/tools.zsh
source ~/.config/zsh/dev_config.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/functions.zsh
source ~/.config/zsh/env_paths.zsh
source ~/.config/zsh/secrets.zsh
