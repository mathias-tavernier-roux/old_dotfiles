{
###########
# Imports #
#######################################################################
  description = "Mathias-Tavernier-Roux dotfiles";
  # ----------------------------------------------------------------- #
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    ## ------------------------------------------------------------- ##
    hosts.url = "github:StevenBlack/hosts";
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

    applyAttrNames = builtins.mapAttrs (name: f: f name);

    computers = applyAttrNames {
      "${hostname}-Lap" = self: {
        hostname = "${hostname}-Lap";
        vms = [
          {
            name = "win11";
            os = "win11";
            ssdEmulation = true;
            isoName = "win11.iso";
            cores = 5;
            threads = 2;
            memory = 20;
            diskSize = 128;
            diskPath = "/home/${username}/VM/Disk";
            restartDm = false;
            videoVirtio = false;
            blacklistPcie = "1002:7480,1002:ab30";
            pcies = [
              {
                pcie = {
                  vmBus = "09";
                  bus = "03";
                  slot = "00";
                  function = "0";
                };
                driver = "amdgpu";
                blacklistDriver = false;
                blacklistPcie = true;
              }
              {
                pcie = {
                  vmBus = "09";
                  bus = "03";
                  slot = "00";
                  function = "1";
                };
                driver = "amdgpu";
                blacklistDriver = false;
                blacklistPcie = true;
              }
            ];
          }
        ];
        modules = [
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
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
    nixosConfigurations = (nixpkgs.lib.genAttrs (builtins.attrNames computers)
    (name: nixpkgs.lib.nixosSystem {
      inherit system;
      #### ----------------------------------------------------- ####
      modules = default_modules ++ computers."${name}".modules ++ [
        (import ./computer.nix {
          computer = computers."${name}";
          inherit username home-manager;
        })
      ];
    }));
  };
#######################################################################
}
