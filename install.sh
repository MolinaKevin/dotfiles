#!/bin/sh

# Update
sudo pacman -Sy

# Base
sudo pacman -S vim stow git curl xorg-xinit xorg-server xorg-apps base-devel --noconfirm --needed

# Usefull packages
sudo pacman -S paru --noconfirm --needed

# Graphic Environment
sudo pacman -S xmonad xmonad-contrib xmobar picom --noconfirm --needed

## Dunst
### Dependencies
sudo pacman -S dbus libxinerama libxrandr libxss glib pango libnotify  --noconfirm --needed
### Install
git clone https://github.com/dunst-project/dunst.git
cd dunst
make target WAYLAND=0
sudo make install
cd ..
sudo rm -r dunst

# Terminal
sudo pacman -S fish alacritty --noconfirm --needed
## Starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# Webbrowser
sudo pacman -S qutebrowser --noconfirm --needed
## Utils for qutebrowser
sudo pacman -S bitwarden-dmenu --noconfirm --needed
sudo pacman -S xdotool --noconfirm --needed
mkdir ~/.local/share/qutebrowser/userscripts
git clone https://gitlab.com/AGitBoy/qutebrowser-bitwarden-dmenu.git
cd qutebrowser-bitwarden-dmenu
mv bw-dmenu-fill ~/.local/share/qutebrowser/userscripts
cd ..
sudo rm -R qutebrowser-bitwarden-dmenu

# Tools
sudo pacman -S remmina --noconfirm --needed
sudo pacman -S rofi --noconfirm --needed
## Paru
if ! [ -x "$(command -v paru)" ];
then
	git clone https://aur.archlinux.org/paru.git
	cd paru
	makepkg -si
	cd ..
	sudo rm -r paru
	exit
fi
## Change default commands
### Aliases in fish config
#### grep -> RipGrep
paru -S ripgrep --noconfirm --needed
#### ls -> exa
paru -S exa --noconfirm --needed
#### cat -> bat
paru -S bat --noconfirm --needed
#### lolcat
paru -S lolcat --noconfirm --needed
### Some Tools with Paru
paru -S go-yq --noconfirm --needed
paru -S conky-lua --noconfirm --needed
paru -S imagemagick pidof feh nitrogen bgs hsetroot habak display --noconfirm --needed
paru -S python-pywal --noconfirm --needed
paru -S pamixer --noconfirm --needed
paru -S lxsession --noconfirm --needed
paru -S rofi --noconfirm --needed
paru -S mpv youtube-dl --noconfirm --needed

# Login Manager
sudo pacman -S lightdm lightdm-webkit2-greeter --noconfirm --needed
## Some dependencies
paru -S xf86-video-intel mesa lib32-mesa --noconfirm --needed
## Activate
sudo systemctl enable lightdm.service
## Install theme
paru -S lightdm-webkit2-theme-glorious --noconfirm --needed
sudo sed -i 's/^\(#?greeter\)-session\s*=\s*\(.*\)/greeter-session = lightdm-webkit-greeter #\1/ #\2g' /etc/lightdm/lightdm.conf
sudo sed -i 's/^webkit_theme\s*=\s*\(.*\)/webkit_theme = glorious #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
sudo sed -i 's/^debug_mode\s*=\s*\(.*\)/debug_mode = true #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf

# Changing default terminal and execute commands
chsh -s /usr/bin/fish
## oh my fish
#git clone https://github.com/oh-my-fish/oh-my-fish
#cd oh-my-fish
#bin/install --offline
#cd ..
#exit

# Fonts 
paru -S nerd-fonts-complete --noconfirm --needed

# Copy Dotfiles
sudo stow .

