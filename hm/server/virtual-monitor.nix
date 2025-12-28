{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = "HEADLESS-2,1920x1080@60,auto,1";

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];

      exec-once = [
        "hyprctl output create headless"
      ];

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
        force_default_wallpaper = "0";
        disable_splash_rendering = true;
        vfr = false;
      };

      "$mainMod" = "ALT";

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
        "$mainMod, D, exec, ${pkgs.bemenu}/bin/bemenu-run"
        "$mainMod SHIFT, E, exit,"
        "$mainMod SHIFT, M, movetoworkspace, special:magic"
        "$mainMod SHIFT, Q, killactive,"
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
        "$mainMod, M, togglespecialworkspace, magic"
        "$mainMod, down, movefocus, d"
        "$mainMod, left, movefocus, l"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, return, exec, ${pkgs.ghostty}/bin/ghostty"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 0.02- -l 1.25"
        ", XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SOURCE@ toggle"
        ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
        ", XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop"
        ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 0.02+ -l 1.25"
      ];

    };
  };
}
