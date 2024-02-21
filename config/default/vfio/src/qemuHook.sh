#!/bin/sh
OBJECT="$1"
OPERATION="$2"

if [[ $OBJECT == "win11" ]]; then
  case "$OPERATION"
    in "prepare")
      {{ unbindList }}

      umount /run/media/gabriel/WIN11/ 2> /dev/null
      qemu-nbd --disconnect /dev/nbd0 2> /dev/null
      rmmod nbd 2> /dev/null

      {{ restartDm }}
      ;;

    "start")
      chown {{ username }}:libvirtd /dev/shm/looking-glass
      ;;

    "release")
      {{ bindList }}

      modprobe nbd max_part=8 2> /dev/null
      qemu-nbd --connect=/dev/nbd0 /var/lib/libvirt/images/win11.qcow2 2> /dev/null

      {{ restartDm }}
      ;;
  esac

elif [[ $OBJECT == "win11-no-gpu" ]]; then
  case "$OPERATION"
    in "prepare")
      umount /run/media/gabriel/WIN11/ 2> /dev/null
      qemu-nbd --disconnect /dev/nbd0 2> /dev/null
      rmmod nbd 2> /dev/null
      ;;

    "release")
      modprobe nbd max_part=8
      qemu-nbd --connect=/dev/nbd0 /var/lib/libvirt/images/win11.qcow2 2> /dev/null
      ;;
  esac
fi

