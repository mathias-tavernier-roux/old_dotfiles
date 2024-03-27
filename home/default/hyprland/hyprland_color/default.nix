{ ... }:
{
#########
# Files #
#######################################################################
  home.file.hyprland_color = {
    source = ./color.conf;
    target = ".config/hypr/color.conf_tmp";
    recursive = false;
  };
#######################################################################
}
