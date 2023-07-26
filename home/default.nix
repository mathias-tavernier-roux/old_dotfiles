{ config, pkgs, username, ... }:
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./alacritty
    ./fish
    ./i3
    ./neofetch
    ./rofi
    ./thunar
    ./btop
    ./nvim
    ./tmux

    ./betterlockscreen.nix
    ./extra_files.nix
    ./flameshot.nix
    ./git.nix
    ./gtk.nix
    # ./iso.nix
    ./profile.nix
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/ftp" = [ "firefox.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      "application/x-extension-htm" = [ "firefox.desktop" ];
      "application/x-extension-html" = [ "firefox.desktop" ];
      "application/x-extension-shtml" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "application/x-extension-xhtml" = [ "firefox.desktop" ];
      "application/x-extension-xht" = [ "firefox.desktop" ];
      "application/x-compressed-tar" = [ "xarchiver.desktop" ];
      "application/zip" = [ "xarchiver.desktop" ];
    };
  };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    stateVersion = "23.05";
    sessionVariables = {
      EDITOR = pkgs.nano;
    };

    packages = with pkgs; [
      # settings
      arandr
      brightnessctl
      lxappearance
      rofi
      rofi-bluetooth
      (pkgs.callPackage ./rofi-beats { })
      (pkgs.callPackage ./rofi-wifi-menu { })
      (pkgs.callPackage ./rofi-mixer { })
      polybarFull
      alacritty
      numlockx
      libnotify
      dunst
      screen
      btop
      xdg-user-dirs

      # volume
      pavucontrol
      easyeffects
      rofi-pulse-select

      # messaging
      discord

      # dev
      jetbrains-toolbox
      vscode
      termius

      # game
      minecraft
      prismlauncher

      # misc
      pinta
      neofetch
      libreoffice
      onlyoffice-bin
      xarchiver
      zathura
      mpv
      youtube-dl
      xfce.ristretto
      firefox
      vim
      neovim
      gcc
      glib
      tmuxPlugins.onedark-theme

      # utils
      peek
      galculator
      flatpak
      gnome.gnome-software
      lazygit
    ];
  };

  programs = {
    home-manager.enable = true;

    bat = {
      enable = true;
      config.theme = "base16";
    };

    dircolors.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    feh.enable = true;
    lazygit.enable = true;
  };
}
