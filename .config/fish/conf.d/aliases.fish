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

# Packages
alias remove='paru -Rs'
alias upgrade='paru -Syu'
alias add='paru -S'
alias clean='paru -Sc'
alias deepclean='paru -Scc'
alias nouse='pacman -Qqdt'

function list
    pacman -Qei (pacman -Qu|cut -d" " -f 1)|awk 'BEGIN {FS=":"}/^Name/{printf("\033[1;36m%s\033[1;37m", $2)}/^Description/{print ("\t ", $2)}' | column -ts (printf '\t') -o ":" -N " Nombre,   Descripcion"
end


# Rust commands
alias ls='exa -1la --icons'
alias cat='bat'
alias grep='rg'
alias find='fd'
alias ps='procs'

# Vim
alias vi='vim'

# Xrandr
alias xtrab='xrandr --auto; xrandr --output DVI-I-2-2 --right-of eDP1; xrandr --output DVI-I-1-1 --right-of DVI-I-2-2'
alias xsoph='xrandr --auto; xrandr --output HDMI1 --right-of eDP1'
alias xcasa='xrandr --auto; xrandr --output HDMI1 --left-of eDP1'

# Spark aliases
alias clear='/bin/clear; echo; echo; seq 1 (tput cols) | sort -R | spark | lolcat; echo; echo'

# Joplin
alias j='/usr/bin/joplin ; /usr/bin/joplin sync'

# Config Dotfiles
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

function configput
    config add $argv
    config commit -m "Add file $argv"
    config push 
end
