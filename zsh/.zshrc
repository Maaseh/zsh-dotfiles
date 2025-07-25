# History
HISTFILE="$XDG_DATA_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Options Zsh
setopt AUTO_CD              
setopt CORRECT              
setopt NO_BEEP              

# Completion
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

# Modules
source "$ZDOTDIR/exports.zsh"
source "$ZDOTDIR/aliases.zsh" 
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/plugins.zsh"

# Private config
# [[ -f "$ZDOTDIR/private.zsh" ]] && source "$ZDOTDIR/private.zsh"

# Starship prompt
eval "$(starship init zsh)"
