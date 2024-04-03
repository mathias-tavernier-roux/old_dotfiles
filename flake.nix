{
###########
# Imports #
#######################################################################
  description = "Mathias-Tavernier-Roux dotfiles";
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
    username = "mathias";
    system = "x86_64-linux";
    hostname = "Mathias";

    computer = {
      hostname = "${hostname}-Fix";
      vm = {
        cores = 4;
        threads = 2;
        memory = 12;
        diskSize = 512;
        diskPath = "/var/lib/libvirt/images";
        restartDm = false;
        videoVirtio = false;
        pcies = [
          {
            pcie = {
              vmBus = "09";
              bus = "01";
              slot = "00";
              function = "0";
            };
            driver = ''nouveau'';
            blacklistDriver = true;
          }
          {
            pcie = {
              vmBus = "09";
              bus = "01";
              slot = "00";
              function = "1";
            };
            driver = ''nouveau'';
            blacklistDriver = true;
          }
          {
            pcie = {
              vmBus = "09";
              bus = "01";
              slot = "00";
              function = "2";
            };
            driver = ''nouveau'';
            blacklistDriver = true;
          }
          {
            pcie = {
              vmBus = "09";
              bus = "01";
              slot = "00";
              function = "3";
            };
            driver = ''nouveau'';
            blacklistDriver = true;
          }
        ];
      };
    };
    ## ------------------------------------------------------------- ## 
    laptop = {
      hostname = "${hostname}-Lap";
      vm = {
        cores = 5;
        threads = 2;
        memory = 20;
        diskSize = 128;
        diskPath = "/home/${username}/VM/Disk";
        restartDm = false;
        videoVirtio = false;
        pcies = [
          {
            pcie = {
              vmBus = "09";
              bus = "03";
              slot = "00";
              function = "0";
            };
            driver = ''amdgpu'';
            blacklistDriver = false;
          }
          {
            pcie = {
              vmBus = "09";
              bus = "03";
              slot = "00";
              function = "1";
            };
            driver = ''amdgpu'';
            blacklistDriver = false;
          }
        ];
      };
    };
    ## ------------------------------------------------------------- ##
    default_modules = [
      hosts.nixosModule {
        networking.stevenBlackHosts = {
          blockFakenews = true;
          blockGambling = true;
          blockPorn = true;
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
            inherit computer username home-manager;
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
            inherit username home-manager;
          })
          ##### ------------------------------------------------- #####
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
        ];
      };
    };
  };
#######################################################################
}
