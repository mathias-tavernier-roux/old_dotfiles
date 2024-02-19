{ hostname, username }:
{ config, pkgs, ... }:
{
###########
# Systemd #
#######################################################################
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    openssh.enable = true;
    gpm.enable = true;
    mpd.enable = true;
    ## ------------------------------------------------------------- ##
    mysql = {
      enable = true;
      package = pkgs.mariadb;
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
      windowManager.i3 = {
        enable = true;
        
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          i3blocks
        ];
      };
      desktopManager.xterm.enable = false;
      ### --------------------------------------------------------- ###
      displayManager = {
        defaultSession = "none+i3";
        lightdm = {
          enable = true;
          autoLogin.enable = true;
          autoLogin.user = username;
        };
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
