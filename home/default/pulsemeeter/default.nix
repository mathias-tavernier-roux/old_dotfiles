{ stdenv, lib }:
stdenv.mkDerivation (finalAttrs: {
  pname = "pulsemeeter";
  version = "unstable-2023-07-16";

  src = ./src;

  installPhase = ''
    runHook preInstall
    pip install pulsemeeter
    runHook postInstall
  '';

  meta = with lib; {
    description = "voicemeeter for pulseaudio";
    homepage = "https://github.com/theRealCarneiro/pulsemeeter";
    maintainers = [ maintainers.pikatsuto ];
    licenses = licenses.mit;
    platforms = platforms.linux;
  };
})
