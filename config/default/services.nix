{ hostname, username }:
{ config, pkgs, ... }:
{
###########
# Systemd #
#######################################################################
  services = {
    gnome.gnome-keyring.enable = true;
    languagetool.enable = true;
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
      displayManager = {
        sddm.enable = true;
        defaultSession = "hyprland";
        autoLogin.enable = true;
        autoLogin.user = username;
      };
    };
    ## ------------------------------------------------------------- ##
    samba = {
      openFirewall = true;
      enable = true;
      securityType = "user";
      ### --------------------------------------------------------- ###
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
        #### ----------------------------------------------------- ####
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
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };
  # ------------------------------------------------------------------ #
  programs = {
    gamemode.enable = true;
    dconf.enable = true;
    xwayland.enable = true;
    ## -------------------------------------------------------------- ##
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
  # ------------------------------------------------------------------ #
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 445 5357 ];
    allowedUDPPorts = [ 59100 3702 ];
    allowPing = true;
  };
  # ------------------------------------------------------------------ #
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };
  # ------------------------------------------------------------------ #
  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
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
