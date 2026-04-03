[[ -o interactive ]] && print "🟥 󰊠 icodebuster 󰊠 🟥"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Dotfiles repo root. ~/.zshrc may be a real file in $HOME (dirname + /.. → /Users — wrong);
# only trust the two-level-up path when it looks like the repo (has scripts/editors.sh).
_zrc="${HOME}/.zshrc:A"
_candidate="$(cd "$(dirname "$_zrc")/.." && pwd)"
if [[ -f "$_candidate/scripts/editors.sh" ]]; then
  export DOTFILES_DIR="$_candidate"
else
  export DOTFILES_DIR="${HOME}/.dotfiles"
fi
unset _zrc _candidate

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
