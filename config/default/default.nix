{ computer, username }:
{ config, pkgs, ... }:
{
###########
# Imports #
#######################################################################
  imports =
    [
      (import ./services.nix {
        inherit username;
        hostname = computer.hostname;
      })
      ./programs.nix

      ./issue
      ./polkit

      (import ./vfio {
        vfio = computer.vfio;
        inherit username;
      })
      ./boot.nix
    ];
##########
# System #
#######################################################################
  system = {
    copySystemConfiguration = false;
    stateVersion = "23.11";
  };
  # ----------------------------------------------------------------- #
  documentation.dev.enable = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    ## ------------------------------------------------------------- ##
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      warn-dirty = false;
    };
    ## ------------------------------------------------------------- ##
    optimise.automatic = true;
  };
  # ----------------------------------------------------------------- #
  security.sudo.wheelNeedsPassword = false;
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };
  # ----------------------------------------------------------------- #
  nixpkgs.config.allowUnfree = true;
########
# User #
#######################################################################
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "docker" "networkmanager" "libvirtd" "wheel" ];
  };
##################
# Virtualisation #
#######################################################################
  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };
  };
#######################################################################
}
