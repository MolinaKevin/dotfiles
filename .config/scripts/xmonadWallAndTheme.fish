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
        set content "$(string replace -a "COLOR$index" "$theme_colors[$array_index]" -- $content)"
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

for dependency in wal yq xmonad xmobar mktemp
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

xmonad --recompile
or begin
    fail "XMonad no pudo recompilarse; no se reinició la sesión."
    exit 1
end

pkill xmobar 2>/dev/null
xmonad --restart

echo "Tema aplicado usando "(path basename "$wallpaper")"."
