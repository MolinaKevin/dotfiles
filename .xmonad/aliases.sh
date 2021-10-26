#!/bin/sh

cat $HOME/.config/fish/conf.d/aliases.fish \
    | grep -e 'alias' \
    -e 'function ' \
    -e '#' \
    | sed -e 's/alias //' \
    | sed -e 's/\=/\t/' \
    | sed -E 's/\\/&&/g;s/^([[:digit:]])*:(.*)/\1c\\\2/' \
    | column -ts "$(printf '\t')" -o ":" -N "Alias, Comando"  \
    | yad --text-info --back=#282c34 --fore=#46d9ff --geometry=1200x800
