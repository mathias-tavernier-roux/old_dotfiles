{ pkgs, ... }:
{
##########
# Config #
#######################################################################
  gtk = {
    enable = true;

    cursorTheme = {
      name = "elementary";
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "gruvbox-dark";
      package = pkgs.gruvbox-dark-gtk;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };
#######################################################################
}
