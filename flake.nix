{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }@inputs:
    {
      nixosConfigurations =  {
				default = nixpkgs.lib.nixosSystem {
						specialArgs = {inherit inputs;};
						system = "x86_64-linux";
						modules = [ 
							./configuration.nix
						];
					};
				};
				iso_cath = nixpkgs.lib.nixosSystem {
						specialArgs = {inherit inputs;};
						modules = [ 
							./iso/sl1_cath.nix
						];
				};
    };
}
