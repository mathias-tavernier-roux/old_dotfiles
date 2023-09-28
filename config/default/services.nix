{ hostname, username }:
{ config, pkgs, ... }:
{
###############
# Environment #
#######################################################################
  environment.pathsToLink = [ "/share/nix-direnv" ];
  nixpkgs = {
    config.allowUnfree = true;
    ## ------------------------------------------------------------- ##
    overlays = [
      (self: super: {
        nix-direnv = super.nix-direnv.override {
          enableFlakes = true;
        };
      })
    ];
  };
###########
# Systemd #
#######################################################################
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    gpm.enable = true;
    ## ------------------------------------------------------------- ##
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
    ## ------------------------------------------------------------- ##
    picom = {
      enable = true;
      fade = true;
    };
    ## ------------------------------------------------------------- ##
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    ## ------------------------------------------------------------- ##
    xserver = {
      enable = true;
      layout = "fr";
      xkbOptions = "eurosign:e,caps:escape";
      ### --------------------------------------------------------- ###
      libinput = {
        enable = true;
        touchpad.tapping = true;
        touchpad.naturalScrolling = true;
      };
      ### --------------------------------------------------------- ###
      desktopManager.gnome.enable = true;
      ### --------------------------------------------------------- ###
      displayManager.gdm = {
        enable = true;
        autoLogin.enable = true;
        autoLogin.user = username;
      };
    };
    ## -------------------------------------------------------------- ##
    upower.enable = true;
  };
  # ------------------------------------------------------------------ #
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
  # ------------------------------------------------------------------ #
  programs.gamemode.enable = true;
############
# Hardware #
########################################################################
  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };
  # ------------------------------------------------------------------ #
  hardware.bluetooth.enable = true;
  # ------------------------------------------------------------------ #
  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
  };
  # ------------------------------------------------------------------ #
  sound.enable = true;
  hardware.pulseaudio.enable = false;
########################################################################
}
