{ username, computer, home-manager }:
{ config, ... }:
{
###########
# Imports #
#######################################################################
  imports = [
    (import ./config {
      inherit computer;
      inherit username;
    })
    ## ------------------------------------------------------------- ##
    ./hardware/${computer.hostname}.nix
    ## ------------------------------------------------------------- ##
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = (import ./home {
        inherit username;
        hostname = computer.hostname;
      });
    }
  ];
#######################################################################
}

