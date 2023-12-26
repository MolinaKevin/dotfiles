#!/bin/sh

sed -n '/-- My Keys/,/-- My Main/p' $HOME/.config/xmonad/xmonad.hs \
    | grep -e ', (' \
    -e '\[ (' \
    -e 'KEY_GROUP' \
    | grep -v '\-\-, (' \
    | sed -e 's/^[ \t]*//' \
    -e 's/, (/(/' \
    -e 's/\[ (/(/' \
    -e 's/-- KEY_GROUP /\n/' \
    | sed -e 's/("//' \
    | sed -e 's/",.*--/\t\t\t\t/' \
    | column -t -s "$(printf '\t')" \
    | yad --text-info --back=#282c34 --fore=#46d9ff --geometry=1200x800
