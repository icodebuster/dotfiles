autoload bashcompinit && bashcompinit
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C  # skip security check, use cache
fi

# Case-insensitive and hyphen-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

# ngrok completion (lazy-loaded on first use)
ngrok() {
  unfunction ngrok
  eval "$(command ngrok completion)"
  command ngrok "$@"
}

# Dart CLI completion
[[ -f /Users/JK/.dart-cli-completion/zsh-config.zsh ]] && . /Users/JK/.dart-cli-completion/zsh-config.zsh || true

# OpenClaw Completion
[[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]] && source "$HOME/.openclaw/completions/openclaw.zsh"