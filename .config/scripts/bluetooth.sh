#!/usr/bin/env bash
set -u

BG="#282c34"
FG="#46d9ff"
SCAN_SECONDS=5

bluetoothctl --timeout "$SCAN_SECONDS" scan on >/dev/null 2>&1 || true

rows=()

while read -r _ mac rest; do
    [ -n "$mac" ] || continue

    name="$rest"
    info="$(bluetoothctl info "$mac" 2>/dev/null || true)"

    alias="$(printf '%s\n' "$info" | sed -n 's/^[[:space:]]*Alias: //p' | head -n1)"
    icon="$(printf '%s\n' "$info" | sed -n 's/^[[:space:]]*Icon: //p' | head -n1)"
    paired="$(printf '%s\n' "$info" | sed -n 's/^[[:space:]]*Paired: //p' | head -n1)"
    connected="$(printf '%s\n' "$info" | sed -n 's/^[[:space:]]*Connected: //p' | head -n1)"
    rssi="$(printf '%s\n' "$info" | sed -n 's/^[[:space:]]*RSSI: //p' | head -n1)"

    [ -n "$name" ] || name="$alias"
    [ -n "$name" ] || name="(sin nombre)"
    [ -n "$icon" ] || icon="-"
    [ -n "$paired" ] || paired="no"
    [ -n "$connected" ] || connected="no"
    [ -n "$rssi" ] || rssi="-"

    rows+=("$name" "$mac" "$icon" "$paired" "$connected" "$rssi")
done < <(bluetoothctl devices)

if [ "${#rows[@]}" -eq 0 ]; then
    yad --info \
        --title="Bluetooth" \
        --text="No se encontraron dispositivos." \
        --width=400 --height=120 \
        --back="$BG" --fore="$FG"
    exit 0
fi

selection="$(
    yad --list \
        --title="Bluetooth devices" \
        --width=1100 \
        --height=700 \
        --center \
        --on-top \
        --search-column=1 \
        --print-column=2 \
        --column="Nombre" \
        --column="MAC" \
        --column="Tipo" \
        --column="Paired" \
        --column="Connected" \
        --column="RSSI" \
        "${rows[@]}"
)"

[ -n "$selection" ] || exit 0

bluetoothctl info "$selection" | yad --text-info \
    --title="Bluetooth info: $selection" \
    --width=900 \
    --height=650 \
    --fontname="monospace 10" \
    --back="$BG" \
    --fore="$FG"
