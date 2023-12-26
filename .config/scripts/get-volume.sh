#!/usr/bin/bash

vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
vol=$(echo $vol | sed 's/Volume: //')
# Convertir a porcentaje
volumen_porcentaje=$(echo "$vol * 100" | bc | sed 's/.00//')

# Formatear y mostrar el resultado
printf "%d%%\n" "$volumen_porcentaje"
