{ pkgs, ... }:
{
##########
# Config #
#######################################################################
  gtk = {
    enable = true;

    theme = {
      name = "Orchis-Dark-Compact";
      package = pkgs.orchis-theme;
    };

    cursorTheme = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };
#######################################################################
}
