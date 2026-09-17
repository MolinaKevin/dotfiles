#!/usr/bin/env fish

set -l config_home (set -q XDG_CONFIG_HOME; and echo $XDG_CONFIG_HOME; or echo "$HOME/.config")
set -l cache_home (set -q XDG_CACHE_HOME; and echo $XDG_CACHE_HOME; or echo "$HOME/.cache")
set -l wallpaper_dir "$HOME/Pictures/Wallpapers"
set -l colors_file "$cache_home/wal/colors.yml"

function fail
    echo "ERROR: $argv" >&2
    return 1
end

function require_command
    command -q $argv[1]
    or fail "No se encuentra el comando '$argv[1]'."
end

function render_template --argument-names template output background foreground cursor
    if not test -f "$template"
        fail "No existe la plantilla $template"
        return 1
    end

    # Leer hasta EOF conserva el archivo como un solo valor multilinea.
    read -z content < "$template"

    # Reemplazar primero COLOR15..COLOR0 evita que COLOR1 altere COLOR10.
    for index in (seq 15 -1 0)
        set -l array_index (math $index + 1)
        set content "$(string replace -a "COLOR$index" "$render_colors[$array_index]" -- $content)"
    end

    set content "$(string replace -a BACKGROUND "$background" -- $content)"
    set content "$(string replace -a FOREGROUND "$foreground" -- $content)"
    set content "$(string replace -a CURSOR "$cursor" -- $content)"

    command mkdir -p (path dirname "$output")
    set -l temporary (command mktemp (path dirname "$output")/.theme.XXXXXX)
    or return 1

    printf '%s\n' "$content" > "$temporary"
    and command mv -f "$temporary" "$output"
end

for dependency in wal yq xmonad xmobar conky mktemp
    require_command $dependency
    or exit 1
end

if not test -d "$wallpaper_dir"
    fail "No existe el directorio de fondos $wallpaper_dir"
    exit 1
end

set -l wallpapers
for candidate in "$wallpaper_dir"/*
    test -f "$candidate"
    and set -a wallpapers "$candidate"
end

if test (count $wallpapers) -eq 0
    fail "No hay fondos en $wallpaper_dir"
    exit 1
end

set -l wallpaper (random choice $wallpapers)
wal -i "$wallpaper"
or exit 1

if not test -f "$colors_file"
    fail "wal no generó $colors_file"
    exit 1
end

set -l background (yq '.special.background' "$colors_file")
set -l foreground (yq '.special.foreground' "$colors_file")
set -l cursor (yq '.special.cursor' "$colors_file")
set -g theme_colors

for index in (seq 0 15)
    set -a theme_colors (yq ".colors.color$index" "$colors_file")
end

set -g render_colors $theme_colors

render_template \
    "$config_home/templates/xmonad-template.hs" \
    "$config_home/xmonad/xmonad.hs" \
    "$background" "$foreground" "$cursor"
or exit 1

render_template \
    "$config_home/templates/xmobarrc-template" \
    "$config_home/xmobar/xmobarrc" \
    "$background" "$foreground" "$cursor"
or exit 1

render_template \
    "$config_home/templates/km-dmenu-template.rasi" \
    "$config_home/rofi/themes/km-dmenu.rasi" \
    "$background" "$foreground" "$cursor"
or exit 1

render_template \
    "$config_home/templates/alacritty-template.toml" \
    "$config_home/alacritty/alacritty.toml" \
    "$background" "$foreground" "$cursor"
or exit 1

# Conky y su script Lua usan colores hexadecimales sin el prefijo '#'.
set -g theme_colors_conky
for color in $theme_colors
    set -a theme_colors_conky (string replace -a '#' '' -- $color)
end
set render_colors $theme_colors_conky

render_template \
    "$config_home/templates/conky-template.conf" \
    "$config_home/conky/hybrid/hybrid.conf" \
    (string replace -a '#' '' -- $background) \
    (string replace -a '#' '' -- $foreground) \
    "$cursor"
or exit 1

render_template \
    "$config_home/templates/rings-template.lua" \
    "$config_home/conky/hybrid/lua/hybrid-rings.lua" \
    (string replace -a '#' '' -- $background) \
    (string replace -a '#' '' -- $foreground) \
    "$cursor"
or exit 1

set render_colors $theme_colors

xmonad --recompile
or begin
    fail "XMonad no pudo recompilarse; no se reinició la sesión."
    exit 1
end

command pkill -x conky 2>/dev/null
command sleep 1
command conky -c "$config_home/conky/hybrid/hybrid.conf" >/dev/null 2>&1 &

if contains -- --startup $argv
    echo "Tema y Conky aplicados al iniciar XMonad."
    exit 0
end

command pkill xmobar 2>/dev/null
command xmonad --restart

echo "Tema aplicado usando "(path basename "$wallpaper")"."
