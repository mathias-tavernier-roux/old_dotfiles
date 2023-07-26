#!/bin/bash

function recordStart() {
    pkill -f peek &>/dev/null
    screen -d -m peek --no-headerbar
    sleep 1
    peekInstance=$(echo $(xdotool search --name peek) | cut -d " " -f 2)
    xdotool windowmove $peekInstance 0 0
    xdotool windowsize $peekInstance 1920 1080
    peek --start
}

chosen=$(printf "● Record Start\nX Kill Peek" | rofi -dmenu -i)

case "$chosen" in
    "● Record Start") recordStart ;;
    "X Kill Peek") killall peek ;;
    *) exit 1 ;;
esac
