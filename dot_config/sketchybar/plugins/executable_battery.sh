#!/bin/bash
# Battery: SF Symbol icon (level / charging bolt) + %. Red under 20% on battery.
# Glyphs are embedded literally (macOS bash 3.2 has no printf \U).
info=$(pmset -g batt)
pct=$(grep -Eo '[0-9]+%' <<<"$info" | head -1 | tr -d '%')
[ -z "$pct" ] && exit 0

WHITE=0xffffffff; GREY=0xffa0a0a0; RED=0xffff8080; MINT=0xff99ffe4
if   [ "$pct" -ge 88 ]; then icon="􀛨"   # battery.100
elif [ "$pct" -ge 63 ]; then icon="􀺸"   # battery.75
elif [ "$pct" -ge 38 ]; then icon="􀺶"   # battery.50
elif [ "$pct" -ge 13 ]; then icon="􀛩"   # battery.25
else                         icon="􀛪"   # battery.0
fi
icolor=$GREY; lcolor=$WHITE
if grep -q 'AC Power' <<<"$info"; then
  icon="􀢋"; icolor=$MINT                # battery.100.bolt
elif [ "$pct" -lt 20 ]; then
  icolor=$RED; lcolor=$RED
fi
sketchybar --set "$NAME" icon="$icon" icon.color=$icolor label="$pct%" label.color=$lcolor
