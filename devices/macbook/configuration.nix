{pkgs, inputs, system, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
		# terminal
		alacritty
    ranger
		(inputs.nixvim.packages.x86_64-darwin.default)

		# nix
    home-manager
    alejandra
		nix-output-monitor

		# work tool
		git
		terraform
		doppler
		ngrok
		awscli2
		pgcli

		# misc
    ollama
		sl
		newsboat

		(writeShellScriptBin "drs" ''
      darwin-rebuild switch --flake ~/.config/nix-darwin
    '')
  ];

	homebrew = {
		enable = true;
		onActivation = {
			autoUpdate = true;
			cleanup = "zap";
		};

		brews = [
			"emacs-plus@29"
		];

		casks = [
			# internet
			"qutebrowser"
			"firefox"
			"spotify"

			# work
			"slack"
			"tunnelblick"
			"dbeaver-community"
			"insomnia"

			# 3D
			"orcaslicer"
			"openscad"

			# Utilities
			"flameshot"
			"pika"
		];
	};

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
	programs.direnv.enable = true;

  services.yabai = {
    enable = true;
  };
  services.skhd.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;
}
