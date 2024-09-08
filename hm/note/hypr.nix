{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    bemenu
    brightnessctl
    grim
    slurp
    swww
    swappy
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = "eDP-1, 1920x1080, 0x0, 1";

      input = {
        kb_layout = "br";
        kb_variant = "abnt2";
        accel_profile = "flat";
        touchpad.disable_while_typing = 0;
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
        blur.enabled = 0;
      };

      animations.enabled = 0;

      misc = {
        force_default_wallpaper = "0";
        disable_splash_rendering = true;
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
        "$mainMod, D, exec, bemenu-run"
        "$mainMod, F, fullscreen,"
        "$mainMod, Print, exec, grim -l 0 - | swappy -f -"
        "$mainMod, Return, exec, kitty"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod, down, movefocus, d"
        "$mainMod, left, movefocus, l"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        ", Print, exec, grim -l 0 -g \"$(slurp -d -w 0)\" - | swappy -f -"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioLowerVolume, exec, pamixer -d 2 --allow-boost --set-limit 125"
        ", XF86AudioMicMute, exec, pamixer --source 1 -t"
        ", XF86AudioMute, exec, pamixer --toggle-mute --allow-boost --set-limit 125"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioRaiseVolume, exec, pamixer -i 2 --allow-boost --set-limit 125"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      ];

      exec-once = "${config.home.homeDirectory}/Cortex/hm/note/hypr_exec.sh";
    };
  };
}
