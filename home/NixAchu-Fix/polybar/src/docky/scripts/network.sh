#!/usr/bin/env bash

device=$(\
  nmcli -t -f name,device connection show --active \
  | grep wlp7s0 \
  | cut -d\: -f1 \
);
icon="󰤭  Offline";

if [ "${device}x" != "x" ]; then
  icon="󰤨  ${device}";
fi

echo "${icon}";
