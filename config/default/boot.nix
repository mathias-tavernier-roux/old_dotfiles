{ config, pkgs, ... }:
{
  boot = {
    kernel.sysctl = { "vm.swappiness" = 1;};

    kernelParams = [
      "net.ifnames=0"
    ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        gfxmodeEfi = "1920x1080x32";
        useOSProber = true;
      };
    };

    plymouth.enable = true;
  };
}
