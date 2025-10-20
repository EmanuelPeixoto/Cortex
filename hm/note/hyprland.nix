{ config, pkgs, ... }:
let
  hyprland-exec = import ./scripts/hyprland-exec.nix { inherit config pkgs; };
  print = import ./scripts/print.nix { inherit pkgs; };
  print-selection = import ./scripts/print-selection.nix { inherit pkgs; };
  wallpaper = import ./scripts/wallpaper.nix { inherit config pkgs; };
  monitor-mode = import ./scripts/monitor-mode.nix { inherit pkgs; };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = "eDP-1, 1920x1080, 0x0, 1";

      input = {
        accel_profile = "flat";
        kb_layout = "br";
        kb_variant = "abnt2";
        touchpad.disable_while_typing = 0;
      };

      general = {
        border_size = 2;
        gaps_in = 5;
        gaps_out = 10;
      };

      decoration = {
        shadow.enabled = 0;
        blur.enabled = 0;
      };

      animations.enabled = 0;

      misc = {
        disable_splash_rendering = true;
        force_default_wallpaper = "0";
      };

      windowrulev2 = [
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
      ];

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, P, exec, ${monitor-mode}/bin/monitor-mode"
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
        "$mainMod SHIFT, M, movetoworkspace, special:magic"
        "$mainMod SHIFT, Q, killactive,"
        "$mainMod SHIFT, S, exec, ${print-selection}/bin/print-selection"
        "$mainMod SHIFT, down, movewindow, d"
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, space, togglefloating,"
        "$mainMod SHIFT, up, movewindow, u"
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
        "$mainMod, D, global, shell:runner"
        "$mainMod, F, fullscreen,"
        "$mainMod, H, exec, ${pkgs.systemd}/bin/systemctl hibernate"
        "$mainMod, L, exec, ${pkgs.hyprlock}/bin/hyprlock --immediate"
        "$mainMod, M, togglespecialworkspace, magic"
        "$mainMod, P, exec, pkill clipse || ${pkgs.ghostty}/bin/ghostty --title='clipse' -e ${pkgs.clipse}/bin/clipse"
        "$mainMod, S, exec, ${pkgs.systemd}/bin/systemctl hybrid-sleep"
        "$mainMod, down, movefocus, d"
        "$mainMod, left, movefocus, l"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, return, exec, ${pkgs.ghostty}/bin/ghostty"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        ", XF86Calculator, exec, ${pkgs.qalculate-qt}/bin/qalculate-qt"
        ", XF86Favorites, exec, ${wallpaper}/bin/wallpaper"
        ", XF86SelectiveScreenshot, exec, ${print-selection}/bin/print-selection"
        ", print, exec, ${print}/bin/print"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        "$mainMod, XF86MonBrightnessDown, dpms, off"
        "$mainMod, XF86MonBrightnessUp, dpms, on"
        ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 0.02- -l 1.25"
        ", XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SOURCE@ toggle"
        ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
        ", XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop"
        ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 0.02+ -l 1.25"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+"
      ];

      exec-once = "${hyprland-exec}/bin/hyprland-exec";
    };
  };
}
