{ inputs, config, pkgs, lib, ... }:

let
  user = "polen";
  password = "password";
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

  networking = {
		networkmanager.enable = true;
		wireless.enable = false;
    hostName = hostname;
  };

  environment.systemPackages = with pkgs; [ 
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
      password = password;
      extraGroups = [ "wheel" "docker" ];
    };
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
