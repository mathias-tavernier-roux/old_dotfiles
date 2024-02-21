{ stdenv, lib }:
############
# Packages #
#######################################################################
stdenv.mkDerivation (finalAttrs: {
  pname = "mount-win11";
  version = "unstable-2023-07-16";
  # ----------------------------------------------------------------- #
  src = ./src;
  # ----------------------------------------------------------------- #
  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./mount-win11
    install -D --target-directory=$out/bin/ ./umount-win11

    runHook postInstall
  '';
  # ----------------------------------------------------------------- #
  meta = with lib; {
    description = "mount and umount win11 qemu disk";
    maintainers = [ maintainers.pikatsuto ];
    platforms = platforms.linux;
  };
#######################################################################
})
