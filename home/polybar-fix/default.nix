{ pkgs, ... }:
{
  home.file.polybar_configs = {
    source = ./src;
    target = ".config/polybar";
    recursive = true;
  };
}
