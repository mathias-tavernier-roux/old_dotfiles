{ stdenv, lib }:
############
# Packages #
#######################################################################
stdenv.mkDerivation (finalAttrs: {
  pname = "rofi-vm";
  version = "unstable-2023-07-16";
  # ----------------------------------------------------------------- #
  src = ./src;
  # ----------------------------------------------------------------- #
  installPhase = ''
    runHook preInstall
    install -D --target-directory=$out/bin/ ./rofi-vm
    runHook postInstall
  '';
  # ----------------------------------------------------------------- #
  meta = with lib; {
    description = "rofi VM manager";
    maintainers = [ maintainers.pikatsuto ];
    licenses = licenses.gpl3;
    platforms = platforms.linux;
  };
#######################################################################
})