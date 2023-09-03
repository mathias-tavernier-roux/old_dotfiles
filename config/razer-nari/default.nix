{ pkgs, ... }:
{
  services.udev.extraRules = (builtins.readFile ./src/91-pulseaudio-razer-nari.rules);
  /*
  services.pipewire.package = pkgs.pipewire.overrideAttrs ({ patches ? [], ... }: {
    patches = [
      ./src/razer-nari-input.conf
      ./src/razer-nari-usb-audio.conf
      ./src/razer-nari-output-chat.conf
      ./src/razer-nari-output-game.conf
    ] ++ patches;
  });
  */
}
