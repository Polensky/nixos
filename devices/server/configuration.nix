{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  services.openssh.enable = true;

  boot.kernelModules = ["msr"];

  networking.hostName = "server";

  time.timeZone = "America/Toronto";

  users.users.polen = {
    isNormalUser = true;
    description = "polen";
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6O2MJqR+P/FwRyVSz1HWYhMtIwh16ozBU71Y2vf0oNDQ6DZ5T8Bvp5/4uSJgS8lOl3qYyNy0e0zJMIyfFVJnu89ycKBEdixA4HqWOUQGiyvn1C4s740jHolOzN1xNB24PDXFz0vHcVb+G5nU/xeKeaq0vrszrkK2zctqXshw94/x3ah0m3fr5CwM4S2RY/VODOdt11fllFEvN8HGE2mQTPn5sJzwtGW20npQ5iJ7ShugPbC4D1G2JU1R7MqkvWEpq9OFVb1prTpJM+i/lcqCn3lBv8XxpKKnD3q+48eeO1geosAsG/kgUWPDildbzcSfytgj7/TCTujx2ow4ZUfS4kWUrNaXM3M99SG61rFN7zLMAv14SOSsgegmX3q0ZAwOieUhCifqIqdfFr5QjEUP11ALofYRC6567X1YrEVXZFFnZSXMKGkBKpTxx0jaTTGnFSd6F49kDlI30cKJnVUgAK5nESissdEFn3UGRSFfxmjZkYvhY5l3LqtbO3kEutJU= polen@polen-xps"
  ];

  environment.systemPackages = with pkgs; [
    neovim
    htop-vim
  ];

  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    settings.trusted-users = ["polen"];
    # settings.extra-platforms = config.boot.binfmt.emulatedSystems;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
