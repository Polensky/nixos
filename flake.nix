{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    vimix.url = "github:Polensky/vimix";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = {
    nixpkgs,
    nix-darwin,
    sops-nix,
    disko,
    ...
  } @ inputs: {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = [
          ./devices/xps13/configuration.nix
          ./modules
        ];
      };
      latoure = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = [
          ./devices/latoure/configuration.nix
          ./modules
        ];
      };
      server = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./devices/server/configuration.nix
          ./modules
        ];
      };
      pi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "aarch64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
          ./devices/pi/configuration.nix
          sops-nix.nixosModules.sops
          {
            sdImage.compressImage = false;
            nixpkgs.overlays = [
              (final: super: {
                makeModulesClosure = x:
                  super.makeModulesClosure (x // {allowMissing = true;});
              })
            ];
          }
        ];
      };
    };
    darwinConfigurations = {
      "mbp-m4" = nix-darwin.lib.darwinSystem {
        modules = [./devices/macbook/configuration.nix];
        specialArgs = {
          inherit inputs;
          system = "aarch64-darwin";
        };
      };
    };
  };
}
