build-pi-image:
	nix build .#nixosConfigurations.pi.config.system.build.sdImage --print-out-paths

# Doest work yet
rebuild-pi:
	nixos-rebuild switch --flake .#pi --target-host pi --build-host server --use-remote-sudo

deploy-server:
	nixos-rebuild switch --flake .#server --target-host server --build-host server --use-remote-sudo
