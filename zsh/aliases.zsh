# === Navigation ===
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias bat="batcat"

# === Ls ===
alias ll="ls -la"
alias la="ls -A" 
alias l="ls -CF"
alias lt="ls -ltr"
alias lh="ls -lh"

# === Git ===
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline"
alias gd="git diff"

# === Editors ===
alias vim="nvim"
alias vi="nvim"

# === System ===
alias grep="grep --color=auto"
alias df="df -h"
alias du="du -h"
alias free="free -h"
alias shutdown='sudo shutdown now'
alias restart='sudo reboot'
alias suspend='sudo pm-suspend'

# === Personal ===
alias work="cd $HOME/workspace"
alias doc="cd $HOME/Documents"
alias dow="cd $HOME/Downloads"
alias dot="cd $HOME/.dotfiles"
alias devops="/DevOpsLab"

# === Safety ===
alias rm="rm -i"
alias cp="cp -i" 
alias mv="mv -i"

# === Docker ===
alias dockls="docker container ls | awk 'NR > 1 {print \$NF}'"                  # display names of running containers
alias dockRr='docker rm $(docker ps -a -q) && docker rmi $(docker images -q)'   # delete every containers / images
alias dockstats='docker stats $(docker ps -q)'                                  # stats on images
alias dockimg='docker images'                                                   # list images installed
alias dockprune='docker system prune -a'                                        # prune everything
alias dockceu='docker-compose run --rm -u $(id -u):$(id -g)'                    # run as the host user
alias dockce='docker-compose run --rm'

# === Docker Compose ===
alias docker-compose-dev='docker-compose -f docker-compose-dev.yml' # run a different config file than the default one

# === Quick edits ===
alias zshrc="$EDITOR ~/.config/zsh/.zshrc"
alias aliases="$EDITOR ~/.config/zsh/aliases.zsh"

# === Network ===
alias myip="curl -s checkip.dyndns.org | grep -oE '[0-9.]+'"
alias ports="netstat -tulanp"

# === Processes ===
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
