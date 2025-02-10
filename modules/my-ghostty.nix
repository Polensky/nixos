{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.my-ghostty;
in {
  ##### interface
  options = {
    programs.my-ghostty = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable ghostty.";
      };
		};
  };

  ##### implementation
  config = mkIf cfg.enable {
    programs.ghostty = {
			enable = true;
			settings = {
				theme = "everforest-dark";
				font-family = "FiraCode";
				background-opacity = 0.80;
				resize-overlay = "never";
			};

			themes = {
				everforest-dark = {
					background = "2D353B";
					foreground = "D3C6AA";
					cursor-color = "56635F";
					selection-background = "543A48";
					selection-foreground = "D3C6AA";

					palette = [
						"0=#232A2E"
						"1=#E67E80"
						"2=#A7C080"
						"3=#DBBC7F"
						"4=#7FBBB3"
						"5=#D699B6"
						"6=#83C092"
						"7=#4F585E"
						"8=#3D484D"
						"9=#543A48"
						"10=#425047"
						"11=#4D4C43"
						"12=#3A515D"
						"13=#514045"
						"14=#83C092"
						"15=#D3C6AA"
					];
				};

				everforest-light = {
					background = "EFEBD4";
					foreground = "5C6A72";
					cursor-color = "BDC3AF";
					selection-background = "EAEDC8";
					selection-foreground = "5C6A72";

					palette = [
						"0=#EFEBD4"
						"1=#F85552"
						"2=#8DA101"
						"3=#DFA000"
						"4=#8DA101"
						"5=#3A94C5"
						"6=#35A77C"
						"7=#DF69BA"
						"8=#FDF6E3"
						"9=#EAEDC8"
						"10=#F0F1D2"
						"11=#FAEDCD"
						"12=#E9F0E9"
						"13=#FBE3DA"
						"14=#35A77C"
						"15=#5C6A72"
					];
				};
			};
		};
  };
}
