#!/bin/bash
# Wi-Fi throughput every 2s, shown as stacked labels: ↑ upload over ↓ download.
state=/tmp/sketchybar_net_${USER}
iface=$(route -n get default 2>/dev/null | awk '/interface:/{print $2}'); iface=${iface:-en0}

human() { awk -v b="$1" 'BEGIN{ if (b>=1048576) printf "%.1f MB/s", b/1048576; else if (b>=1024) printf "%d KB/s", b/1024; else printf "%d B/s", b }'; }

read -r rx tx < <(netstat -ibn -I "$iface" | awk 'NR>1 && $7 ~ /^[0-9]+$/ {print $7, $10; exit}')
now=$(date +%s)
if [ -f "$state" ]; then
  read -r prx ptx pt < "$state"; dt=$((now - pt)); [ "$dt" -lt 1 ] && dt=1
  dn=$(( (rx - prx) / dt )); up=$(( (tx - ptx) / dt ))
  [ "$dn" -lt 0 ] && dn=0; [ "$up" -lt 0 ] && up=0
  sketchybar --set net.up label="$(human "$up")" --set net.down label="$(human "$dn")"
fi
echo "$rx $tx $now" > "$state"
