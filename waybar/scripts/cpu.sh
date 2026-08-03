#!/bin/bash
# cpu usage in the bar, cpu/gpu temps in the tooltip

sample() {
  awk '/^cpu /{print ($2+$3+$4+$5+$6+$7+$8), ($5+$6)}' /proc/stat
}

read -r t1 i1 < <(sample)
sleep 0.4
read -r t2 i2 < <(sample)

dt=$((t2 - t1))
di=$((i2 - i1))
usage=0
if [ "$dt" -gt 0 ]; then
  usage=$(((100 * (dt - di) + dt / 2) / dt))
fi

# resolve hwmon by name, since hwmonN numbering is not stable across reboots
temp_by_name() {
  local want=$1 f
  for f in /sys/class/hwmon/hwmon*; do
    if [ "$(cat "$f/name" 2>/dev/null)" = "$want" ] && [ -r "$f/temp1_input" ]; then
      awk '{printf "%.0f", $1/1000}' "$f/temp1_input"
      return
    fi
  done
  printf '?'
}

cpu_t=$(temp_by_name k10temp)
gpu_t=$(temp_by_name amdgpu)

cls="normal"
if [ "$cpu_t" != "?" ] && [ "$cpu_t" -ge 85 ]; then
  cls="hot"
fi

printf '{"text":"cpu %d%%","tooltip":"cpu %s°C   gpu %s°C","class":"%s"}\n' \
  "$usage" "$cpu_t" "$gpu_t" "$cls"
