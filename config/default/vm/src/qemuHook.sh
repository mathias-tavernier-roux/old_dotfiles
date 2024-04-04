#!/bin/sh
OBJECT="$1"
OPERATION="$2"

if [[ "${OBJECT}x" == "win11x" ]]; then
  case "${OPERATION}x"
    in "preparex")
      {{ unbindList }}

      winumount 2> /dev/null || true

      {{ restartDm }}
    ;;

    "startedx")
      chown {{ username }}:libvirtd /dev/shm/looking-glass
    ;;

    "releasex")
      {{ bindList }}

      winmount 2> /dev/null || true

      {{ restartDm }}
    ;;
  esac

elif [[ "${OBJECT}x" == "win11-no-gpux" ]]; then
  case "${OPERATION}x"
    in "preparex")
      umount /run/media/{{ username }}/WIN11/ 2> /dev/null || true
      qemu-nbd --disconnect /dev/nbd0 2> /dev/null || true
      rmmod nbd 2> /dev/null || true
    ;;

    "releasex")
      modprobe nbd max_part=8 2> /dev/null || true
      qemu-nbd \
        --connect=/dev/nbd0 \
        /var/lib/libvirt/images/win11.qcow2 2> /dev/null || true
    ;;
  esac
fi
