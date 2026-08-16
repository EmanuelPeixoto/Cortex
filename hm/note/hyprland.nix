{ config, lib, pkgs, ... }:
let
  monitor-mode = import ./scripts/monitor-mode.nix { inherit pkgs; };

  # helpers — retornam { _args = [key, lua]; }
  mkBind = key: lua: { _args = [ key (lib.generators.mkLuaInline lua) ]; };
  mkCmd = key: cmd: mkBind key "hl.dsp.exec_cmd(\"${cmd}\")";

  noct = "${pkgs.noctalia}/bin/noctalia msg";

  direction = [ "up" "down" "left" "right" ];
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    settings = {
      monitor = {
        output = "eDP-1"; mode = "preferred"; position = "0x0"; scale = 1;
      };

      config = {
        input = {
          accel_profile = "flat";
          kb_layout = "br";
          kb_variant = "abnt2";
          "touchpad.disable_while_typing" = 0;
        };

        general = {
          border_size = 2;
          gaps_in = 5;
          gaps_out = 10;
          col = let c = config.lib.stylix.colors; in {
            active_border = {
              colors = [ "rgba(${c.base0D}ee)" "rgba(${c.base0E}ee)" ];
              angle = 45;
            };
            inactive_border = "rgba(${c.base03}aa)";
          };
        };

        decoration = {
          rounding = 8;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(${config.lib.stylix.colors.base00}ee)";
          };
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
        };

        misc = {
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
        };

        "animations.enabled" = 0;
      };

      window_rule = [{
        name = "pip-follow";
        match = { title = "[Pp]icture.*[Pp]icture"; };
        float = true;
        pin = true;
      } {
        match = { class = "^(com\.gabm\.satty|satty|ksnip)$"; };
        float = true;
      } {
        match = { class = "dev.noctalia.Noctalia"; };
        float = true;
        size = [ 1080 920 ];
      }];

      layer_rule = {
        name = "noctalia";
        match = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$"; };
        no_anim = true;
        "ignore_alpha" = 0.5;
        blur = true;
        "blur_popups" = true;
      };

      bind = [
        # === workspace: mover janela (SUPER + SHIFT + 0..9) ===
        ] ++ map (n: mkBind
          "SUPER + SHIFT + ${toString n}"
          ''hl.dsp.window.move({ workspace = "${toString (if n == 0 then 10 else n)}" })''
        ) (lib.range 0 9) ++ [

        # === sair / matar / special ===
        (mkBind "SUPER + SHIFT + E" "hl.dsp.exit()")
        (mkBind "SUPER + SHIFT + M" ''hl.dsp.window.move({ workspace = "special:magic" })'')
        (mkBind "SUPER + SHIFT + Q" "hl.dsp.window.close()")

        # === mover janela (direcional) ===
        ] ++ map (d: mkBind
          "SUPER + SHIFT + ${d}"
          ''hl.dsp.window.move({ direction = "${d}" })''
        ) direction ++ [

        # === toggle floating ===
        (mkBind "SUPER + SHIFT + space" ''hl.dsp.window.float({ action = "toggle" })'')

        # === workspace: trocar (SUPER + 0..9) ===
        ] ++ map (n: mkBind
          "SUPER + ${toString n}"
          ''hl.dsp.focus({ workspace = "${toString (if n == 0 then 10 else n)}" })''
        ) (lib.range 0 9) ++ [

        # === movefocus (direcional) ===
        ] ++ map (d: mkBind
          "SUPER + ${d}"
          ''hl.dsp.focus({ direction = "${d}" })''
        ) direction ++ [

        # === mouse ===
        (mkBind "SUPER + mouse_down" ''hl.dsp.focus({ workspace = "e+1" })'')
        (mkBind "SUPER + mouse_up"   ''hl.dsp.focus({ workspace = "e-1" })'')
        { _args = [ "SUPER + mouse:272" (lib.generators.mkLuaInline "hl.dsp.window.drag()")    { mouse = true; } ]; }
        { _args = [ "SUPER + mouse:273" (lib.generators.mkLuaInline "hl.dsp.window.resize()")  { mouse = true; } ]; }

        # === apps ===
        (mkCmd  "SUPER + P"         "${monitor-mode}/bin/monitor-mode")
        (mkCmd  "SUPER + SHIFT + S" "${noct} screenshot-region")
        (mkCmd  "SUPER + C"         "${noct} panel-toggle clipboard")
        (mkBind "SUPER + F"         "hl.dsp.window.fullscreen()")
        (mkCmd  "SUPER + H"         "${pkgs.systemd}/bin/systemctl hibernate")
        (mkBind "SUPER + M"         ''hl.dsp.workspace.toggle_special("magic")'')
        (mkCmd  "SUPER + S"         "${pkgs.systemd}/bin/systemctl hybrid-sleep")
        (mkCmd  "SUPER + return"    "${pkgs.ghostty}/bin/ghostty")

        # === noctalia ===
        (mkCmd  "SUPER + D"        "${noct} panel-toggle launcher")
        (mkCmd  "SUPER + TAB"      "${noct} window-switcher")
        (mkCmd  "SUPER + L"        "${noct} session lock")
        (mkCmd  "SUPER + X"        "${noct} panel-toggle control-center")
        (mkCmd  "SUPER + comma"     "${noct} settings-toggle")
        (mkCmd  "SUPER + ALT + C"  "${noct} panel-toggle session")
        (mkCmd  "SUPER + SHIFT + W" "${noct} panel-toggle wallpaper")
        (mkCmd  "print"            "${noct} screenshot-fullscreen")

        # === XF86 / print ===
        (mkCmd  "XF86Calculator" "${pkgs.qalculate-qt}/bin/qalculate-qt")
        (mkCmd  "XF86Favorites"  "${noct} wallpaper-random")

        # === dpms ===
        (mkBind "SUPER + XF86MonBrightnessDown" ''hl.dsp.dpms({ state = "off" })'')
        (mkBind "SUPER + XF86MonBrightnessUp"   ''hl.dsp.dpms({ state = "on" })'')

        # === media keys (noctalia) ===
        { _args = [ "XF86AudioLowerVolume"  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${noct} volume-down\")")  { locked = true; repeating = true; } ]; }
        (mkCmd  "XF86AudioMicMute"      "${noct} mic-mute")
        (mkCmd  "XF86AudioMute"         "${noct} volume-mute")
        (mkCmd  "XF86AudioNext"         "${noct} media next")
        (mkCmd  "XF86AudioPlay"         "${noct} media toggle")
        (mkCmd  "XF86AudioPrev"         "${noct} media previous")
        (mkCmd  "XF86AudioStop"         "${noct} media toggle")
        { _args = [ "XF86AudioRaiseVolume" (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${noct} volume-up\")") { locked = true; repeating = true; } ]; }
        { _args = [ "XF86MonBrightnessDown" (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${noct} brightness-down\")") { locked = true; repeating = true; } ]; }
        { _args = [ "XF86MonBrightnessUp"   (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${noct} brightness-up\")") { locked = true; repeating = true; } ]; }
      ];
    };
  };
}
