#!/usr/bin/env bash

set -u
set -o pipefail

usage() {
  cat <<EOF
Uso:
  $0 list
  $0 reset <usb-device>
  $0 reset-keyboard

Ejemplos:
  $0 list
  $0 reset 1-2.4
  $0 reset-keyboard

Notas:
  - <usb-device> es el nombre que aparece en /sys/bus/usb/devices, por ejemplo 1-2.4
  - reset-keyboard intenta resetear automáticamente dispositivos USB HID de tipo teclado
EOF
}

is_usb_device() {
  local dev="$1"

  [[ -f "$dev/idVendor" && -f "$dev/idProduct" && -f "$dev/authorized" ]]
}

device_name() {
  local dev="$1"
  local manufacturer=""
  local product=""
  local serial=""

  [[ -f "$dev/manufacturer" ]] && manufacturer="$(<"$dev/manufacturer")"
  [[ -f "$dev/product" ]] && product="$(<"$dev/product")"
  [[ -f "$dev/serial" ]] && serial="$(<"$dev/serial")"

  echo "$manufacturer $product $serial" | xargs
}

is_keyboard_device() {
  local dev="$1"
  local iface
  local class
  local protocol

  for iface in "$dev":*; do
    [[ -d "$iface" ]] || continue
    [[ -f "$iface/bInterfaceClass" ]] || continue
    [[ -f "$iface/bInterfaceProtocol" ]] || continue

    class="$(<"$iface/bInterfaceClass")"
    protocol="$(<"$iface/bInterfaceProtocol")"

    # USB HID class = 03
    # Keyboard boot protocol = 01
    if [[ "$class" == "03" && "$protocol" == "01" ]]; then
      return 0
    fi
  done

  return 1
}

list_devices() {
  local dev
  local base
  local vendor
  local product_id
  local name
  local keyboard_marker

  printf "%-12s %-11s %-9s %s\n" "DEVICE" "USB_ID" "KEYBOARD" "NAME"
  printf "%-12s %-11s %-9s %s\n" "------" "------" "--------" "----"

  for dev in /sys/bus/usb/devices/*; do
    is_usb_device "$dev" || continue

    base="$(basename "$dev")"
    vendor="$(<"$dev/idVendor")"
    product_id="$(<"$dev/idProduct")"
    name="$(device_name "$dev")"

    keyboard_marker="no"
    if is_keyboard_device "$dev"; then
      keyboard_marker="yes"
    fi

    printf "%-12s %s:%s   %-9s %s\n" "$base" "$vendor" "$product_id" "$keyboard_marker" "$name"
  done
}

require_root() {
  if [[ "$EUID" -ne 0 ]]; then
    exec sudo -- "$0" "$@"
  fi
}

reset_device() {
  local target="$1"
  local dev="/sys/bus/usb/devices/$target"

  if [[ ! -d "$dev" ]]; then
    echo "ERROR: no existe el dispositivo USB: $target"
    echo
    echo "Usá primero:"
    echo "  $0 list"
    exit 1
  fi

  if [[ ! -f "$dev/authorized" ]]; then
    echo "ERROR: el dispositivo $target no tiene archivo authorized."
    exit 1
  fi

  echo "Reseteando USB device: $target"
  echo "Nombre: $(device_name "$dev")"

  echo 0 > "$dev/authorized"
  sleep 1
  echo 1 > "$dev/authorized"

  echo "Listo."
}

reset_keyboards() {
  local dev
  local base
  local found=0

  for dev in /sys/bus/usb/devices/*; do
    is_usb_device "$dev" || continue
    is_keyboard_device "$dev" || continue

    base="$(basename "$dev")"
    found=1

    echo "Teclado detectado: $base - $(device_name "$dev")"
    reset_device "$base"
    echo
  done

  if [[ "$found" -eq 0 ]]; then
    echo "No encontré ningún teclado USB por interfaz HID keyboard."
    echo "Probá con:"
    echo "  $0 list"
    exit 1
  fi
}

ACTION="${1:-}"

case "$ACTION" in
  list)
    list_devices
    ;;

  reset)
    TARGET="${2:-}"
    if [[ -z "$TARGET" ]]; then
      usage
      exit 1
    fi

    require_root "$@"
    reset_device "$TARGET"
    ;;

  reset-keyboard)
    require_root "$@"
    reset_keyboards
    ;;

  *)
    usage
    exit 1
    ;;
esac
