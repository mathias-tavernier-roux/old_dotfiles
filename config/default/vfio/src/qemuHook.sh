#!/bin/sh
OBJECT="$1"
OPERATION="$2"

if [[ $OBJECT == "win11" ]]; then
  case "$OPERATION"
    in "prepare")
      {{ unbindList }}

      umount /run/media/gabriel/WIN11/ 2> /dev/null
      qemu-nbd --disconnect /dev/nbd0
      rmmod nbd

      {{ restartDm }}
      ;;

    "start")
      chown {{ username }}:libvirtd /dev/shm/looking-glass
      ;;

    "release")
      {{ bindList }}

      modprobe nbd max_part=8
      qemu-nbd --connect=/dev/nbd0 /windows/win11.qcow2

      {{ restartDm }}
      ;;
  esac

elif [[ $OBJECT == "win11-no-gpu" ]]; then
  case "$OPERATION"
    in "prepare")
      umount /run/media/gabriel/WIN11/ 2> /dev/null
      qemu-nbd --disconnect /dev/nbd0
      rmmod nbd
      ;;

    "release")
      modprobe nbd max_part=8
      qemu-nbd --connect=/dev/nbd0 /windows/win11.qcow2
      ;;
  esac
fi

