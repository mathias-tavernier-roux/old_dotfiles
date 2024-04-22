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
            uuid = "b7823b62-d7d3-45fc-9478-508f0a42a71d";
            uuidSetup = "69f40622-f83a-41a4-a464-567f4c6ef2b6";
            ssdEmulation = true;
            isoName = "win11";
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
          {
            name = "parrot";
            os = "parrot";
            uuid = "6e866206-4e3c-4daa-9407-2a443f5a374a";
            uuidSetup = "4259f5fb-0985-4505-b78a-82448eb34f27";
            ssdEmulation = true;
            isoName = "parrot";
            cores = 5;
            threads = 2;
            memory = 20;
            diskSize = 60;
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
