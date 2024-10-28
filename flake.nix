{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		inputs.sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { nixpkgs, ... }@inputs:
    {
      nixosConfigurations =  {
				default = nixpkgs.lib.nixosSystem {
					specialArgs = {inherit inputs;};
					system = "x86_64-linux";
					modules = [ 
						./devices/xps13/configuration.nix
						./modules
					];
				};
				# pi = nixpkgs.lib.nixosSystem {
				# 	specialArgs = {inherit inputs;};
				# 	system = "aarch64-linux";
				# 	modules = [ 
				# 		./devices/pi/configuration.nix
				# 	];
				# };
			};
    };
}
