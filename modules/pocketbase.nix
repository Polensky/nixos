{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.pocketbase;
in {
  options.services.pocketbase = {
    enable = lib.mkEnableOption "PocketBase backend";

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/pocketbase";
      description = "Working directory containing the PocketBase binary and data.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open ports in the firewall for the PocketBase web interface
      '';
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8090;
      description = "The port number for the PocketBase.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = "User to run the PocketBase service as.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = "Group to run the PocketBase service as.";
    };

    logFile = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/pocketbase/std.log";
      description = "Log file used for both stdout and stderr.";
    };

    package = lib.mkPackageOption pkgs "pocketbase" {};
  };

  config = lib.mkIf cfg.enable {
    # Optional: ensure the directory exists with proper ownership
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0700 ${cfg.user} ${cfg.group} -"
    ];

    systemd.services.pocketbase = {
      description = "PocketBase";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        LimitNOFILE = 4096;
        Restart = "always";
        RestartSec = 5;
        WorkingDirectory = cfg.dataDir;

        ExecStart = ''
          ${lib.getExe cfg.package} serve --dir ${cfg.dataDir}/pb_data --http=0.0.0.0:${toString cfg.port}
        '';

        # Switch to systemd stdout/stderr logging by default
        # and optionally use append: style if you want exactly your example
        StandardOutput = "append:${cfg.logFile}";
        StandardError = "append:${cfg.logFile}";
      };
    };
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [cfg.port];
    };
  };
}
