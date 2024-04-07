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
      winumount 2> /dev/null || true
    ;;

    "releasex")
      winmount 2> /dev/null || true
    ;;
  esac
fi
