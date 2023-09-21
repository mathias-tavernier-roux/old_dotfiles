{ stdenv, lib, pkgs }:
stdenv.mkDerivation (finalAttrs: {
  pname = "termide";
  version = "unstable-2023-07-16";

  src = ./src;

  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./ide

    runHook postInstall
  '';

  meta = with lib; {
    description = "terminal ide with xterm lazygit and tmux";
    maintainers = [ maintainers.pikatsuto ];
    licenses = licenses.lgpl;
    platforms = platforms.linux;
  };
})
