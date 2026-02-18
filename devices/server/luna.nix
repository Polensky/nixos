{ inputs, config, pkgs, ... }:

{
  imports = [ inputs.nix-openclaw.homeManagerModules.openclaw ];

  home.username = "luna";
  home.homeDirectory = "/var/lib/luna";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [ xmlstarlet ];

  programs.openclaw = {
    enable = true;

    config = {
      models = {
        providers = {
          ollama = {
            baseUrl = "http://127.0.0.1:11434/v1";
            apiKey = "ollama-local";
            api = "openai-completions";
            models = [ ];
          };
        };
      };

      agents = {
        defaults = {
          model = { primary = "github-copilot/gpt-5-mini"; };
          workspace = "/var/lib/luna/.openclaw/workspace";
          maxConcurrent = 4;
          subagents = { maxConcurrent = 8; };
          models = { "github-copilot/gpt-5-mini" = { }; };
        };
      };

      commands = {
        native = "auto";
        nativeSkills = "auto";
      };

      channels = {
        telegram = {
          dmPolicy = "pairing";
          tokenFile = "/run/secrets/luna_telegram_token";
          groups = { "*" = { requireMention = true; }; };
          allowFrom = [ 1268580775 ];
          groupPolicy = "allowlist";
          streamMode = "partial";
        };
      };

      gateway = {
        mode = "local";
        auth = {
          token =
            "14db7eaede5f363bce5f5efd23baea45fd8c7984fd3d9234d9b98e1d52c88db7";
          mode = "token";
        };
        port = 18789;
        bind = "loopback";
        tailscale = {
          mode = "off";
          resetOnExit = false;
        };
      };

      plugins = { entries = { telegram = { enabled = true; }; }; };

      messages = { ackReactionScope = "group-mentions"; };

      auth = {
        profiles = {
          "github-copilot:github" = {
            provider = "github-copilot";
            mode = "token";
          };
        };
      };

      hooks = {
        internal = {
          enabled = true;
          entries = {
            "boot-md" = { enabled = true; };
            "command-logger" = { enabled = true; };
            "session-memory" = { enabled = true; };
          };
        };
      };

      wizard = {
        lastRunAt = "2026-02-10T18:36:29.457Z";
        lastRunVersion = "2026.2.6-3";
        lastRunCommand = "onboard";
        lastRunMode = "local";
      };

      meta = {
        lastTouchedVersion = "2026.2.6-3";
        lastTouchedAt = "2026-02-10T18:36:29.472Z";
      };
    };

    # Plugins useful for homelab Q&A
    bundledPlugins = {
      summarize.enable = true; # Summarize docs/web pages
      oracle.enable = false; # Web search
    };
  };

  programs.home-manager.enable = true;
}
