# Dotfiles

Configuración personal administrada como un repositorio Git bare con el
directorio personal como worktree.

## Restaurar

```bash
git clone --bare https://github.com/MolinaKevin/dotfiles.git "$HOME/.cfg"
git --git-dir="$HOME/.cfg" --work-tree="$HOME" checkout
git --git-dir="$HOME/.cfg" config status.showUntrackedFiles no
```

Si el checkout encuentra archivos existentes, hay que respaldarlos antes de
repetirlo. No se deben forzar ni sobrescribir perfiles personales del navegador
o del correo.

Para trabajar con el repositorio:

```fish
alias config='git --git-dir=$HOME/.cfg --work-tree=$HOME'
```

## Escritorio

La configuración activa utiliza XMonad, Xmobar, Rofi, Alacritty, Fish, Dunst,
Picom y pywal. Las dependencias del sistema se gestionan externamente; este
repositorio no instala paquetes ni activa servicios.

Cambiar fondo y paleta:

```bash
~/.config/scripts/xmonadWallAndTheme.fish
```

Los fondos se leen desde `~/Pictures/Wallpapers`. El script genera las
configuraciones de XMonad, Xmobar, Rofi y Alacritty, recompila XMonad y solo lo
reinicia cuando la compilación termina correctamente.

Reconfigurar monitores:

```bash
~/.config/scripts/apply-display-profile.sh
```

El cambio de monitores no modifica el fondo ni la paleta.
