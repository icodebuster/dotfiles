# ---- Ruby (lazy-loaded) ----
export PATH="$HOME/.rbenv/shims:$PATH"
rbenv() {
  unfunction rbenv
  eval "$(command rbenv init -)"
  rbenv "$@"
}

# ----- Python Pyenv (lazy-loaded) -----
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
pyenv() {
  unfunction pyenv
  eval "$(command pyenv init -)"
  (( $+commands[pyenv-virtualenv-init] )) && eval "$(command pyenv virtualenv-init -)"
  pyenv "$@"
}

# ----- Go -----
export GOPATH=$HOME/_Work/Code/_Workspace/Golang
export GOROOT="/opt/homebrew/opt/golang/libexec"
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

# ----- Flutter ----
export FLUTTERPATH=$HOME/fvm/default/bin
export PATH=$PATH:$FLUTTERPATH
export PATH="$PATH":"$HOME/.pub-cache/bin"

# ----- Java (lazy-loaded) -----
java_home() { /usr/libexec/java_home "$@"; }
export JAVA_HOME="${JAVA_HOME:-$HOME/Library/Java/JavaVirtualMachines/default/Contents/Home}"
if [[ ! -d "$JAVA_HOME" ]]; then
  export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"
fi
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools/
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin/
export PATH=$PATH:$ANDROID_HOME/build-tools
export PATH=$PATH:$ANDROID_HOME/emulator/
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/sdk/platform-tools
export PATH=$PATH:$ANDROID_HOME/sdk/platform-tools/adb

# ----- Node JS (fnm) -----
eval "$(fnm env --use-on-cd)"

# ----- pnpm -----
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ----- pipx -----
export PATH="$PATH:$HOME/.local/bin"

# ----- Windsurf -----
export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# ----- Antigravity -----
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
