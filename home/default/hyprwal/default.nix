{ stdenv, lib }:
############
# Packages #
#######################################################################
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprwal";
  version = "unstable-2023-07-16";
  # ----------------------------------------------------------------- #
  src = ./src;
  # ----------------------------------------------------------------- #
  installPhase = ''
    runHook preInstall
    install -D --target-directory=$out/bin/ ./hyprwal
    runHook postInstall
  '';
  # ----------------------------------------------------------------- #
  meta = with lib; {
    description = "wall all interface";
    maintainers = [ maintainers.pikatsuto ];
    licenses = licenses.lgpl;
    platforms = platforms.linux;
  };
#######################################################################
})
