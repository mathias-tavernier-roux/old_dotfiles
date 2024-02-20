{ vfio }:
{ config, pkgs, lib, ... }:
lib.mkIf (vfio != false) {
  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "vfio_virqfd"
      "amdgpu"
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      (pkgs.callPackage ./mount-win11 { })
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
    escapedPcies = lib.forEach vfio.pcies (pcie: {
      pcie = pcie.pcie;
      escapePcie = builtins.replaceStrings [":"] ["\\:"] pcie.pcie;
    });
    unbindList = lib.forEach escapedPcies (pcie:
      ''echo 0000:${pcie.pcie} > /sys/bus/pci/devices/0000\:${pcie.escapePcie}/driver/unbind
      ''
    );
    bindList = lib.forEach vfio.pcies (pcie:
      ''echo 0000:${pcie.pcie} > /sys/bus/pci/drivers/${pcie.driver}/bind
      ''
    );

    restartDm =
      if vfio.restartDm
      then "systemctl restart display-manager.service"
      else "# disable restart dm";

    splitedConfig = [''
      #!/bin/sh

      OBJECT="$1"
      OPERATION="$2"

      if [[ $OBJECT == "win11" ]]; then
        case "$OPERATION"
          in "prepare")
            ''] ++ unbindList ++ [''
            
            umount /run/media/gabriel/WIN11/ 2> /dev/null
            qemu-nbd --disconnect /dev/nbd0
            rmmod nbd

            ${restartDm}
          ;;

          "release")
            ''] ++ bindList ++ [''

            modprobe nbd max_part=8
            qemu-nbd --connect=/dev/nbd0 /windows/win10.qcow2

            ${restartDm}
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
    ''];

    config = lib.concatStrings splitedConfig;
    qemuHook = pkgs.writeScript "qemu-hook" config;
  in ''
    mkdir -p /var/lib/libvirt/hooks
    chmod 755 /var/lib/libvirt/hooks

    # Copy hook files
    ln -sf ${qemuHook} /var/lib/libvirt/hooks/qemu
  '';
}
