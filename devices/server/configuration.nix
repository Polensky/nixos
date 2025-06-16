{
  config,
  pkgs,
  ...
}: let
  user = "polen";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      devices = ["/dev/sda"];
    };
  };
  #boot.kernelModules = ["msr"];

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  services.openssh.enable = true;

  services = {
    jellyfin = {
      inherit user;
      enable = true;
    };
    transmission = {
      enable = true;
      settings = {
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist = "127.0.0.1,192.168.*.*";
      };
    };
    prometheus = {
      enable = true;
      exporters = {
        node.enable = true;
      };
      scrapeConfigs = [
        {
          job_name = "node-exporters-lan";
          static_configs = [
            {
              targets = ["192.168.1.241:9100"];
              labels = {
                instance = "pi";
              };
            }
            {
              targets = ["127.0.0.1:9100"];
              labels = {
                instance = "server";
              };
            }
          ];
        }
      ];
    };
    taskchampion-sync-server = {
      inherit user;
      enable = true;
    };
    mealie = {
      enable = true;
      settings = {
        ALLOW_SIGNUP = "false";
        PUID = 1000;
        PGID = 1000;
        TZ = "Canada/Eastern";
        MAX_WORKERS = 1;
        WEB_CONCURRENCY = 1;
        #BASE_URL = "https://mealie.polensky.me";
      };
    };
  };

  networking = {
    hostName = "server";
    firewall.allowedTCPPorts = [
      8096 # jellyfin
      9091 # transmission
      9090 # prometheus
      9000 # mealie
      10222 # taskchampion-sync-server
    ];
  };

  time.timeZone = "America/Toronto";

  users.users."${user}" = {
    extraGroups = ["wheel" "transmission" "jellyfin"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6O2MJqR+P/FwRyVSz1HWYhMtIwh16ozBU71Y2vf0oNDQ6DZ5T8Bvp5/4uSJgS8lOl3qYyNy0e0zJMIyfFVJnu89ycKBEdixA4HqWOUQGiyvn1C4s740jHolOzN1xNB24PDXFz0vHcVb+G5nU/xeKeaq0vrszrkK2zctqXshw94/x3ah0m3fr5CwM4S2RY/VODOdt11fllFEvN8HGE2mQTPn5sJzwtGW20npQ5iJ7ShugPbC4D1G2JU1R7MqkvWEpq9OFVb1prTpJM+i/lcqCn3lBv8XxpKKnD3q+48eeO1geosAsG/kgUWPDildbzcSfytgj7/TCTujx2ow4ZUfS4kWUrNaXM3M99SG61rFN7zLMAv14SOSsgegmX3q0ZAwOieUhCifqIqdfFr5QjEUP11ALofYRC6567X1YrEVXZFFnZSXMKGkBKpTxx0jaTTGnFSd6F49kDlI30cKJnVUgAK5nESissdEFn3UGRSFfxmjZkYvhY5l3LqtbO3kEutJU= polen@polen-xps"
    ];
  };
  environment.systemPackages = with pkgs; [
    neovim
    htop-vim
    wget
  ];

  programs.zsh.enable = true;

  environment.etc."issue".text = ''
    ▐▓█▀▀▀▀▀▀▀▀▀█▓▌░▄▄▄▄▄░
    ▐▓█░░▀░░▀▄░░█▓▌░█▄▄▄█░
    ▐▓█░░▄░░▄▀░░█▓▌░█▄▄▄█░
    ▐▓█▄▄▄▄▄▄▄▄▄█▓▌░█████░
    ░░░░▄▄███▄▄░░░░░█████░
    beep boop
  '';

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
