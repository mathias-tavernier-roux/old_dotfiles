{ stdenv, lib }:
############
# Packages #
#######################################################################
stdenv.mkDerivation (finalAttrs: {
  pname = "rofi-wifi-menu";
  version = "unstable-2023-07-16";
  # ----------------------------------------------------------------- #
  src = ./src;
  # ----------------------------------------------------------------- #
  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./rofi-wifi-menu

    runHook postInstall
  '';
  # ----------------------------------------------------------------- #
  meta = with lib; {
    description = "rofi wifi manager";
    homepage = "https://github.com/ericmurphyxyz/rofi-wifi-menu";
    maintainers = [ maintainers.pikatsuto ];
    platforms = platforms.linux;
  };
#######################################################################
})
