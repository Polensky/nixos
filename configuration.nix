# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };

	services.displayManager.sddm = {
		enable = true;
		theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
	};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.polen = {
    isNormalUser = true;
    description = "polen";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
  #users.defaultUserShell = pkgs.zsh

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    neovim
    wget
    htop-vim
    ranger
    git
    home-manager
    pinentry-curses

    waybar
    mako
    swww
    wdisplays
    libnotify
    bemenu
    pavucontrol
    networkmanagerapplet
    wl-clipboard
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
  ];

  programs.zsh.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.gvfs.enable = true;

  # to make pass work
  services.passSecretService.enable = true;
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = "gnome3";
    enableSSHSupport = true;
  };
  programs.seahorse.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  environment.sessionVariables = { 
    NIXOS_OZONE_WL = "1"; 
    QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
  };

  # List services that you want to enable:
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
