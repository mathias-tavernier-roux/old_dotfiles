{ pkgs, ... }:
{
#########
# Files #
#######################################################################
  home.file.vencord_desktop_configs = {
    source = ./src;
    target = ".config/VencordDesktop/VencordDesktopTmp";
    recursive = true;
  };
#######################################################################
}

