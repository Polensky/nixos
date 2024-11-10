{ inputs, config, pkgs, lib, ... }:

let
  user = "polen";
  hostname = "pi";
in {
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi3;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

	#sops.defaultSopsFile = ../../secrets/secrets.yaml;
	#sops.defaultSopsFormat = "yaml";
	#sops.age.keyFile = "/home/polen/.config/sops/age/keys.txt";
	#sops.secrets.pi_user_pass.neededForUsers = true;

  networking = {
		networkmanager.enable = true;
		wireless.enable = false;
    hostName = hostname;
		firewall.allowedTCPPorts = [ 80 443 ];
  };

	services.caddy = {
		enable = true;
		virtualHosts."mealie.polensky.me".extraConfig = ''
			reverse_proxy http://localhost:9925
		'';
	};

	nix.settings.trusted-users = [ user ];

  environment.systemPackages = with pkgs; [ 
		htop-vim
		neovim 
		tmux 
		curl
		wget
		git
		ranger
	];

  services.openssh.enable = true;

	virtualisation.docker.enable = true;

  users = {
    mutableUsers = false;
    users."${user}" = {
      isNormalUser = true;
      #hashedPasswordFile = config.sops.secrets.pi_user_pass.path;
      extraGroups = [ "wheel" "docker" ];
    };
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
