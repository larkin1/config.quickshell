#!/usr/bin/env bash
set -euo pipefail
PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/wf-recorder.pid"
OUT="$HOME"

if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  kill -INT "$(cat "$PIDFILE")"
  rm -f "$PIDFILE"
  notify-send "Recording stopped" "saved to $OUT" || true
else
  command -v wf-recorder >/dev/null || { notify-send "wf-recorder not installed" || true; exit 1; }
  SLP="$(slurp -d -b '#181825b3' -c '#cdd6f4ff' </dev/null)" || exit 0
  FILE="$HOME/rec-$(date +%Y%m%d-%H%M%S).mkv"
  wf-recorder -a -g "$SLP" --audio-backend=pipewire -f "$FILE" >>/tmp/wf-recorder.log 2>&1 &
  echo $! > "$PIDFILE"
  # notify-send "Recording" "$FILE" || true
fi
