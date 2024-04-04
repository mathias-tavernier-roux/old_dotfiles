{ username, diskPath, stdenv, lib, ... }:
############
# Packages #
#######################################################################
stdenv.mkDerivation (finalAttrs: {
  pname = "winutils";
  version = "unstable-2023-07-16";
  # ----------------------------------------------------------------- #
  src = ./src;
  # ----------------------------------------------------------------- #
  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./winmount
    install -D --target-directory=$out/bin/ ./winumount
    install -D --target-directory=$out/bin/ ./winstart

    DISK_PATH=$(echo "${diskPath}" | sed 's;/;\\/;g')

    sed -i "s/{{ username }}/${username}/g" $out/bin/winstart
    sed -i "s/{{ username }}/${username}/g" $out/bin/winumount
    sed -i "s/{{ diskPath }}/$DISK_PATH/g" $out/bin/winmount

    runHook postInstall
  '';
  # ----------------------------------------------------------------- #
  meta = with lib; {
    description = "mount, umount and start win11";
    maintainers = [ maintainers.pikatsuto ];
    platforms = platforms.linux;
  };
#######################################################################
})
