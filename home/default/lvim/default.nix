{ pkgs, ... }:
{
#########
# Files #
#######################################################################
  home.file.lvim_configs = {
    source = ./src/configs;
    target = ".config/lvim";
    recursive = true;
  };
  home.file.lvim_share_lvim = {
    source = ./src/share/lvim;
    target = ".local/share/lvim";
    recursive = true;
  };
  home.file.lvim_share_lunarvim = {
    source = ./src/share/lunarvim;
    target = ".local/share/lunarvim";
    recursive = true;
  };
  home.file.lvim_bin = {
    source = ./src/bin;
    target = ".local/bin";
    recursive = true;
  };
#######################################################################
}
