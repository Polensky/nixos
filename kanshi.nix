{
  pkgs,
  ...
}:{
  environment.systemPackages = with pkgs; [ 
    kanshi
  ];

  services.kanshi = {
    enable = true;
    package = pkgs.kanshi;
    systemdTarget = "hyprland-session.target";

    profiles = {
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            scale = 1.25;
            status = "enable";
          }
        ];
      };

      home_office = {
        outputs = [
          {
            criteria = "DP-2";
            status = "enable";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      };
    };
  };
}
