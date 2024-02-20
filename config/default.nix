{ computer, username }:
{ config, ... }:
{
###########
# Imports #
#######################################################################
  imports = [
    (import ./default {
      inherit computer;
      inherit username;
    })
    ./${computer.hostname}
  ];
#######################################################################
}
