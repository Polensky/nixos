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

  virtualisation.docker.enable = true;

  services.openssh.enable = true;

  services.pocketbase = {
    enable = true;
    openFirewall = true;
    user = "polen";
  };

  services.caddy = {
    enable = true;
    virtualHosts."mealie.polensky.me".extraConfig = ''
      reverse_proxy http://127.0.0.1:9000
    '';

    virtualHosts."jelly.polensky.me".extraConfig = ''
      reverse_proxy http://127.0.0.1:8096
    '';

    virtualHosts."pb.polensky.me".extraConfig = ''
      request_body {
        max_size 10MB
      }
      reverse_proxy 127.0.0.1:8090 {
        transport http {
          read_timeout 360s
        }
      }
    '';

    virtualHosts."demo.polensky.me".extraConfig = ''
      root * /srv/demo
      file_server
      try_files {path} /index.html
    '';
  };

  # observability
  services = {
    grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "0.0.0.0";
          http_port = 3000;
        };
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
              targets = ["127.0.0.1:9100"];
              labels = {
                instance = "server";
              };
            }
          ];
        }
      ];
    };
  };

  systemd.services.jellyfin = {
    environment = {
      DOTNET_SYSTEM_IO_DISABLEFILELOCKING = "1";
    };
  };

  # media
  services = {
    jellyfin = {
      inherit user;
      enable = true;
    };
    taskchampion-sync-server = {
      inherit user;
      enable = true;
      host = "0.0.0.0";
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

  # NFS Client - Mount storage from latoure
  fileSystems."/mnt/latoure-data" = {
    device = "latoure.local:/data";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
  };

  fileSystems."/mnt/latoure-data1" = {
    device = "latoure.local:/data1";
    fsType = "nfs";
    options = ["_netdev"];
  };

  networking = {
    hostName = "server";
    firewall.allowedTCPPorts = [
      80
      443
      9090 # prometheus
      3000 # grafana
      8096 # jellyfin
      9091 # transmission
      9191 # dispatcharr
      9000 # mealie
      8989 # sonarr
      10222 # taskchampion-sync-server
    ];
    firewall.allowedUDPPorts = [
      5353 # mDNS
    ];
  };

  time.timeZone = "America/Toronto";

  users.users."${user}" = {
    extraGroups = ["wheel" "transmission" "jellyfin" "polensky" "docker"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6O2MJqR+P/FwRyVSz1HWYhMtIwh16ozBU71Y2vf0oNDQ6DZ5T8Bvp5/4uSJgS8lOl3qYyNy0e0zJMIyfFVJnu89ycKBEdixA4HqWOUQGiyvn1C4s740jHolOzN1xNB24PDXFz0vHcVb+G5nU/xeKeaq0vrszrkK2zctqXshw94/x3ah0m3fr5CwM4S2RY/VODOdt11fllFEvN8HGE2mQTPn5sJzwtGW20npQ5iJ7ShugPbC4D1G2JU1R7MqkvWEpq9OFVb1prTpJM+i/lcqCn3lBv8XxpKKnD3q+48eeO1geosAsG/kgUWPDildbzcSfytgj7/TCTujx2ow4ZUfS4kWUrNaXM3M99SG61rFN7zLMAv14SOSsgegmX3q0ZAwOieUhCifqIqdfFr5QjEUP11ALofYRC6567X1YrEVXZFFnZSXMKGkBKpTxx0jaTTGnFSd6F49kDlI30cKJnVUgAK5nESissdEFn3UGRSFfxmjZkYvhY5l3LqtbO3kEutJU= polen@polen-xps"
    ];
  };
  environment.systemPackages = with pkgs; [
    neovim
    htop-vim
    wget
    xmrig
    tmux
    nfs-utils
    ranger
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
