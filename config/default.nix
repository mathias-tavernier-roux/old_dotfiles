{ hostname, username, vfio }:
{ config, ... }:
{
###########
# Imports #
#######################################################################
  imports = [
    (import ./default {
      inherit hostname;
      inherit username;
      inherit vfio;
    })
    ./${hostname}
  ];
#######################################################################
}
