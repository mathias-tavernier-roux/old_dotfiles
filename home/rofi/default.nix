{ pkgs, ... }:
{
  home.file.rofi_configs = {
    source = ./src;
    target = ".config/rofi";
    recursive = true;
  };
}
