# ----- eza -----
(( $+commands[eza] )) && {
    alias ll="eza -l -g --icons"
    alias ls="eza --icons"
    alias l="eza -l --icons --git -a"
    alias lt="eza --tree --level=2 --long --icons --git"
    alias ltree="eza --tree --level=2  --icons --git"
}

# ----- shell & system -----
alias o="open ."
alias c="clear"
alias copyssh="cat ~/.ssh/id_rsa.pub | pbcopy"
alias killport=findandkill
alias brewski='brew update && brew upgrade && brew cleanup; brew doctor'

# ----- zsh config -----
alias editz="cursor ~/.zshrc"
alias srcz="source ~/.zshrc"
alias clear-zsh-cache='rm -rf ~/.cache/zsh-eval-cache && echo "Cleared. Open a new terminal to regenerate."'

# ----- navigation -----
# General
alias work="cd ~/JK/_Work"
alias code="cd ~/JK/_Work/Code"
alias archive="cd ~/JK/_Archive"

# Personal
alias dot='cd ~/.dotfiles && vc'
alias personal="cd ~/JK/_Work/Code/Personal"
alias area51="cd ~/JK/_Work/Code/Personal/Area51"
alias junk="cd ~/JK/_Work/Code/Junkyard"

# Work
alias netcore="cd ~/JK/_Work/Code/Work/Netcore"
alias marvel="cd ~/JK/_Work/Code/Work/Marvel"
alias appsdk="cd ~/JK/_Work/Code/Work/Netcore/AppSDK"
alias ios="cd ~/JK/_Work/Code/Work/Netcore/AppSDK/iOS"
alias android="cd ~/JK/_Work/Code/Work/Netcore/AppSDK/Android"

# OpenSource
alias oss="cd ~/JK/_Work/Code/OpenSource"

# ----- python -----
alias python="python3"
alias pyv='python -m venv venv'
alias pys='source venv/bin/activate'
alias pyvs='python -m venv venv && source venv/bin/activate && pip install --upgrade pip'

# ----- flutter -----
alias flutter-clean="flutter clean && flutter pub get"

# ----- git bulk / workspaces -----
alias gitcomp='code ~/_Work/Code/Competitions-Projects/_all_competition-repo-list.txt'

# ----- firefox profiles -----
alias foxmgr='/Applications/Firefox.app/Contents/MacOS/firefox-bin -P'
alias foxjk='/Applications/Firefox.app/Contents/MacOS/firefox-bin -P JK'
alias foxnc='/Applications/Firefox.app/Contents/MacOS/firefox-bin -P NC'

# ----- ssh / remote -----
alias mm="ssh NA@192.168.114.102"

# ----- scripts & tabs -----
alias opentabs="~/_Work/GDrive/Scripts/open_tabs.sh"
alias prism='opentabs ~/_Work/JK/Area51/NDIS-Workflow/Code/Prism/control ~/_Work/JK/Area51/NDIS-Workflow/Code/Prism/command'

# ----- smartech / work tools -----
alias updatepp='bundle exec fastlane --env SmartechApp && bundle exec fastlane --env SmartechNudgesApp'

# ----- Archive (old cd aliases) -----
# alias wrk="cd ~/_Work"
# alias icb="cd ~/_Work/Code"
# alias _icb="cd /Users/JK/_Work/JK/Area51/_JKiCB"
# alias jksmt="cd ~/_Work/Code/_Smartech"
# alias jknc="cd ~/_Work/Code/_Netcore"
# alias jkicb="cd ~/_Work/JK/Area51"
# alias jkml="cd ~/_Work/Code/_ML-Pod/"
# alias junk-temp="cd ~/_Work/Junkyard"
# alias junkyard="cd ~/_Work/JK/Area51/_Junkyard"
# alias nccomp='cd ~/_Work/Code/Competitions-Projects'
# alias getcomp='cd ~/_Work/Code/Competitions-Projects && git bulk --addworkspace competitions ~/_Work/Code/Competitions-Projects --from _all_competition-repo-list.txt'
# alias getml='cd ~/_Work/Code/_ML-Pod && git bulk --addworkspace aiml ~/_Work/Code/_ML-Pod --from _All-ML-Repo.txt'
# alias smtb="cd ~/_Work/JK/Area51/NodeJS/Smartech/backend && cursor ."
# alias smtf="cd ~/_Work/JK/Area51/NodeJS/Smartech/frontend && cursor ."
# alias pnserver='cd ~/_Work/Code/_Smartech/_Tools/PNServer-Local/smt-backend && npm run start:dev'
# alias getfcm='cd ~/_Work/Code/_Smartech/_Tools/FCM-v1 && node getToken.js'
# alias jkios='cd ~/_Work/Code/_Smartech/Native/Smartech-iOS-SDK-Dev && vc'
# alias oss='cd ~/_Work/Code/OpenSource'
