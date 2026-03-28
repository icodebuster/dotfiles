# ----- Eval cache helper -----
# Caches the output of slow `tool init` commands. Regenerate with: rm ~/.cache/zsh-eval-cache/*
_cached_eval() {
  local name="$1" init_cmd="$2"
  local cache_dir="$HOME/.cache/zsh-eval-cache"
  local cache_file="$cache_dir/$name"
  mkdir -p "$cache_dir"
  if [[ ! -f "$cache_file" || "$(command -v "$name" 2>/dev/null)" -nt "$cache_file" ]]; then
    eval "$init_cmd" > "$cache_file" 2>/dev/null
  fi
  source "$cache_file"
}

# ----- Starship -----
export STARSHIP_CONFIG=~/.config/starship.toml
_cached_eval starship 'starship init zsh'

# ----- Zoxide -----
_cached_eval zoxide 'zoxide init zsh'

# ----- FZF -----
[[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
[[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]] && source /opt/homebrew/opt/fzf/shell/completion.zsh

# ----- Zsh Autosuggestions -----
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ----- Zsh Syntax Highlighting -----
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ----- Atuin -----
[[ -f "$HOME/.atuin/bin/env" ]] && . "$HOME/.atuin/bin/env"
_cached_eval atuin 'atuin init zsh'
