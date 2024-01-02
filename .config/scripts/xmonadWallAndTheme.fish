#!/bin/fish

set wall (random choice /home/kevin/Pictures/Wallpapers/* )

wal -i $wall -R
wal -i $wall

set input "/home/kevin/.cache/wal/colors.yml"
set input (string replace -r '"' '' $input)

set background (yq .special.background $input )
set foreground (yq .special.foreground $input )

set cursor (yq .special.cursor $input )

set color0 (yq .colors.color0 $input )
set color1 (yq .colors.color1 $input )
set color2 (yq .colors.color2 $input )
set color3 (yq .colors.color3 $input )
set color4 (yq .colors.color4 $input )
set color5 (yq .colors.color5 $input )
set color6 (yq .colors.color6 $input )
set color7 (yq .colors.color7 $input )
set color8 (yq .colors.color8 $input )
set color9 (yq .colors.color9 $input )
set color10 (yq .colors.color10 $input )
set color11 (yq .colors.color11 $input )
set color12 (yq .colors.color12 $input )
set color13 (yq .colors.color13 $input )
set color14 (yq .colors.color14 $input )
set color15 (yq .colors.color15 $input )


set colorConky0 ( string replace -a '#' '' ( string lower (echo $color0 | xargs | tr '[a-z]' '[A-Z]' ) ) )
set colorConky1 ( string replace -a '#' '' ( string lower (echo $color1 | xargs | tr '[a-z]' '[A-Z]' ) ) )
set colorConky2 ( string replace -a '#' '' ( string lower (echo $color2 | xargs | tr '[a-z]' '[A-Z]' ) ) )
set colorConky3 ( string replace -a '#' '' ( string lower (echo $color3 | xargs | tr '[a-z]' '[A-Z]' ) ) )
set colorConky4 ( string replace -a '#' '' ( string lower (echo $color4 | xargs | tr '[a-z]' '[A-Z]' ) ) )
set colorConky5 ( string replace -a '#' '' ( string lower (echo $color5 | xargs | tr '[a-z]' '[A-Z]' ) ) )
set colorConky6 ( string replace -a '#' '' ( string lower (echo $color6 | xargs | tr '[a-z]' '[A-Z]' ) ) )
set colorConky7 ( string replace -a '#' '' ( string lower (echo $color7 | xargs | tr '[a-z]' '[A-Z]' ) ) )
set colorConky8 ( string replace -a '#' '' ( string lower (echo $color8 | xargs | tr '[a-z]' '[A-Z]' ) ) )
set colorConky9 ( string replace -a '#' '' ( string lower (echo $color9 | xargs | tr '[a-z]' '[A-Z]' ) ) )
set colorConky10 ( string replace -a '#' '' ( string lower (echo $color10 | xargs | tr '[a-z]' '[A-Z]' ) ) )
set colorConky11 ( string replace -a '#' '' ( string lower (echo $color11 | xargs | tr '[a-z]' '[A-Z]' ) ) )
set colorConky12 ( string replace -a '#' '' ( string lower (echo $color12 | xargs | tr '[a-z]' '[A-Z]' ) ) )
set colorConky13 ( string replace -a '#' '' ( string lower (echo $color13 | xargs | tr '[a-z]' '[A-Z]' ) ) )
set colorConky14 ( string replace -a '#' '' ( string lower (echo $color14 | xargs | tr '[a-z]' '[A-Z]' ) ) )
set colorConky15 ( string replace -a '#' '' ( string lower (echo $color15 | xargs | tr '[a-z]' '[A-Z]' ) ) )

echo $colorConky0

sed -e "s/BACKGROUND/$background/g" \
    -e "s/FOREGROUND/$foreground/g" \
    -e "s/COLOR10/$color10/g" \
    -e "s/COLOR11/$color11/g" \
    -e "s/COLOR12/$color12/g" \
    -e "s/COLOR13/$color13/g" \
    -e "s/COLOR14/$color14/g" \
    -e "s/COLOR15/$color15/g" \
    -e "s/COLOR0/$color0/g" \
    -e "s/COLOR1/$color1/g" \
    -e "s/COLOR2/$color2/g" \
    -e "s/COLOR3/$color3/g" \
    -e "s/COLOR4/$color4/g" \
    -e "s/COLOR5/$color5/g" \
    -e "s/COLOR6/$color6/g" \
    -e "s/COLOR7/$color7/g" \
    -e "s/COLOR8/$color8/g" \
    -e "s/COLOR9/$color9/g" \
   /home/kevin/.config/templates/xmonad-template.hs > /home/kevin/.config/xmonad/xmonad.hs

sed -e "s/BACKGROUND/$background/g" \
    -e "s/FOREGROUND/$foreground/g" \
    -e "s/COLOR10/$color10/g" \
    -e "s/COLOR11/$color11/g" \
    -e "s/COLOR12/$color12/g" \
    -e "s/COLOR13/$color13/g" \
    -e "s/COLOR14/$color14/g" \
    -e "s/COLOR15/$color15/g" \
    -e "s/COLOR0/$color0/g" \
    -e "s/COLOR1/$color1/g" \
    -e "s/COLOR2/$color2/g" \
    -e "s/COLOR3/$color3/g" \
    -e "s/COLOR4/$color4/g" \
    -e "s/COLOR5/$color5/g" \
    -e "s/COLOR6/$color6/g" \
    -e "s/COLOR7/$color7/g" \
    -e "s/COLOR8/$color8/g" \
    -e "s/COLOR9/$color9/g" \
   /home/kevin/.config/templates/xmobarrc-template > /home/kevin/.config/xmobar/xmobarrc

sed -e "s/BACKGROUND/$background/g" \
    -e "s/FOREGROUND/$foreground/g" \
    -e "s/COLOR10/$colorConky10/g" \
    -e "s/COLOR11/$colorConky11/g" \
    -e "s/COLOR12/$colorConky12/g" \
    -e "s/COLOR13/$colorConky13/g" \
    -e "s/COLOR14/$colorConky14/g" \
    -e "s/COLOR15/$colorConky15/g" \
    -e "s/COLOR0/$colorConky0/g" \
    -e "s/COLOR1/$colorConky1/g" \
    -e "s/COLOR2/$colorConky2/g" \
    -e "s/COLOR3/$colorConky3/g" \
    -e "s/COLOR4/$colorConky4/g" \
    -e "s/COLOR5/$colorConky5/g" \
    -e "s/COLOR6/$colorConky6/g" \
    -e "s/COLOR7/$colorConky7/g" \
    -e "s/COLOR8/$colorConky8/g" \
    -e "s/COLOR9/$colorConky9/g" \
   /home/kevin/.config/templates/conky-template.conf > /home/kevin/.config/conky/hybrid/hybrid.conf

set sensor_path (fish $HOME/.config/scripts/find-hwmon.fish)
set sensor_path (string replace "/sys/bus/platform/devices/" "" -- $sensor_path)
set sensor_path (echo $sensor_path | sed 's|/[^/]*$||')

echo $sensor_path

sed -e "s|SENSOR_PATH|$sensor_path|g" \
    -e "s/BACKGROUND/$background/g" \
    -e "s/FOREGROUND/$foreground/g" \
    -e "s/COLOR10/$colorConky10/g" \
    -e "s/COLOR11/$colorConky11/g" \
    -e "s/COLOR12/$colorConky12/g" \
    -e "s/COLOR13/$colorConky13/g" \
    -e "s/COLOR14/$colorConky14/g" \
    -e "s/COLOR15/$colorConky15/g" \
    -e "s/COLOR0/$colorConky0/g" \
    -e "s/COLOR1/$colorConky1/g" \
    -e "s/COLOR2/$colorConky2/g" \
    -e "s/COLOR3/$colorConky3/g" \
    -e "s/COLOR4/$colorConky4/g" \
    -e "s/COLOR5/$colorConky5/g" \
    -e "s/COLOR6/$colorConky6/g" \
    -e "s/COLOR7/$colorConky7/g" \
    -e "s/COLOR8/$colorConky8/g" \
    -e "s/COLOR9/$colorConky9/g" \
   /home/kevin/.config/templates/rings-template.lua > /home/kevin/.config/conky/hybrid/lua/hybrid-rings.lua

echo $sensor_path

sed -e "s/BACKGROUND/$background/g" \
    -e "s/FOREGROUND/$foreground/g" \
    -e "s/COLOR10/$color10/g" \
    -e "s/COLOR11/$color11/g" \
    -e "s/COLOR12/$color12/g" \
    -e "s/COLOR13/$color13/g" \
    -e "s/COLOR14/$color14/g" \
    -e "s/COLOR15/$color15/g" \
    -e "s/COLOR0/$color0/g" \
    -e "s/COLOR1/$color1/g" \
    -e "s/COLOR2/$color2/g" \
    -e "s/COLOR3/$color3/g" \
    -e "s/COLOR4/$color4/g" \
    -e "s/COLOR5/$color5/g" \
    -e "s/COLOR6/$color6/g" \
    -e "s/COLOR7/$color7/g" \
    -e "s/COLOR8/$color8/g" \
    -e "s/COLOR9/$color9/g" \
   /home/kevin/.config/templates/km-dmenu-template.rasi > /home/kevin/.config/rofi/themes/km-dmenu.rasi

sed -e "s/BACKGROUND/$background/g" \
    -e "s/FOREGROUND/$foreground/g" \
    -e "s/COLOR10/$color10/g" \
    -e "s/COLOR11/$color11/g" \
    -e "s/COLOR12/$color12/g" \
    -e "s/COLOR13/$color13/g" \
    -e "s/COLOR14/$color14/g" \
    -e "s/COLOR15/$color15/g" \
    -e "s/COLOR0/$color0/g" \
    -e "s/COLOR1/$color1/g" \
    -e "s/COLOR2/$color2/g" \
    -e "s/COLOR3/$color3/g" \
    -e "s/COLOR4/$color4/g" \
    -e "s/COLOR5/$color5/g" \
    -e "s/COLOR6/$color6/g" \
    -e "s/COLOR7/$color7/g" \
    -e "s/COLOR8/$color8/g" \
    -e "s/COLOR9/$color9/g" \
    -e "s/CURSOR/$cursor/g" \
   /home/kevin/.config/templates/alacritty-template.toml > /home/kevin/.config/alacritty/alacritty.toml

killall conky
conky -c $HOME/.config/conky/hybrid/hybrid.conf
killall xmobar
xmonad --recompile; xmonad --restart
