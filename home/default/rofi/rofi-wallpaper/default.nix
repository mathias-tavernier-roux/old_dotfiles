{ stdenv, lib }:
############
# Packages #
#######################################################################
stdenv.mkDerivation (finalAttrs: {
  pname = "rofi-wallpaper";
  version = "unstable-2023-07-16";
  # ----------------------------------------------------------------- #
  src = ./src;
  # ----------------------------------------------------------------- #
  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./rofi-wallpaper

    runHook postInstall
  '';
  # ----------------------------------------------------------------- #
  meta = with lib; {
    description = "rofi hyprwal wallpaper_manager";
    maintainers = [ maintainers.mh13 ];
    licenses = licenses.gpl3;
    platforms = platforms.linux;
  };
#######################################################################
})
