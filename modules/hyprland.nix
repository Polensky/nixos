{ config, lib, pkgs, ... }:

with lib;
{
  options = {
    programs.hyprland = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf config.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      setting = {
        monitor = [
          "eDP1,preferred,auto,1.25"
          ",preferred,auto,auto"
        ];

        env = "XCURSOR_SIZE,24";

        input = {
          kb_layout = "us,ca";
          kb_variant = "";
          kb_model = "";
          kb_options = "grp:win_space_toggle";
          kb_rules = "";

          follow_mouse = 1;

          touchpad = {
            natural_scroll = "no";
          };

          sensitivity = 0;
        };

        general = {
          gaps_in = 3;
          gaps_out = 5;
          border_size = 1;
          col.active_border = "rgba(a7c080ee) rgba(7fbbb3ee) 45deg";
          col.inactive_border = "rgba(595959aa)";

          layout = "master";

          allow_tearing = false;
        };

        master = {
          orientation = "left";
          new_is_master = "false";
        };

        decoration = {
          rounding = 8;

          blur = {
              enabled = true;
              size = 3;
              passes = 1;
          };

          drop_shadow = "yes";
          shadow_range = 4;
          shadow_render_power = 3;
          col.shadow = "rgba(1a1a1aee)";
        };


        animations = {
          enabled = "yes";

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        gestures = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = "off";
        };

        misc = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            force_default_wallpaper = 0; # Set to 0 to disable the anime mascot wallpapers
        };

        xwayland = {
          force_zero_scaling = true;
        };


        "$mainMod" = "SUPER";

        bind = [
          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          "$mainMod, RETURN, exec, alacritty"
          "$mainMod, Q, killactive, "
          "$mainMod, M, exit, "
          "$mainMod, E, exec, dolphin"
          "$mainMod, V, togglefloating, "
          "$mainMod, F, fullscreen"
          "$mainMod, R, exec, ~/.config/hypr/green_bemenu.sh"
          "$mainMod, P, pseudo, # dwindle"
          "CONTROL, space, exec, makoctl dismiss --all"
          #bind = $mainMod, J, togglesplit, # dwindle

          # Brightness control
          ",XF86MonBrightnessUp, exec, brightnessctl set +10%"
          ",XF86MonBrightnessDown, exec, brightnessctl set 10%-"

          # Volume and Media control
          ", XF86AudioRaiseVolume, exec, pamixer -i 5 "
          ", XF86AudioLowerVolume, exec, pamixer -d 5 "
          ", XF86AudioMicMute, exec, pamixer --default-source -m"
          ", XF86AudioMute, exec, pamixer -t"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"

          "$mainMod SHIFT, RETURN, layoutmsg, swapwithmaster"

          # Move focus with mainMod + arrow keys
          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Example special workspace (scratchpad)
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow,"
          "$mainMod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
