#!/usr/bin/env bash
set -euo pipefail
OUT="$HOME"

if pgrep -x wl-screenrec >/dev/null; then
  pkill -INT -x wl-screenrec
  notify-send "Recording stopped" "saved to $OUT" || true
else
  colors="$(cat "$HOME/.local/state/quickshell/generated/colors.json")"
  scrim="$(jq -r '.md3.scrim' <<<"$colors")"
  outline="$(jq -r '.md3.outline' <<<"$colors")"
  location="$(hyprctl -j clients | jq -r '.[] | select(.workspace.id != -1) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1]) \(.class)"' | slurp -o -B "${scrim}52" -b "${scrim}52" -c "${outline}ff")" # smart picker
  wl-screenrec -g "$location" -f "$OUT/rec-$(date +%F_%H-%M-%S).mkv" &
fi
