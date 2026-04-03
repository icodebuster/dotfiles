# Function to open Xcode workspace or project in the current directory.
xc() {
    fileToOpen='';
    find . -maxdepth 1 -name *.xcworkspace -print0 | while IFS= read -r -d '' file; do
        fileToOpen=$file
    done

    if [ -n "$fileToOpen" ]
    then
        echo "Opening Xcode Workspace: ${fileToOpen}"
        open $fileToOpen
    else
        find . -maxdepth 1 -name *.xcodeproj -print0 | while IFS= read -r -d '' file; do
            fileToOpen=$file
        done

        if [ -n "$fileToOpen" ]
        then
            echo "Opening Xcode Project: ${fileToOpen}"
            open $fileToOpen
        else
            echo "No Xcode files to open."
        fi
    fi
}

# Function to open VSCode workspace or project in the current directory.
vc() {
    local editor
    if (( $+commands[cursor] )); then
        editor="cursor"
    elif (( $+commands[code] )); then
        editor="code"
    else
        echo "No editor found (tried cursor, code)." >&2
        return 1
    fi

    local ws=$(find . -maxdepth 1 -name '*.code-workspace' -print -quit)

    if [[ -n "$ws" ]]; then
        echo "Opening workspace: ${ws} (${editor})"
        "$editor" "$ws"
    else
        echo "No workspace found, opening folder (${editor})"
        "$editor" .
    fi
}

git-local-email() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo "Not inside a git repository." >&2
        return 1
    fi
    local email
    vared -p "Local git email [jobink.dev@gmail.com]: " email
    git config --local user.email "${email:-jobink.dev@gmail.com}"
    echo "Set local user.email to: $(git config --local user.email)"
}

dev() {
    cursor . &>/dev/null &
    zellij --layout dev
}

screenshot-location() {
    local default="$HOME/_Work/Screenshots"
    local dir="$1"
    if [[ -z "$dir" ]]; then
        vared -p "Set screenshot location [$default]: " dir
        dir="${dir:-$default}"
    fi
    mkdir -p "$dir"
    defaults write com.apple.screencapture location "$dir"

    local reply set_jpeg
    read -r "reply?Also set screenshot format to JPEG (smaller files than PNG)? [y/N] "
    if [[ "${reply:l}" == y || "${reply:l}" == yes ]]; then
        defaults write com.apple.screencapture type jpg
        set_jpeg=1
    fi

    killall SystemUIServer
    echo "Screenshot location set to: $dir"
    [[ -n "$set_jpeg" ]] && echo "Screenshot format set to: JPEG"
}

smartech-add-device() {
    local url="${1:?Usage: smartech-td <smartech://...url>}"
    xcrun simctl openurl booted "$url"
}

dropbox-ignore() {
    if [[ -z "${DOTFILES_DIR:-}" ]]; then
        echo "DOTFILES_DIR is not set." >&2
        return 1
    fi
    command "$DOTFILES_DIR/scripts/dropbox-ignore.sh" "$@"
}