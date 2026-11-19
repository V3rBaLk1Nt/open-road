#!/bin/bash
# stop.sh - Unconditionally silence ALL piper TTS playback started by speak.sh.
# Bound to Super+Shift+Q. This is a hard stop with no race, no toggle logic and
# no timing window: it kills the players, the synthesizers, and clears state.
set -u
CONFIG="/home/d1v1d3dd3v3l0p3r/.config/opencode-assist"
PIDFILE="$CONFIG/speak.pid"
LOCKDIR="/tmp/opencode-speak.lock"

# Kill everything belonging to a TTS run: the pw-play players and any piper
# synthesis still in flight. Both carry the unique wav path in their cmdline, so
# the pattern cannot match unrelated processes. Do NOT pkill on "speak.sh" or
# "python": those patterns match the shell or terminal that invoked this script.
pkill -f 'opencode_speak.wav' 2>/dev/null

if [ -f "$PIDFILE" ]; then
  read -r OLD_PID _ < "$PIDFILE" 2>/dev/null
  if [ -n "${OLD_PID:-}" ] && [ -r "/proc/$OLD_PID/cmdline" ]; then
    kill -9 "$OLD_PID" 2>/dev/null
  fi
  rm -f "$PIDFILE"
fi

# Release the start lock so Super+Shift+V works again immediately.
if [ -d "$LOCKDIR" ]; then
  rm -rf "$LOCKDIR"
fi
rm -f /tmp/opencode_speak.wav

echo "TTS stopped"
exit 0
