{ config, pkgs, username, ... }:
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./polybar-fix
  ];
}