#!/bin/sh
OBJECT="$1"
OPERATION="$2"

if [[ "${OBJECT}x" == "win11x" ]]; then
  case "${OPERATION}x"
    in "preparex")
      {{ unbindList }}
      {{ restartDm }}
    ;;

    "startedx")
      chown {{ username }}:libvirtd /dev/shm/looking-glass
    ;;

    "releasex")
      {{ bindList }}
      {{ restartDm }}
    ;;
  esac
fi
