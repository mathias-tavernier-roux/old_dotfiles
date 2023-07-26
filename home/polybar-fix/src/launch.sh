#!/usr/bin/env sh

# Create env variable for polybar CPU temp.
for i in /sys/class/hwmon/hwmon*/temp*_input; do 
    if [ "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*}))" = "coretemp: temp1_input" ]; then
        export HWMON_PATH="$i"
    fi
done

DIR="$HOME/.config/polybar"
killall -q polybar
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload --quiet top -c ~/.config/polybar/config.ini &
  done
else
  polybar --reload example &
fi

#polybar --reload --quiet top -c ~/.config/polybar/config.ini &
