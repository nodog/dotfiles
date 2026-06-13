# ==============================================================================
# 1. CORE OH-MY-ZSH CONFIGURATION
# ==============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="steeef"

# Completion & History Settings
CASE_SENSITIVE="true"
HIST_STAMPS="yyyy-mm-dd"
unsetopt share_history

# Function Path
fpath+=~/.zfunc

# Plugins (Add wisely to prevent slow startup)
plugins=(
    git
    poetry
    virtualenv
)

# Load Oh My Zsh
[ -f "$ZSH/oh-my-zsh.sh" ] && source $ZSH/oh-my-zsh.sh

# ==============================================================================
# 2. ENVIRONMENT & PATH CUSTOMIZATION
# ==============================================================================
# Native Zsh array for clean PATH building (filters out duplicates and missing dirs)
typeset -U path
myAddToPath=(
    /sbin
    /usr/sbin
    /usr/local/bin
    /usr/local/sbin
    /opt/local/bin
    /opt/local/sbin
    /usr/local/processing
    $HOME/bin
    $HOME/.local/bin
    /usr/local/opt/coreutils/libexec/gnubin/
    /opt/homebrew/opt/coreutils/libexec/gnubin
)

for myDir in $myAddToPath; do
    [[ -d "$myDir" ]] && path=("$myDir" $path)
done
export PATH

# Homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"

# ==============================================================================
# 3. SYSTEM & HARDWARE CONFIGURATION
# ==============================================================================
# macOS Hostname Setup
if command -v scutil >/dev/null 2>&1; then
    export HOST=$(scutil --get LocalHostName)
fi

# terminal banner
if command -v figlet >/dev/null 2>&1 && command -v lolcat >/dev/null 2>&1; then
    # Both figlet and lolcat are installed
    figlet -f graffiti -w $(tput cols) "$HOST" | lolcat
elif command -v figlet >/dev/null 2>&1; then
    # Only figlet is installed
    figlet -f graffiti -w $(tput cols) "$HOST"
else
    # Neither is installed, fallback to plain text
    echo "Logged into: $HOST"
fi

# SSH Keychain Initialization
if (( $+commands[keychain] )); then
    # Default to id_rsa, fallback to id_ed25519 if rsa doesn't exist
    if [[ -f ~/.ssh/id_rsa ]]; then
        keychain ~/.ssh/id_rsa
    elif [[ -f ~/.ssh/id_ed25519 ]]; then
        keychain ~/.ssh/id_ed25519
    fi

    # Source the keychain environment if the file exists
    [[ -f ~/.keychain/${HOST}-sh ]] && . ~/.keychain/${HOST}-sh
fi

# ==============================================================================
# 4. CONDITIONAL IMPORTS & ALIASES
# ==============================================================================
# Local configurations / Third-party tools
[[ -f $HOME/.zepz_specifics ]] && . $HOME/.zepz_specifics
[[ -d $HOME/down/z ]]         && . $HOME/down/z/z.sh

# Standard Aliases
alias ls="ls -FNv --dereference-command-line-symlink-to-dir --color=auto -T 0 --time-style=long-iso"
alias dc="dc -e 5k -"
alias epochtime="date +%s"

# Personal/Español Aliases
# Custom alias for system updates based on OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux Mint (Ubuntu/Debian based)
    alias vamos_a_actualizar="sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS (Homebrew)
    alias vamos_a_actualizar="brew update && brew upgrade && brew cleanup"
fi
alias matcha_elegante="$HOME/src/python/high_matcha/venv/bin/python3 $HOME/src/python/high_matcha/high_matcha.py"
