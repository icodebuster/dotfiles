SECRETS_FILE="$HOME/.secrets"

if [[ ! -f "$SECRETS_FILE" ]]; then
  cat > "$SECRETS_FILE" <<'EOF'
export GITHUB_USERNAME=
export GITHUB_TOKEN=
EOF
  echo "Created $SECRETS_FILE — fill in your secrets and restart the shell."
fi

source "$SECRETS_FILE"
