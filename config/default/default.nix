{ hostname, username }:
{ config, pkgs, ... }:
{
###########
# Imports #
#######################################################################
  imports =
    [
      (import ./services.nix {
        username = username;
        hostname = hostname;
      })
      ./programs.nix

      ./issue
      ./polkit
    ];
##########
# System #
#######################################################################
  system = {
    copySystemConfiguration = false;
    stateVersion = "23.05";
  };
  # ----------------------------------------------------------------- #
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
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };
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
    libvirtd.enable = true;
  };
#######################################################################
}
