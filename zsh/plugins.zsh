# ~/.config/zsh/plugins.zsh
# Configuration des plugins de complétion

# === ZSH-AUTOSUGGESTIONS ===
# Installation via package manager
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Installation manuelle
elif [[ -f ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Configuration autosuggestions
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"  # Couleur des suggestions
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)  # Sources des suggestions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20             # Limite de taille

# === ZSH-SYNTAX-HIGHLIGHTING ===
# ATTENTION: doit être sourcé EN DERNIER !
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Configuration syntax highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'

# === ZSH-COMPLETIONS ===
if [[ -d /usr/share/zsh-completions ]]; then
    fpath=(/usr/share/zsh-completions $fpath)
elif [[ -d ~/.config/zsh/plugins/zsh-completions/src ]]; then
    fpath=(~/.config/zsh/plugins/zsh-completions/src $fpath)
fi

# === CUSTOM COMPLETIONS ===
# Dossier pour tes completions personnalisées
fpath=(~/.config/zsh/completions $fpath)

# Git completion
compdef g=git
compdef gs=git
compdef ga=git
compdef gc=git
compdef gp=git
compdef gl=git
compdef gd=git


# === FZF INTEGRATION ===
# If FZF == OK
if command -v fzf >/dev/null 2>&1; then
    # Ctrl+R fuzzy for history
	if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
        	source /usr/share/doc/fzf/examples/key-bindings.zsh
	elif [[ -f ~/.fzf.zsh ]]; then
        	source ~/.fzf.zsh
    	fi	
    
    # Configuration FZF
    export FZF_DEFAULT_OPTS="
        --height 40% 
        --border 
        --layout=reverse
        --color=fg:#c0caf5,bg:#24283b,hl:#ff9e64
        --color=fg+:#c0caf5,bg+:#292e42,hl+:#ff9e64
        --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
        --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"
    
    # Ctrl+T pour fichiers, Alt+C pour dossiers
    export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
fi

# === ZSH-AUTOPAIR ===
if [[ -f ~/.config/zsh/plugins/zsh-autopair/autopair.zsh ]]; then
    source ~/.config/zsh/plugins/zsh-autopair/autopair.zsh
    
    # Configuration
    typeset -gA AUTOPAIR_PAIRS
    AUTOPAIR_PAIRS=('`' '`' "'" "'" '"' '"' '{' '}' '[' ']' '(' ')' ' ' ' ')
    AUTOPAIR_LBOUNDS=(all '[.[:alnum:]_]')
    AUTOPAIR_RBOUNDS=(all '[.[:alnum:]_]')
fi

# === COMPLETION TWEAKS ===
# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Completion with colors
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Completion menu
zstyle ':completion:*' menu select

# Completion by type
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'

# Completion cache system
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.cache/zsh/zcompcache
