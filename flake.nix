{
###########
# Imports #
#######################################################################
  description = "Pikatsuto dotfiles";
  # ----------------------------------------------------------------- #
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    ## ------------------------------------------------------------- ##
    hosts.url = github:StevenBlack/hosts;
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    ## ------------------------------------------------------------- ##
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
#############
# Variables #
#######################################################################
  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    hosts,
    ...
  } @inputs: let
    username = "gabriel";
    system = "x86_64-linux";
    hostname = "NixAchu";

    computer = {
      hostname = "${hostname}-Computer";
      vfio = {
        restartDm = false;
        pcies = [
          {
            pcie = ''01:00.0'';
            driver = ''nouveau'';
            code = ''10de:2184'';
          }
          {
            pcie = ''01:00.1'';
            driver = ''nouveau'';
            code = ''10de:1aeb'';
          }
          {
            pcie = ''01:00.2'';
            driver = ''nouveau'';
            code = ''10de:1aec'';
          }
          {
            pcie = ''01:00.3'';
            driver = ''nouveau'';
            code = ''10de:1aed'';
          }
        ];
      };
    };
    ## ------------------------------------------------------------- ## 
    laptop = {
      hostname = "${hostname}-Laptop";
      vfio = false;
    };
    ## ------------------------------------------------------------- ##
    default_modules = [
      hosts.nixosModule {
        networking.stevenBlackHosts = {
          blockFakenews = true;
          blockGambling = true;
          blockPorn = false;
          blockSocial = true;
        };
      }
    ];
##########
# Config #
#######################################################################
  in
  {
    nixosConfigurations = {
      ${computer.hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        #### ----------------------------------------------------- ####
        modules = default_modules ++ [
          (import ./computer.nix {
            inherit computer;
            inherit username;
            inherit home-manager;
          })
        ];
      };
      ### --------------------------------------------------------- ###
      ${laptop.hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        #### ----------------------------------------------------- ####
        modules = default_modules ++ [
          (import ./computer.nix {
            computer = laptop;
            inherit username;
            inherit home-manager;
          })
          ##### ------------------------------------------------- #####
          nixos-hardware.nixosModules.asus-battery
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
        ];
      };
    };
  };
#######################################################################
}
