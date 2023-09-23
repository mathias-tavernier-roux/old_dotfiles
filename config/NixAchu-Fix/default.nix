{ config, pkgs, ... }:
{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        gfxmodeEfi = "1920x1080x32";
      };
    };

    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "vfio_virqfd"
      "amdgpu"
    ];

    kernelParams = [
      "amd_iommu=on"
      "radeon.si_support=0"
      "amdgpu.si_support=1"
      "radeon.cik_support=0"
      "amdgpu.cik_support=1"
      "video=HDMI-A-1-0:2560x1440@144"
    ];

    supportedFilesystems = [ "ntfs" ];
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];

  hardware.opengl = {
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  environment = {
    systemPackages = with pkgs; [
      (pkgs.callPackage ./download-win10-fix { })
      (pkgs.callPackage ./audiorelay { })
      barrier
    ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 445 5357 ];
    allowedUDPPorts = [ 59100 3702 ];
    allowPing = true;
  };
  
  services.samba = {
    openFirewall = true;
    enable = true;
    securityType = "user";
    shares = {
      home = {
        path = "/home/gabriel";
        browseable = "yes";
        writeable = "yes";
        "acl allow execute always" = true;
        "read only" = "no";
        "valid users" = "gabriel";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "gabriel";
        "force group" = "users";
      };
      media = {
        path = "/run/media/gabriel";
        browseable = "yes";
        writeable = "yes";
        "acl allow execute always" = true;
        "read only" = "no";
        "valid users" = "gabriel";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "gabriel";
        "force group" = "users";
      };
    };
  };

  systemd.services.libvirtd.preStart = let
    qemuHook = pkgs.writeScript "qemu-hook" ''
      #!/bin/sh

      OBJECT="$1"
      OPERATION="$2"

      if [[ $OBJECT == "win10" ]]; then
        case "$OPERATION"
          in "prepare")
            echo 0000:03:00.0 > /sys/bus/pci/devices/0000\:03\:00.0/driver/unbind
            echo 0000:03:00.1 > /sys/bus/pci/devices/0000\:03\:00.1/driver/unbind
            
            umount /run/media/gabriel/WIN10/ 2> /dev/null
            qemu-nbd --disconnect /dev/nbd0
            rmmod nbd

            systemctl restart display-manager.service
          ;;

          "release")
            echo 0000:03:00.0 > /sys/bus/pci/drivers/amdgpu/bind
            echo 0000:03:00.1 > /sys/bus/pci/drivers/amdgpu/bind
            
            modprobe nbd max_part=8
            qemu-nbd --connect=/dev/nbd0 /windows/win10.qcow2

            systemctl restart display-manager.service
          ;;
        esac

      elif [[ $OBJECT == "win10-no-gpu" ]]; then
        case "$OPERATION"
          in "prepare")
            umount /run/media/gabriel/WIN10/ 2> /dev/null
            qemu-nbd --disconnect /dev/nbd0
            rmmod nbd
          ;;

          "release")
            modprobe nbd max_part=8
            qemu-nbd --connect=/dev/nbd0 /windows/win10.qcow2
          ;;
        esac
      fi
    '';
  in ''
    mkdir -p /var/lib/libvirt/hooks
    chmod 755 /var/lib/libvirt/hooks

    # Copy hook files
    ln -sf ${qemuHook} /var/lib/libvirt/hooks/qemu
  '';
}
