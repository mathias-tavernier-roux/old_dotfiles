{ stdenv, lib }:
############
# Packages #
#######################################################################
stdenv.mkDerivation (finalAttrs: {
  pname = "rofi-beats";
  version = "unstable-2023-07-16";
  # ----------------------------------------------------------------- #
  src = ./src;
  # ----------------------------------------------------------------- #
  installPhase = ''
    runHook preInstall
    install -D --target-directory=$out/bin/ ./rofi-beats
    install -D --target-directory=$out/bin/ ./play-music
    runHook postInstall
  '';
  # ----------------------------------------------------------------- #
  meta = with lib; {
    description = "rofi music manager";
    homepage = "https://github.com/Carbon-Bl4ck/Rofi-Beats";
    maintainers = [ maintainers.pikatsuto ];
    licenses = licenses.gpl3;
    platforms = platforms.linux;
  };
#######################################################################
})
