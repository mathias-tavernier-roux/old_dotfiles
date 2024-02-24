{ config, pkgs, ... }:
{
############
# Settings #
#######################################################################
  programs = {
    command-not-found.enable = false;
    dconf.enable = true;
    ## ------------------------------------------------------------- ##
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    ## ------------------------------------------------------------- ##
    fish.enable = true;
  };
#########
# Fonts #
#######################################################################
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
    corefonts
    vistafonts
  ];
###########
# Package #
#######################################################################
  environment = {
    shells = with pkgs; [ fish ];
    variables.EDITOR = "ide";
    systemPackages = with pkgs; [
      ### Utils --------------------------------------------------- ###
      git
      htop
      tree
      nano
      wget
      curl
      zip
      unzip
      winetricks
      wine-staging
      fish
      fishPlugins.bobthefish
      killall
      bc
      tmux
      pciutils
      polkit
      nix-direnv

      ### System -------------------------------------------------- ###
      modemmanager
      feh
      gdu
      xdotool
      wpgtk

      ### Dev ----------------------------------------------------- ###
      jdk19
      virt-manager
      mysql-workbench
      php82
      php82Extensions.openssl
      neovim
      lazygit
      (pkgs.callPackage ./ide { })

      ### Game ---------------------------------------------------- ###
      lutris
      heroic
      mangohud
    ];
  };
 # ------------------------------------------------------------------ #
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
#######################################################################
}
