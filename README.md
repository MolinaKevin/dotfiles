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

La configuración versionada utiliza XMonad, Xmobar, Rofi, Alacritty, Fish,
Conky y pywal. Dunst, Picom, las dependencias del sistema y los servicios se
gestionan externamente mediante Nix/Home Manager; este repositorio no los
instala ni los activa.

Cambiar fondo y paleta:

```bash
~/.config/scripts/xmonadWallAndTheme.fish
```

Los fondos se leen desde `~/Pictures/Wallpapers`. El script genera las
configuraciones activas de XMonad, Xmobar, Rofi, Alacritty y Conky a partir de
las plantillas versionadas. Después recompila XMonad y solo lo reinicia cuando
la compilación termina correctamente. Los archivos activos de Conky no se
versionan porque se regeneran automáticamente.

El autostart de Bitwarden usa el ejecutable disponible en `PATH`, de modo que
no queda ligado a una versión concreta del paquete en `/nix/store`.

Reconfigurar monitores:

```bash
~/.config/scripts/apply-display-profile.sh
```

El cambio de monitores no modifica el fondo ni la paleta.
