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
    ./btop
    ./tmux
    ./flameshot
    ./git
    ./lvim

    ## System ------------------------------------------------------ ##
    ./fish
    ./rofi/rofi
    ./hyprland
    ./waybar

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
    stateVersion = "23.11";
    sessionVariables = {
      EDITOR = "ide";
    };
    ## ------------------------------------------------------------- ##
    packages = with pkgs; [
      ### Settings ------------------------------------------------ ###
      brightnessctl
      rofi
      rofi-bluetooth
      (pkgs.callPackage ./rofi/rofi-wifi-menu { })
      (pkgs.callPackage ./rofi/rofi-mixer { })
      waybar
      libnotify
      dunst
      screen
      btop
      xdg-user-dirs
      pywal
      acpi
      maim
      xclip
      looking-glass-client

      ### Volume -------------------------------------------------- ###
      pavucontrol
      rofi-pulse-select
      (pkgs.callPackage ./rofi/rofi-beats { })

      ### Messaging ----------------------------------------------- ###
      webcord-vencord
      discord

      ### Dev ----------------------------------------------------- ###
      jetbrains.phpstorm
      jetbrains.pycharm-professional
      vscode
      kitty
      gnumake

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
      gcc
      glib
      viewnior
      cinnamon.nemo-with-extensions

      ### Utils --------------------------------------------------- ###
      peek
      galculator
      flatpak
      lazygit
      git-lfs
      mpd
      calc
      remmina
      pywal
      swaybg
    ];
  };
#######################################################################
}
