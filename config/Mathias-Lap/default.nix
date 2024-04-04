{ config, pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_6_1;

    kernelParams = [
      "amd_iommu=on"
      "radeon.si_support=0"
      "amdgpu.si_support=1"
      "radeon.cik_support=0"
      "amdgpu.cik_support=1"
      "video=eDP-2:2560x1600@165"
      "mem_sleep_default=deep"
    ];

    supportedFilesystems = [ "ntfs" ];
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  hardware.opengl = {
	  enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      amdvlk
      mesa_drivers
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];
}
