#!/bin/bash

# Función para mostrar el menú
mostrar_menu() {
	clear
	echo "Instalación de dotfiles de Kevin Molina:"
	echo "1. Instalar comandos RUST (Necesarios para Fish principalmente)"
	echo "2. Instalar fish + starship"
	echo "3. Paru (Necesario para instalar xmonad)"
	echo "4. Instalar xmonad + xmobar y agregados"
	echo "5. Ejecutar Función 2"
	echo "6. Salir"
	echo
}

funcion_1() {
	echo "Instalando comandos Rust"

	#### grep -> RipGrep
	paru -S ripgrep --noconfirm --needed
	#### ls -> exa
	paru -S exa --noconfirm --needed
	#### cat -> bat
	paru -S bat --noconfirm --needed
	#### lolcat
	paru -S lolcat --noconfirm --needed
}

funcion_2() {
	echo "Instalando fish"
	sudo pacman -Sy fish --needed --noconfirm
	chsh -s /usr/bin/fish

	echo "Instalando Oh My Fish"
	curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

	echo "Instalando Nerd-Fonts"
	sudo pacman -S nerd-fonts

	echo "Instalando Starship"
	sudo pacman -S starship


}

funcion_3() {
	echo "Instalando Paru"
	sudo pacman -S --needed base-devel --noconfirm
	git clone https://aur.archlinux.org/paru.git
	cd paru
	makepkg -si
}

funcion_4() {
	echo "Instalando dependencias que uso para xmonad"
	sudo pacman -S git lxsession picom python-pywal yq xdotool --noconfirm --needed


	echo "Instalando stack y ghc"
	curl -sSL https://get.haskellstack.org/ | sh
	sudo pacman -S ghc --noconfirm --needed
	
	echo "Instalando xmonad xmobar y contrib"
	cd $HOME/.config/xmonad
	stack init
	stack install

	mkdir $HOME/.config/xmobar
	stack init
	sed -i 's/flags: {}/flags:\n  xmobar:\n    all_extensions: true/' $HOME/.config/xmobar/stack.yaml
	stack install
	
	echo "Instalando conky"
	paru -S conky-lua --noconfirm --needed

	echo "Instalando rofi"
	paru -S rofi --noconfirm --needed

	echo "Instalando extras"
	paru -S feh --noconfirm --needed
}

# Loop principal del menú
while true; do
	mostrar_menu
	read -p "Por favor, elige una opción: " opcion
	case $opcion in
		1) funcion_1 ;;
		2) funcion_2 ;;
		3) funcion_3 ;;
		4) funcion_4 ;;
		5) echo "Saliendo..." ; exit ;;
		*) echo "Opción inválida. Introduce una opción válida." ;;
	esac
	read -p "Presiona Enter para continuar..."
done

