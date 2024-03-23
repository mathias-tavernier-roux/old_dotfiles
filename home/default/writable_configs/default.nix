{ stdenv, lib }:
############
# Packages #
#######################################################################
stdenv.mkDerivation (finalAttrs: {
  pname = "Writable-configs";
  version = "unstable-2023-07-16";
  # ----------------------------------------------------------------- #
  src = ./src;
  # ----------------------------------------------------------------- #
  installPhase = ''
    runHook preInstall
    install -D --target-directory=$out/bin/ ./cpwrconf
    runHook postInstall
  '';
  # ----------------------------------------------------------------- #
  meta = with lib; {
    description = "copy config with writable for skip programs error";
    maintainers = [ maintainers.pikatsuto ];
    licenses = licenses.lgpl;
    platforms = platforms.linux;
  };
#######################################################################
})
