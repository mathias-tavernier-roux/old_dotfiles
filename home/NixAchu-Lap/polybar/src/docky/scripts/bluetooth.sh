#!/usr/bin/env bash

device=$(\
  bluetoothctl devices Connected \
  | cut -f2 -d' ' \
  \
  | while read uuid; do \
      bluetoothctl info $uuid; \
      break; \
    done \
  \
  | grep -e 'Name' \
  | sed 's/\tName: //g' \
);
icon=" No Devices";

if [[ "${device}x" != "x" ]]; then
  icon="  ${device}";
fi

echo "${icon}";
