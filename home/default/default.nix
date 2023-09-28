{ username }:
{ pkgs, ... }:
{
###########
# Imports #
#######################################################################
  imports = [
    ## Config ------------------------------------------------------ ##
    ./extra_files
    ./gtk
  
    ## Apps -------------------------------------------------------- ##
    ./alacritty
    ./neofetch
    ./thunar
    ./btop
    ./nvim
    ./tmux
    ./flameshot
    ./git

    ## System ------------------------------------------------------ ##
    ./fish
    ./i3
    ./rofi/rofi
    ./picom
    ./betterlockscreen

    ## Other-------------------------------------------------------- ##
    ./programs.nix
  ];

############
# Packages #
#######################################################################
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    ## ------------------------------------------------------------- ##
    stateVersion = "23.05";
    sessionVariables = {
      EDITOR = "ide";
    };
    ## ------------------------------------------------------------- ##
    packages = with pkgs; [
      ### Settings ------------------------------------------------ ###
      /*
      arandr
      brightnessctl
      lxappearance
      rofi
      rofi-bluetooth
      (pkgs.callPackage ./rofi/rofi-beats { })
      (pkgs.callPackage ./rofi/rofi-wifi-menu { })
      (pkgs.callPackage ./rofi/rofi-mixer { })
      polybarFull
      alacritty
      numlockx
      libnotify
      dunst
      screen
      btop
      xdg-user-dirs
      */
      gnomeExtensions.activities-workspace-name
      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
      gnomeExtensions.tophat
      gnomeExtensions.user-themes
      gnomeExtensions.overview-background
      alacritty

      ### Volume -------------------------------------------------- ###
      # pavucontrol
      easyeffects
      # rofi-pulse-select

      ### Messaging ----------------------------------------------- ###
      discord

      ### Dev ----------------------------------------------------- ###
      jetbrains.phpstorm
      jetbrains.pycharm-professional
      vscode
      termius
      tilix

      ### Games --------------------------------------------------- ###
      minecraft
      prismlauncher

      ### Misc ---------------------------------------------------- ###
      pinta
      neofetch
      libreoffice
      onlyoffice-bin
      /*
      xarchiver
      zathura
      mpv
      youtube-dl
      xfce.ristretto
      */
      firefox
      vim
      neovim
      gcc
      glib
      tmuxPlugins.onedark-theme
      super-slicer-latest

      ### Utils --------------------------------------------------- ###
      peek
      # galculator
      flatpak
      gnome.gnome-software
      lazygit
    ];
  };
#######################################################################
}
