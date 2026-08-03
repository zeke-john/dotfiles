#!/bin/bash
# Emits {"text": "*N /"} where N is the total window count across the
# workspaces currently visible on every monitor (laptop + external count as
# one space). Collapsed group members are included.
# Tooltip lists each window as its app name (terminals keep their title);
# ▣ marks windows that are inside a group.

emit() {
  local ids
  ids=$(hyprctl -j monitors 2>/dev/null | jq -c '[.[].activeWorkspace.id]') || return
  [ -z "$ids" ] && return
  hyprctl -j clients | jq -c --argjson ids "$ids" '
    def nice:
      (.class // "") as $c
      | if ($c | ascii_downcase | test("kitty|alacritty|ghostty|foot")) then
          (.title // $c | gsub("^[^A-Za-z0-9~/.]+"; ""))
        elif $c == "org.gnome.Nautilus" then "Files"
        else ($c | split(".") | last | (.[0:1] | ascii_upcase) + .[1:])
        end
      | if length > 28 then .[0:27] + "…" else . end
      | gsub("&"; "&amp;") | gsub("<"; "&lt;") | gsub(">"; "&gt;");
    [.[] | select(.workspace.id as $w | $ids | index($w))] as $wins
    | ($wins | length) as $n
    | if $n > 0 then
        {text: "*\($n) <span color='"'"'#5C6066'"'"'>/</span>",
         tooltip: ($wins
           | map((if (.grouped | length) > 0 then "● " else "○ " end) + nice)
           | join("\n")),
         class: "active"}
      else
        {text: "", tooltip: "", class: "idle"}
      end'
}

emit

socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" 2>/dev/null |
  grep --line-buffered -E '^(openwindow|closewindow|movewindow|workspace|focusedmon|togglegroup|moveintogroup|moveoutofgroup|changefloatingmode|monitoradded|monitorremoved)' |
  while read -r _; do
    emit
  done
