build-pi-image:
	nix build .#nixosConfigurations.pi.config.system.build.sdImage --print-out-paths

# Doest work yet
rebuild-pi:
	NIX_SSHOPTS="-o IdentitiesOnly=yes -i ~/.ssh/id_rsa" nixos-rebuild switch --flake .#pi --target-host pi --build-host server --use-remote-sudo

deploy-server:
	nixos-rebuild switch --flake .#server --target-host server --build-host server --use-remote-sudo --ask-sudo-password
