{ lib, config, pkgs, ... }:
{
    home.packages = with pkgs; [
      alacritty
      bemenu
      grim
      hyprlock
      slurp
      swww
      wl-clipboard
    ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = "LVDS-1, 1366x768, 0x0, 1";
      env = "XCURSOR_SIZE, 24";

      input = {
        kb_layout = "br";
        kb_variant = "abnt2";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        accel_profile = "flat";
        follow_mouse = 1;
        touchpad = {
          disable_while_typing = 0;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(d60202ff)";
        "col.inactive_border" = "rgba(828282ff)";
      };

      decoration = {
        drop_shadow = 0;
        blur = {
          enabled = 0;
        };
      };
      animations = {
        enabled = 0;
      };

      misc = {
        force_default_wallpaper = "0";
      };

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, E, exit,"
        "$mainMod SHIFT, Q, killactive,"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod SHIFT, space, togglefloating,"
        "$mainMod, 0, workspace, 10"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, Return, exec, alacritty"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod, D, exec, bemenu-run"
        "$mainMod, F, fullscreen,"
        "$mainMod, down, movefocus, d"
        "$mainMod, left, movefocus, l"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        ", Print, exec, grim -g \"$(slurp -d)\" - | wl-copy -t image/png"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      bindel = [
        ", XF86AudioLowerVolume, exec, pamixer -d 2 --allow-boost --set-limit 125"
        ", XF86AudioRaiseVolume, exec, pamixer -i 2 --allow-boost --set-limit 125"
        ", XF86AudioMute, exec, pamixer --toggle-mute --allow-boost --set-limit 125"
        "CTRL, XF86AudioLowerVolume, exec, playerctl previous"
        "CTRL, XF86AudioRaiseVolume, exec, playerctl next"
        "CTRL, XF86AudioMute, exec, playerctl play-pause"
      ];
      exec-once = "eww open bar && swww img ~/NixOS/home-manager/Wallpaper.gif";
    };
  };
}