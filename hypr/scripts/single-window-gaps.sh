#!/bin/bash
# When a workspace on the external monitor has only 1 tiled window,
# add side gaps so it doesn't stretch the full width (cap at ~1700px).
# When 2+ tiled windows, reset to default gaps so tiling works normally.

TARGET_WIDTH=1650
DEFAULT_GAP=10
WORKSPACES=(1 2 3 4 5)
SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

get_side_gap() {
  local monitor_width
  monitor_width=$(hyprctl monitors -j | jq -r '[.[] | select(.name != "eDP-1")][0].width // empty')
  if [ -z "$monitor_width" ] || [ "$monitor_width" = "null" ]; then
    echo "$DEFAULT_GAP"
    return
  fi
  echo $(( (monitor_width - TARGET_WIDTH) / 2 ))
}

SIDE_GAP=$(get_side_gap)

update_gaps() {
  for ws in "${WORKSPACES[@]}"; do
    count=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $ws and .floating == false and .fullscreen == 0)] | length")
    if [ "$count" -eq 1 ]; then
      hyprctl keyword workspace "$ws,gapsout:$DEFAULT_GAP $SIDE_GAP $DEFAULT_GAP $SIDE_GAP" >/dev/null 2>&1
    else
      hyprctl keyword workspace "$ws,gapsout:$DEFAULT_GAP $DEFAULT_GAP $DEFAULT_GAP $DEFAULT_GAP" >/dev/null 2>&1
    fi
  done
}

# Initial run
update_gaps

# Listen for window events and update
socat -U - "UNIX-CONNECT:$SOCKET" | while read -r line; do
  case "$line" in
    openwindow*|closewindow*|movewindow*|changefloatingmode*|fullscreen*)
      sleep 0.1
      update_gaps
      ;;
  esac
done
