{ username, hostname, home-manager }:
{ config, ... }:
{
###########
# Imports #
#######################################################################
  imports = [
    (import ./config {
      inherit hostname;
      inherit username;
    })
    ## ------------------------------------------------------------- ##
    ./hardware/${hostname}.nix
    ## ------------------------------------------------------------- ##
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = (import ./home {
        inherit username;
        inherit hostname;
      });
    }
  ];
#######################################################################
}

