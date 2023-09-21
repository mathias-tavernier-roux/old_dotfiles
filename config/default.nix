{ hostname }:
{ config, pkgs, ... }:
{
  imports =
    [
      ./issue
      ./polkit.nix
      ./razer-nari
    ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      warn-dirty = false;
    };
    optimise.automatic = true;
  };

  environment.pathsToLink = [ "/share/nix-direnv" ];
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (self: super: {
        nix-direnv = super.nix-direnv.override {
          enableFlakes = true;
        };
      })
    ];
  };

  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;

  programs = {
    command-not-found.enable = false;
    dconf.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    fish.enable = true;
  };
  
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };

  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    gpm.enable = true;

    picom = {
      enable = true;
      fade = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    xserver = {
      enable = true;
      layout = "fr";
      xkbOptions = "eurosign:e,caps:escape";

      libinput = {
        enable = true;
        touchpad.tapping = true;
        touchpad.naturalScrolling = true;
      };
      windowManager.i3.enable = true;
      displayManager.lightdm = {
        enable = true;
        autoLogin.enable = true;
        autoLogin.user = "gabriel";
      };
    };

    upower.enable = true;
  };

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

  users.users.gabriel = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "docker" "networkmanager" "libvirtd" "wheel" ];
  };

  fonts.fonts = with pkgs; [
    dina-font
    fira-code
    fira-code-symbols
    liberation_ttf
    mplus-outline-fonts.githubRelease
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    nerdfonts
    terminus-nerdfont
    inconsolata-nerdfont
    dejavu_fonts
    hackgen-nf-font
    proggyfonts
    google-fonts
    wine64Packages.fonts
    killall
    corefonts
    vistafonts
  ];

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  environment = {
    shells = with pkgs; [ fish ];
    variables.EDITOR = "ide";
    systemPackages = with pkgs; [
      modemmanager
      networkmanagerapplet
      git
      htop
      tree
      nano
      wget
      curl
      feh
      gdu
      xdotool
      zip
      unzip
      virt-manager
      winetricks
      wine-staging
      fish
      fishPlugins.bobthefish
      killall
      bc
      lutris
      heroic
      python311
      pciutils
      wget
      jdk19
      mangohud
      polkit
      mysql-workbench
      php82
      php82Extensions.openssl
      neovim
      lazygit
      tmux
      (pkgs.callPackage ./ide { })
    ];
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  programs.gamemode.enable = true;

  system = {
    copySystemConfiguration = false;
    stateVersion = "23.05";
  };

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  hardware.bluetooth.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
