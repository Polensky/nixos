{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "polen";
  home.homeDirectory = "/home/polen";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # hello
    brave
    firefox
    qutebrowser
    discord
    signal-desktop
    element-desktop
    emacs29-pgtk
    zathura
    vimiv-qt
    pcmanfm

    prusa-slicer
    openscad
    freecad
    blender

    foot
    alacritty
    ranger
    neovim
    ripgrep
    tmux
    fzf
    fd
    brightnessctl
    unzip

    passExtensions.pass-otp
    (pass-wayland.withExtensions (ext: with ext; [ pass-otp ]))

    pamixer
    playerctl

    go
    gopls
    gotools
    gnumake

    # Email
    neomutt
    mutt-wizard
    isync
    msmtp
    lynx
    notmuch
    abook

    font-awesome
    (nerdfonts.override { fonts = [ "FiraCode" ]; })

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  fonts.fontconfig.enable = true;

  programs.protonmail-bridge.enable = true;

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
      "text/html" = ["brave-browser.desktop"];
      "image/*" = ["vimiv.desktop"];
    };
    defaultApplications = {
      "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
      "text/html" = ["brave-browser.desktop"];
      "image/*" = ["vimiv.desktop"];
    };
  };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/polen/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = { EDITOR = "nvim"; };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      v = "nvim";
      nrs = "sudo nixos-rebuild switch --flake ~/.config/nixos#default";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      battery = {
        display = [ 
          { threshold = 15; style = "green"; }
        ];
      };
    };
  };

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 46.3;
    longitude = -72.65;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
