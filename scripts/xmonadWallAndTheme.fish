#!/bin/fish

set wall (random choice /home/kevin/Imagenes/Wallpapers/* )

wal -i $wall -R
wal -i $wall

set input "/home/kevin/.cache/wal/colors.yml"

yq .special.background ~/.cache/wal/colors.yml
yq .special.foreground ~/.cache/wal/colors.yml
yq .colors.color0 ~/.cache/wal/colors.yml
yq .colors.color1 ~/.cache/wal/colors.yml
yq .colors.color2 ~/.cache/wal/colors.yml
yq .colors.color3 ~/.cache/wal/colors.yml
yq .colors.color4 ~/.cache/wal/colors.yml
yq .colors.color5 ~/.cache/wal/colors.yml
yq .colors.color6 ~/.cache/wal/colors.yml
yq .colors.color7 ~/.cache/wal/colors.yml
yq .colors.color8 ~/.cache/wal/colors.yml

set background (yq .special.background $input )
set foreground (yq .special.foreground $input )

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
   /home/kevin/.templates/xmonad-template.hs > /home/kevin/.xmonad/xmonad.hs

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
   /home/kevin/.templates/xmobarrc-template > /home/kevin/.config/xmobar/xmobarrc


killall xmobar
xmonad --recompile; xmonad --restart
