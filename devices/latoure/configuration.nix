# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  #hardware.opengl = {
  #	enable = true;
  #	driSupport32Bit = true;
  #};

  #services.xserver.videoDrivers = ["nvidia"];
  #hardware.nvidia.modesetting.enable = true;
  #hardware.nvidia.open = true;

  networking.hostName = "latoure"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  #nix.settings.trusted-users = [ "polen" "polensky" ];
  #nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;
  #boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable mDNS for .local hostname resolution
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  services = {
    sonarr = {
      enable = true;
      openFirewall = true;
			dataDir = "/data1/sonarr/.config/NzbDrone";
    };
    prowlarr = {
      enable = true;
      openFirewall = true;
    };
    transmission = {
		  user = "sonarr";
      enable = true;
      openFirewall = true;
      settings = {
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist = "127.0.0.1,192.168.*.*";
      };
    };
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.polensky = {
    isNormalUser = true;
    description = "polensky";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    htop-vim
    ranger
    neovim
    wget
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # NFS Server - Export storage to other machines
  services.nfs.server = {
    enable = true;
    exports = ''
      /data    192.168.1.0/24(rw,sync,no_subtree_check,fsid=0,all_squash,anonuid=1000,anongid=100)
      /data1   192.168.1.0/24(rw,sync,no_subtree_check,fsid=1,all_squash,anonuid=1000,anongid=100)
    '';
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
		allowedTCPPorts = [
			2049 # NFS
			111 # RPC
			20048 # NFS mountd
		];
		allowedUDPPorts = [
			2049 # NFS
			111 # RPC
			20048 # NFS mountd
			5353 # mDNS
		];
	};
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
