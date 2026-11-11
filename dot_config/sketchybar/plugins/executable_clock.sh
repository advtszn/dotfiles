#!/bin/bash
# e.g. "Wed 5 Nov  13:42". Runs every second so the minute flips on time, but only
# redraws when the text actually changes (one `date` call per tick, nothing else).
now=$(date '+%a %-d %b  %H:%M')
cache="${TMPDIR:-/tmp}/sketchybar_clock"
[ "$SENDER" != "forced" ] && [ "$SENDER" != "system_woke" ] && [ "$(cat "$cache" 2>/dev/null)" = "$now" ] && exit 0
echo "$now" > "$cache"
sketchybar --set "$NAME" label="$now"
