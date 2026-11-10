#!/bin/bash
# Apple Music now playing (display only, no controls, no scrolling).
#   playing → "title · artist" in white (truncated at 30 chars)   paused → same, grey
#   Music closed / nothing loaded → hidden
# Driven by Music's playerInfo notification; the routine tick only checks whether
# Music is still running (never talks to it, so it can't relaunch Music).
WHITE=0xffffffff; GREY=0xffa0a0a0
export LC_ALL=en_US.UTF-8   # so ${#text} counts characters, not bytes

hide() { sketchybar --set music drawing=off --set music.gap drawing=off --set music_island drawing=off; exit 0; }

pgrep -xq Music || hide

if [ "$SENDER" = "music_change" ] && [ -n "$INFO" ]; then
  state=$(echo "$INFO" | jq -r '."Player State" // empty')
  title=$(echo "$INFO" | jq -r '.Name // empty')
  artist=$(echo "$INFO" | jq -r '.Artist // empty')
elif [ "$SENDER" = "routine" ]; then
  exit 0   # still running; leave the current state alone
else       # startup / reload / wake: ask Music once (it's running, checked above)
  IFS=$'\t' read -r state title artist < <(osascript -e 'tell application "Music"
    set s to player state as text
    if s is "stopped" then return s
    tell current track to return s & tab & name & tab & artist
  end tell' 2>/dev/null)
  case "$state" in playing) state=Playing ;; paused) state=Paused ;; esac
fi

case "$state" in Playing|Paused) ;; *) hide ;; esac
[ -z "$title" ] && hide

text="$title"; [ -n "$artist" ] && text="$title · $artist"
[ ${#text} -gt 40 ] && text="${text:0:39}…"   # island grows up to 40 chars, then truncates

if [ "$state" = "Playing" ]; then col=$WHITE; else col=$GREY; fi
sketchybar --set music drawing=on label="$text" label.color=$col icon.color=$col \
           --set music.gap drawing=on --set music_island drawing=on
