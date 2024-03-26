{ ... }:
{
#########
# Files #
#######################################################################
  home.file.lockscreen_configs = {
    source = ./lockscreen;
    target = ".local/bin/lockscreen_tmp";
    recursive = false;
  };
#######################################################################
}
