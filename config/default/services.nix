{ hostname, username }:
{ config, pkgs, ... }:
{
###########
# Systemd #
#######################################################################
  services = {
    upower.enable = true;
    gnome.gnome-keyring.enable = true;
    languagetool.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    openssh.enable = true;
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
      jack.enable = true;
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
        sddm = {
          enable = true;
          wayland.enable = true;
          autoNumlock = true;
          autoLogin.relogin = true;
        };
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
          path = "/home/${username}";
          browseable = "yes";
          writeable = "yes";
          "acl allow execute always" = true;
          "read only" = "no";
          "valid users" = "${username}";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "${username}";
          "force group" = "users";
        };
        #### ----------------------------------------------------- ####
        media = {
          path = "/run/media/${username}";
          browseable = "yes";
          writeable = "yes";
          "acl allow execute always" = true;
          "read only" = "no";
          "valid users" = "${username}";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "${username}";
          "force group" = "users";
        };
      };
    };
    fprintd.enable = true;
    ## -------------------------------------------------------------- ##
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    tlp = {
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };
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
  security = {
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
    rtkit.enable = true;
  };
  # ------------------------------------------------------------------ #
  zramSwap.enable = true;
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
  hardware.keyboard.qmk.enable = true;
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
