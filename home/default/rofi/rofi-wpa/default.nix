{ stdenv, lib }:
############
# Packages #
#######################################################################
stdenv.mkDerivation (finalAttrs: {
  pname = "rofi-wpa";
  version = "unstable-2023-07-16";
  # ----------------------------------------------------------------- #
  src = ./src;
  # ----------------------------------------------------------------- #
  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./rofi-wpa

    runHook postInstall
  '';
  # ----------------------------------------------------------------- #
  meta = with lib; {
    description = "rofi wpa_supplicant based wifi manager";
    maintainers = [ maintainers.pikatsuto ];
    licenses = licenses.gpl3;
    platforms = platforms.linux;
  };
#######################################################################
})
