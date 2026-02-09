{ inputs, config, pkgs, ... }:

{
  imports = [ inputs.nix-openclaw.homeManagerModules.openclaw ];

  home.username = "luna";
  home.homeDirectory = "/var/lib/luna";
  home.stateVersion = "25.05";

  programs.openclaw = {
    enable = true;
    documents = ./luna-documents;

    config = {
      # Use local Ollama - auto-detected at 127.0.0.1:11434
      agents.defaults.model = {
        primary = "ollama/mistral:7b";
        fallbacks = [ "ollama/phi3.5:3.8b" ];
      };

      gateway = {
        mode = "local";
        auth = { tokenFile = "/run/secrets/luna-gateway-token"; };
      };

      channels.telegram = {
        tokenFile = "/run/secrets/luna-telegram-token";
        allowFrom = [
          1268580775
        ];
        groups = { "*" = { requireMention = true; }; };
      };
    };

    # Plugins useful for homelab Q&A
    bundledPlugins = {
      summarize.enable = true; # Summarize docs/web pages
      oracle.enable = true; # Web search
    };
  };

  programs.home-manager.enable = true;
}
