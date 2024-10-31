build-pi-image:
	nix build .#nixosConfigurations.pi.config.system.build.sdImage --print-out-paths
