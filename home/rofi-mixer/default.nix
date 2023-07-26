{ stdenv, lib }:
stdenv.mkDerivation (finalAttrs: {
  pname = "rofi-mixer";
  version = "unstable-2023-07-16";

  src = ./src;

  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./rofi-mixer

    runHook postInstall
  '';

  meta = with lib; {
    description = "rofi audio interface manager";
    maintainers = [ maintainers.pikatsuto ];
    licenses = licenses.mit;
    platforms = platforms.linux;
  };
})
