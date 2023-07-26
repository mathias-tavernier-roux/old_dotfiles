{ stdenv, lib }:
stdenv.mkDerivation (finalAttrs: {
  pname = "razer-nari";
  version = "unstable-2023-07-16";

  src = ./src;

  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/usr/share/alsa-card-profile/mixer/paths/ ./razer-nari-input.conf
    install -D --target-directory=$out/usr/share/alsa-card-profile/mixer/paths/ ./razer-nari-output-game.conf
    install -D --target-directory=$out/usr/share/alsa-card-profile/mixer/paths/ ./razer-nari-output-chat.conf
    install -D --target-directory=$out/usr/share/alsa-card-profile/mixer/profile-sets/ ./razer-nari-usb-audio.conf
    install -D --target-directory=$out/lib/udev/rules.d/ ./91-pulseaudio-razer-nari.rules

    runHook postInstall
  '';

  meta = with lib; {
    description = "razer nari ultimate driver";
    homepage = "https://github.com/imustafin/razer-nari-pulseaudio-profile";
    maintainers = [ maintainers.pikatsuto ];
    licenses = licenses.mit;
    platforms = platforms.linux;
  };
})
