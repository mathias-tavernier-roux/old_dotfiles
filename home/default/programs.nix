{ config, pkgs, ... }:
{
############
# Programs #
#######################################################################
  nixpkgs.config.allowUnfree = true;
  # ----------------------------------------------------------------- #
  programs = {
    home-manager.enable = true;
    ## ------------------------------------------------------------- ##
    bat = {
      enable = true;
      config.theme = "base16";
    };
    ## ------------------------------------------------------------- ##
    dircolors.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
    ## ------------------------------------------------------------- ##
    feh.enable = true;
    lazygit.enable = true;
    neovim = {
      extraPackages = with pkgs; [
        clang-tools
        llvmPackages_latest.clang
        nil
      ];
      enable = true;
    };
  };
#######################################################################
}
