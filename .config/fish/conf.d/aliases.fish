# Basics
alias aliases='vim ~/.config/fish/conf.d/aliases.fish'

# System
alias mv='mv -iv'
alias cp='cp -iv'
alias ln='ln -iv'

alias chwon='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

alias rm='rm --preserve-root'
alias rd='rm -rf'

alias t='touch'

alias md='mkdir -p'
alias ka='killall'
alias df='df -h'
alias du='du -hs * | sort -rh'
alias now='date +"%n [ %R ]     %A      %D"'
alias diff='diff --color=always'
alias class='xprop | grep CLASS'
alias mount='mount | column -t'

# Git
alias gc='git clone'
alias gi='git init'
alias ga='git add'
alias gp='git push'
alias gf='git fetch'
alias gs='git status'
alias gl='git log'
alias gaa='git add --all'
alias gpl='git pull'
alias gcS='git commit -S --allow-empty -m'

function gcp
    git add .
    git commit -S --allow-empty -m "$argv"
    git push origin (git branch --show-current)
end

# Navigation
alias ..='cd ..'
alias .3='cd ../..'
alias .4='cd ../../..'
alias .5='cd ../../../..'

# Rust commands
alias ls='exa -1la --icons'
alias cat='bat'
alias grep='rg'
alias find='fd'
alias ps='procs'

# Vim
alias vi='vim'

# Config Dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

function configput
    config add $argv
    config commit -m "Add file $argv"
    config push 
end
