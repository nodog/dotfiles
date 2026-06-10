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
    # poetry
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
    /usr/bin
    /usr/sbin
    /usr/local/bin
    /usr/local/sbin
    /opt/local/bin
    /opt/local/sbin
    /opt/local/libexec/gnubin/
    /usr/local/processing
    $HOME/bin
    $HOME/Library/Python/3.9/bin
    $HOME/.poetry/bin
    $HOME/.local/bin
    /opt/local/lib/postgresql94/bin
    /usr/local/opt/coreutils/libexec/gnubin
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
    figlet -f standard "$HOST" | lolcat
elif command -v figlet >/dev/null 2>&1; then
    # Only figlet is installed
    figlet -f standard "$HOST"
else
    # Neither is installed, fallback to plain text
    echo "Logged into: $HOST"
fi

# SSH Keychain Initialization
if (( $+commands[keychain] )); then
    keychain ~/.ssh/id_rsa
    [[ -f ~/.keychain/${HOST}-sh ]] && . ~/.keychain/${HOST}-sh
fi

# ==============================================================================
# 4. CONDITIONAL IMPORTS & ALIASES
# ==============================================================================
# External Scripts
[[ -d $HOME/down/z ]]         && . $HOME/down/z/z.sh

# Standard Aliases
alias ls="ls -FNv --dereference-command-line-symlink-to-dir --color=auto -T 0 --time-style=long-iso"
alias dc="dc -e 5k -"

# Personal/Español Aliases
alias vamos_a_actualizar="brew upgrade"
alias matcha_elegante="$HOME/src/python/high_matcha/venv/bin/python3 $HOME/src/python/high_matcha/high_matcha.py"
