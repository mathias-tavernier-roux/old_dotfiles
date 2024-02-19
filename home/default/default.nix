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
    ./kitty
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
      arandr
      brightnessctl
      lxappearance
      rofi
      rofi-bluetooth
      (pkgs.callPackage ./rofi/rofi-beats { })
      (pkgs.callPackage ./rofi/rofi-wifi-menu { })
      (pkgs.callPackage ./rofi/rofi-mixer { })
      polybarFull
      numlockx
      libnotify
      dunst
      screen
      btop
      xdg-user-dirs
      pywal
      acpi
      maim
      xclip
      picom-jonaburg

      ### Volume -------------------------------------------------- ###
      pavucontrol
      rofi-pulse-select

      ### Messaging ----------------------------------------------- ###
      discord

      ### Dev ----------------------------------------------------- ###
      jetbrains.phpstorm
      jetbrains.pycharm-professional
      vscode
      kitty

      ### Games --------------------------------------------------- ###
      minecraft
      prismlauncher

      ### Misc ---------------------------------------------------- ###
      pinta
      neofetch
      libreoffice
      onlyoffice-bin
      xarchiver
      zathura
      mpv
      mpc-cli
      youtube-dl
      xfce.ristretto
      firefox
      vim
      neovim
      gcc
      glib
      viewnior

      ### Utils --------------------------------------------------- ###
      peek
      galculator
      flatpak
      lazygit
      mpd
      calc
    ];
  };
#######################################################################
}
