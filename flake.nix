{
  description = "Sigma dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    hosts.url = github:StevenBlack/hosts;
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixos-hardware
    , home-manager
    , hosts
    , ...
    } @inputs:
    let
      username = "gabriel";
      system = "x86_64-linux";

      default_modules = [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = import ./home;
          home-manager.extraSpecialArgs = { inherit username; };
        }

        hosts.nixosModule {
          networking.stevenBlackHosts = {
            blockFakenews = true;
            blockGambling = true;
            blockPorn = false;
            blockSocial = true;
          };
        }
      ];

    in
    {
      nixosConfigurations = {
        NixAtchu-VM = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = default_modules ++ [
            (import ./config { hostname = "NixAtchu-VM"; })
            ./hardware/NixAtchu-VM.nix

            home-manager.nixosModules.home-manager {
              home-manager.users.${username} = import ./home/fix.nix;
            }
          ];
        };

        NixAtchu-Fix = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = default_modules ++ [
            (import ./config { hostname = "NixAtchu-Fix"; })
            ./hardware/NixAtchu-Fix.nix
            ./config/fix.nix

            home-manager.nixosModules.home-manager {
              home-manager.users.${username} = import ./home/computer.nix;
            }

            home-manager.nixosModules.home-manager {
              home-manager.users.${username} = import ./home/fix.nix;
            }
          ];
        };

        NixAtchu-Test = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = default_modules ++ [
            (import ./config { hostname = "NixAtchu-Test"; })

            home-manager.nixosModules.home-manager {
              home-manager.users.${username} = import ./home/computer.nix;
            }
            home-manager.nixosModules.home-manager {
              home-manager.users.${username} = import ./home/fix.nix;
            }
          ];
        };

        NixAtchu-Portable = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = default_modules ++ [
            (import ./config { hostname = "NixAtchu-Portable"; })
            ./hardware/NixAtchu-Portable.nix
            ./config/portable.nix

            home-manager.nixosModules.home-manager {
              home-manager.users.${username} = import ./home/computer.nix;
            }
            home-manager.nixosModules.home-manager {
              home-manager.users.${username} = import ./home/portable.nix;
            }

            nixos-hardware.nixosModules.asus-battery
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-pc
            nixos-hardware.nixosModules.common-pc-ssd
          ];
        };
      };
    };
}
