{ pkgs, ... }:
{
#########
# Files #
#######################################################################
  home.file = {
    xinitrc = {
      source = ./src/.xinitrc;
      target = ".xinitrc";
    };
    user-dirs = {
      source = ./src/user-dirs.dirs;
      target = ".config/xinitrc";
    };
    bashrc = {
      source = ./src/.bashrc;
      target = ".bashrc";
    };
    vimrc = {
      source = ./src/.vimrc;
      target = ".vimrc";
    };
    onedark_prompt = {
      source = ./src/.onedark_prompt.sh;
      target = ".config/.onedark_prompt.sh";
    };
    dircolors = {
      source = ./src/.dircolors;
      target = ".config/.dircolors";
    };
    profile = {
      source = ./src/.profile;
      target = ".profile";
    };
  };
########################################################################
}
