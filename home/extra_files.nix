{ pkgs, ... }:
{
  home.file = {
    xinitrc = {
      source = ./../.xinitrc;
      target = ".xinitrc";
    };
    user-dirs = {
      source = ./../user-dirs.dirs;
      target = ".config/xinitrc";
    };
    bashrc = {
      source = ./.bashrc;
      target = ".bashrc";
    };
    vimrc = {
      source = ./.vimrc;
      target = ".vimrc";
    };
    onedark_prompt = {
      source = ./.onedark_prompt.sh;
      target = ".config/.onedark_prompt.sh";
    };
    dircolors = {
      source = ./.dircolors;
      target = ".config/.dircolors";
    };
  };
}
