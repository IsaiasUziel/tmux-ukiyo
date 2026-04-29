#!/usr/bin/env bash
# =============================================================================
# disk_free.sh — Muestra espacio libre en disco para la barra de tmux
# Formato: "119.5GiB" (solo la cifra, sin label)
# =============================================================================
export LC_ALL=en_US.UTF-8

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/utils.sh"

main() {
  disk_mount=$(get_tmux_option "@ukiyo-disk-mount-on" "$HOME")

  case $(uname -s) in
  Darwin)
    available_kb=$(df -k "$disk_mount" 2>/dev/null | awk 'NR==2 {print $4}')
    if [[ -z "$available_kb" ]]; then
      echo "N/A"
      return
    fi

    available_bytes=$((available_kb * 1024))
    gib=$((available_bytes / 1073741824))
    mib=$((available_bytes / 1048576))

    if ((gib >= 1)); then
      gib_decimal=$(awk -v bytes="$available_bytes" 'BEGIN {printf "%.1f", bytes/1073741824}')
      if [[ "$gib_decimal" == *.0 ]]; then
        gib_decimal="${gib_decimal%.0}"
      fi
      echo "${gib_decimal}GiB"
    else
      echo "${mib}MiB"
    fi
    ;;

  Linux)
    available_kb=$(df -k "$disk_mount" 2>/dev/null | awk 'NR==2 {print $4}')
    if [[ -z "$available_kb" ]]; then
      echo "N/A"
      return
    fi

    available_bytes=$((available_kb * 1024))
    gib=$((available_bytes / 1073741824))
    mib=$((available_bytes / 1048576))

    if ((gib >= 1)); then
      gib_decimal=$(awk -v bytes="$available_bytes" 'BEGIN {printf "%.1f", bytes/1073741824}')
      if [[ "$gib_decimal" == *.0 ]]; then
        gib_decimal="${gib_decimal%.0}"
      fi
      echo "${gib_decimal}GiB"
    else
      echo "${mib}MiB"
    fi
    ;;

  *)
    echo "N/A"
    ;;
  esac
}

main