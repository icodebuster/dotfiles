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

# Open or create a VS Code workspace in the current directory.
vc() {
    if ! (( $+commands[code] )); then
        echo "VS Code (code) not found." >&2
        return 1
    fi

    local ws=$(find . -maxdepth 1 -name '*.code-workspace' -print -quit)

    if [[ -n "$ws" ]]; then
        echo "Opening workspace: ${ws}"
        code "$ws"
        return
    fi

    local reply
    read -r "reply?No workspace found. Create one? [Y/n] "
    if [[ "${reply:l}" == n || "${reply:l}" == no ]]; then
        echo "Opening folder instead."
        code .
        return
    fi

    local default="${PWD:t}"
    local name
    read -r "name?Workspace name [$default]: "
    name="${name:-$default}"

    local tpl="$DOTFILES_DIR/scripts/templates/code-workspace-template.json"
    if [[ ! -f "$tpl" ]]; then
        echo "Template not found: $tpl" >&2
        return 1
    fi

    local file="${name}.code-workspace"
    cp "$tpl" "$file"
    echo "Created ${file}"
    code "$file"
}

# Open or create a Cursor workspace in the current directory.
cc() {
    local ws=$(find . -maxdepth 1 -name '*.code-workspace' -print -quit)

    if [[ -n "$ws" ]]; then
        echo "Opening workspace: ${ws}"
        cursor "$ws"
        return
    fi

    local reply
    read -r "reply?No workspace found. Create one? [Y/n] "
    if [[ "${reply:l}" == n || "${reply:l}" == no ]]; then
        echo "Opening folder instead."
        cursor .
        return
    fi

    local default="${PWD:t}"
    local name
    read -r "name?Workspace name [$default]: "
    name="${name:-$default}"

    local tpl="$DOTFILES_DIR/scripts/templates/code-workspace-template.json"
    if [[ ! -f "$tpl" ]]; then
        echo "Template not found: $tpl" >&2
        return 1
    fi

    local file="${name}.code-workspace"
    cp "$tpl" "$file"
    echo "Created ${file}"
    cursor "$file"
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