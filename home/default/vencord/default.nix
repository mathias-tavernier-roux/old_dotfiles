{ pkgs, ... }:
{
#########
# Files #
#######################################################################
  home.file.vencord_configs = {
    source = ./src;
    target = ".config/VencordDesktop/VencordDesktop_tmp";
    recursive = true;
  };
#######################################################################
}

