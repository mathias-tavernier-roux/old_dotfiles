{ pkgs, ... }:
{
  services.betterlockscreen.enable = true;

  home.file.lockscreen = {
    source = ./../assets/lockscreen.jpg;
    target = "lockscreen.jpg";
  };
}
