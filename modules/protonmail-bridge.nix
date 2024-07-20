{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.protonmail-bridge;
  pm-bridge-script = pkgs.writeShellApplication {
    name = "pm-bridge";
    runtimeInputs = with pkgs; [ protonmail-bridge tmux ];
    text = ''
      case "$1" in
        start)
          tmux new-session -s pm-bridge -n pm-bridge -d protonmail-bridge --log-level ${cfg.logLevel} --cli
          ;;
        stop)
          tmux kill-session -t pm-bridge
          ;;
        status)
          if tmux ls | grep -q pm-bridge ; then
            echo "Protonmail-bridge is up"
          else
            echo "Protonmail-bridge is down"
          fi
          ;;
        attach)
          tmux attach -t pm-bridge
          ;;
        *)
          echo "Unknown command: $1"
          exit 1
          ;;
      esac
    '';
  };
in
{
  ##### interface
  options = {
    programs.protonmail-bridge = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the Bridge.";
      };

      logLevel = mkOption {
        type = types.enum [ "panic" "fatal" "error" "warn" "info" "debug" "debug-client" "debug-server" ];
        default = "info";
        description = "The log level";
      };
    };
  };

  ##### implementation
  config = mkIf cfg.enable {
    home.packages = [ pm-bridge-script ];
  };
}
