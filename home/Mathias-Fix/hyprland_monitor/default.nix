{ ... }:
{
#########
# Files #
#######################################################################
  home.file.hyprland_monitor = {
    source = ./monitor.conf;
    target = ".config/hypr/monitor.conf";
    recursive = false;
  };
#######################################################################
}
