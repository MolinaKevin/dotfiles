#!/usr/bin/env bash

set -u
set -o pipefail

INTERNAL="eDP-1"

connected() {
  xrandr --query | grep -q "^$1 connected"
}

exists_output() {
  xrandr --query | grep -q "^$1 "
}

all_outputs() {
  xrandr --query | awk '/ connected| disconnected/ {print $1}'
}

external_connected_outputs() {
  xrandr --query | awk '/ connected/ && $1 !~ /^eDP/ {print $1}'
}

disable_if_exists() {
  if exists_output "$1"; then
    xrandr --output "$1" --off || true
  fi
}

disable_all_except() {
  local keep=" $* "

  for output in $(all_outputs); do
    if [[ "$keep" != *" $output "* ]]; then
      disable_if_exists "$output"
    fi
  done
}

restart_xmonad_stack() {
  sleep 1

  ~/.config/scripts/xmonadWallAndTheme.fish || true

  pkill xmobar || true

  # Esto puede fallar si xmonad.hs tiene errores.
  # No queremos que eso impida que el layout de pantallas quede aplicado.
  xmonad --restart || echo "WARN: xmonad no pudo reiniciarse. Revisar xmonad.hs."
}

detect_home_outputs() {
  # Configuración nueva:
  # DP-1-2 = monitor vertical izquierdo
  # DP-1-1 = monitor central horizontal
  if connected "DP-1-2" && connected "DP-1-1"; then
    LEFT="DP-1-2"
    CENTER="DP-1-1"
    EXTRA="DP-1-3"
    LEFT_ROTATION="right"
    return 0
  fi

  # Variante posible si el dock aparece como DP-2-*
  # DP-2-2 = monitor vertical izquierdo
  # DP-2-1 = monitor central horizontal
  if connected "DP-2-2" && connected "DP-2-1"; then
    LEFT="DP-2-2"
    CENTER="DP-2-1"
    EXTRA="DP-2-3"
    LEFT_ROTATION="right"
    return 0
  fi

  return 1
}

apply_three_monitor_layout() {
  local left="$1"
  local center="$2"
  local left_rotation="${3:-right}"

  echo "Aplicando layout 3 monitores: LEFT=$left ROTATION=$left_rotation CENTER=$center LAPTOP=$INTERNAL"

  xrandr \
    --output "$left" --auto --rotate "$left_rotation" --pos 0x0 \
    --output "$center" --primary --auto --rotate normal --right-of "$left" \
    --output "$INTERNAL" --auto --rotate normal --right-of "$center"

  disable_all_except "$left" "$center" "$INTERNAL"
}

apply_two_monitor_layout() {
  local external="$1"

  echo "Aplicando layout 2 monitores: EXTERNAL=$external LAPTOP=$INTERNAL"

  xrandr \
    --output "$external" --primary --auto --rotate normal --pos 0x0 \
    --output "$INTERNAL" --auto --rotate normal --right-of "$external"

  disable_all_except "$external" "$INTERNAL"
}

apply_laptop_layout() {
  echo "Configuración laptop detectada"

  xrandr \
    --output "$INTERNAL" --primary --auto --rotate normal --pos 0x0

  disable_all_except "$INTERNAL"
}

# 1. Caso conocido de casa
if detect_home_outputs; then
  echo "Configuración casa detectada: LEFT=$LEFT CENTER=$CENTER EXTRA=$EXTRA LEFT_ROTATION=$LEFT_ROTATION"

  apply_three_monitor_layout "$LEFT" "$CENTER" "$LEFT_ROTATION"

  restart_xmonad_stack
  exit 0
fi

# 2. Fallback automático: agarrar monitores externos detectados por xrandr
mapfile -t EXTERNALS < <(external_connected_outputs)

if [[ "${#EXTERNALS[@]}" -ge 2 ]]; then
  echo "Configuración fallback con 2 externos detectados: ${EXTERNALS[*]}"

  # usa el primer monitor externo como central horizontal
  # y el segundo como vertical izquierdo.
  CENTER="${EXTERNALS[0]}"
  LEFT="${EXTERNALS[1]}"
  LEFT_ROTATION="right"

  apply_three_monitor_layout "$LEFT" "$CENTER" "$LEFT_ROTATION"

  restart_xmonad_stack
  exit 0
fi

if [[ "${#EXTERNALS[@]}" -eq 1 ]]; then
  echo "Configuración fallback con 1 externo detectado: ${EXTERNALS[0]}"

  apply_two_monitor_layout "${EXTERNALS[0]}"

  restart_xmonad_stack
  exit 0
fi

# 3. Sin externos
apply_laptop_layout

restart_xmonad_stackestart_xmonad_stack
