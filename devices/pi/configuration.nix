{ inputs, config, pkgs, lib, ... }:

let
  user = "polen";
  password = "guest";
  SSID = "Cogeco-F710";
  SSIDpassword = "mypassword";
  interface = "wlan0";
  hostname = "pi";
in {
	# imports = [
	# 	inputs.sops-nix.nixosModules.ops
	# ];

	# sops.defaultSopsFile = ../../secrets/secrets.yaml;
	# sops.defaultSopsFormat = "yaml";
	# sops.age.keyFile = "/home/polen/.config/sops/age/keys.txt";

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
    hostName = hostname;
    wireless = {
      enable = true;
      networks."${SSID}".psk = SSIDpassword;
      interfaces = [ interface ];
    };
  };

  environment.systemPackages = with pkgs; [ nvim ];

  services.openssh.enable = true;

  users = {
    mutableUsers = false;
    users."${user}" = {
      isNormalUser = true;
      password = password;
      extraGroups = [ "wheel" ];
    };
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
