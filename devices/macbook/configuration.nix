{
  pkgs,
  inputs,
  system,
  config,
  ...
}: let
  my-emacs = pkgs.emacsNativeComp;
in {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # terminal
    ranger
    (inputs.vimix.packages.${system}.default)

    # nix
    home-manager
    nix-output-monitor

    # work tool
    doppler
    docker
    colima
    git
    gnupg
    (pass.withExtensions (exts: [exts.pass-otp]))

    # emacs
    my-emacs
    fd
    ripgrep

    (writeShellScriptBin "drs" ''
      sudo darwin-rebuild switch --flake ~/.config/nixos
    '')
  ];

  system.primaryUser = "charles";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    brews = [
      # doom emacs
      "fontconfig"
    ];

    casks = [
      # internet
      "spotify"
      "brave-browser"
      "qutebrowser"
      "stremio"

      # work
      "slack"
      "tunnelblick"
      "dbeaver-community"
      "claude"

      # doom emacs
      "font-symbols-only-nerd-font"
    ];
  };

  nix = {
    # Necessary for using flakes on this system.
    settings.experimental-features = "nix-command flakes";
    extraOptions = ''
      extra-platforms = x86_64-darwin aarm64-darwin
    '';
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 15d";
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.direnv.enable = true;
  programs.gnupg.agent.enable = true;

  services.yabai = {
    enable = true;
  };
  services.skhd.enable = true;

  services.emacs = {
    enable = true;
    package = my-emacs;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  ids.gids.nixbld = 350;

  system.defaults.dock = {
    autohide = true;
    persistent-apps = [];
    show-recents = false;
    static-only = true;
    tilesize = 32;
  };

  system.defaults.menuExtraClock = {
    Show24Hour = true;
  };

  launchd.user.agents.remap-keys = {
    serviceConfig = {
      ProgramArguments = [
        "/usr/bin/hidutil"
        "property"
        "--set"
        ''          {
                    "UserKeyMapping":[
                    {"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E7}
                    ]
                  }''
      ];
      RunAtLoad = true;
    };
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;
}
