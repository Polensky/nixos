build-pi-image:
	nix build .#nixosConfigurations.pi.config.system.build.sdImage --print-out-paths

# Doest work yet
rebuild-pi:
	nixos-rebuild switch --flake .#pi --target-host polen@192.168.1.241 --use-remote-sudo
