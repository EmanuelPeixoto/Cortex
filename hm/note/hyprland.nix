{ config, lib, pkgs, ... }:
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
    configType = "lua";

    settings = {
      # Monitor
      monitor = {
        output = "eDP-1";
        mode = "preferred";
        position = "0x0";
        scale = 1;
      };

      # Configurações gerais
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
        };

        decoration = {
          shadow = {
            enabled = 0;
          };
          blur = {
            enabled = 0;
          };
        };

        misc = {
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
        };

        "animations.enabled" = 0;
      };

      # Binds
      bind = [
        # === mover janela para workspace (SUPER + SHIFT + N) ===
        {
          _args = [
            "SUPER + SHIFT + 0"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "10" })'')
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 1"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "1" })'')
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 2"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "2" })'')
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 3"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "3" })'')
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 4"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "4" })'')
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 5"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "5" })'')
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 6"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "6" })'')
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 7"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "7" })'')
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 8"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "8" })'')
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 9"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "9" })'')
          ];
        }

        # === sair / matar / special workspace ===
        {
          _args = [
            "SUPER + SHIFT + E"
            (lib.generators.mkLuaInline "hl.dsp.exit()")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + M"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "special:magic" })'')
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + Q"
            (lib.generators.mkLuaInline "hl.dsp.window.kill()")
          ];
        }

        # === mover janela (direcional) ===
        {
          _args = [
            "SUPER + SHIFT + down"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "down" })'')
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + left"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "left" })'')
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + right"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "right" })'')
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + up"
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "up" })'')
          ];
        }

        # === toggle floating ===
        {
          _args = [
            "SUPER + SHIFT + space"
            (lib.generators.mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'')
          ];
        }

        # === trocar workspace (SUPER + N) ===
        {
          _args = [
            "SUPER + 0"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "10" })'')
          ];
        }
        {
          _args = [
            "SUPER + 1"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "1" })'')
          ];
        }
        {
          _args = [
            "SUPER + 2"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "2" })'')
          ];
        }
        {
          _args = [
            "SUPER + 3"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "3" })'')
          ];
        }
        {
          _args = [
            "SUPER + 4"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "4" })'')
          ];
        }
        {
          _args = [
            "SUPER + 5"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "5" })'')
          ];
        }
        {
          _args = [
            "SUPER + 6"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "6" })'')
          ];
        }
        {
          _args = [
            "SUPER + 7"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "7" })'')
          ];
        }
        {
          _args = [
            "SUPER + 8"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "8" })'')
          ];
        }
        {
          _args = [
            "SUPER + 9"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "9" })'')
          ];
        }

        # === movefocus (direcional) ===
        {
          _args = [
            "SUPER + down"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "down" })'')
          ];
        }
        {
          _args = [
            "SUPER + left"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "left" })'')
          ];
        }
        {
          _args = [
            "SUPER + right"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "right" })'')
          ];
        }
        {
          _args = [
            "SUPER + up"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "up" })'')
          ];
        }

        # === mouse scroll workspace ===
        {
          _args = [
            "SUPER + mouse_down"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "e+1" })'')
          ];
        }
        {
          _args = [
            "SUPER + mouse_up"
            (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "e-1" })'')
          ];
        }

        # === mouse drag (mover e redimensionar janelas) ===
        {
          _args = [
            "SUPER + mouse:272"
            (lib.generators.mkLuaInline "hl.dsp.window.drag()")
            { mouse = true; }
          ];
        }
        {
          _args = [
            "SUPER + mouse:273"
            (lib.generators.mkLuaInline "hl.dsp.window.resize()")
            { mouse = true; }
          ];
        }

        # === apps ===
        {
          _args = [
            "SUPER + P"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${monitor-mode}/bin/monitor-mode\")")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + S"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${print-selection}/bin/print-selection\")")
          ];
        }
        {
          _args = [
            "SUPER + C"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"pkill clipse || ${pkgs.ghostty}/bin/ghostty --title='clipse' -e ${pkgs.clipse}/bin/clipse\")")
          ];
        }
        {
          _args = [
            "SUPER + D"
            (lib.generators.mkLuaInline ''hl.dsp.global("shell:runner")'')
          ];
        }
        {
          _args = [
            "SUPER + F"
            (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")
          ];
        }
        {
          _args = [
            "SUPER + H"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.systemd}/bin/systemctl hibernate\")")
          ];
        }
        {
          _args = [
            "SUPER + L"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.hyprlock}/bin/hyprlock --immediate\")")
          ];
        }
        {
          _args = [
            "SUPER + M"
            (lib.generators.mkLuaInline ''hl.dsp.workspace.toggle_special("magic")'')
          ];
        }
        {
          _args = [
            "SUPER + S"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.systemd}/bin/systemctl hybrid-sleep\")")
          ];
        }
        {
          _args = [
            "SUPER + return"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.ghostty}/bin/ghostty\")")
          ];
        }

        # === XF86 / print keys (sem mod) ===
        {
          _args = [
            "XF86Calculator"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.qalculate-qt}/bin/qalculate-qt\")")
          ];
        }
        {
          _args = [
            "XF86Favorites"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${wallpaper}/bin/wallpaper\")")
          ];
        }
        {
          _args = [
            "XF86SelectiveScreenshot"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${print-selection}/bin/print-selection\")")
          ];
        }
        {
          _args = [
            "print"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${print}/bin/print\")")
          ];
        }

        # === dpms ===
        {
          _args = [
            "SUPER + XF86MonBrightnessDown"
            (lib.generators.mkLuaInline ''hl.dsp.dpms({ state = "off" })'')
          ];
        }
        {
          _args = [
            "SUPER + XF86MonBrightnessUp"
            (lib.generators.mkLuaInline ''hl.dsp.dpms({ state = "on" })'')
          ];
        }

        # === media keys (com locked/repeating) ===
        {
          _args = [
            "XF86AudioLowerVolume"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 0.02- -l 1.25\")")
            { locked = true; repeating = true; }
          ];
        }
        {
          _args = [
            "XF86AudioMicMute"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SOURCE@ toggle\")")
          ];
        }
        {
          _args = [
            "XF86AudioMute"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle\")")
          ];
        }
        {
          _args = [
            "XF86AudioNext"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.playerctl}/bin/playerctl next\")")
          ];
        }
        {
          _args = [
            "XF86AudioPlay"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.playerctl}/bin/playerctl play-pause\")")
          ];
        }
        {
          _args = [
            "XF86AudioPrev"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.playerctl}/bin/playerctl previous\")")
          ];
        }
        {
          _args = [
            "XF86AudioStop"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.playerctl}/bin/playerctl stop\")")
          ];
        }
        {
          _args = [
            "XF86AudioRaiseVolume"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 0.02+ -l 1.25\")")
            { locked = true; repeating = true; }
          ];
        }
        {
          _args = [
            "XF86MonBrightnessDown"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.brightnessctl}/bin/brightnessctl set 5%-\")")
            { locked = true; repeating = true; }
          ];
        }
        {
          _args = [
            "XF86MonBrightnessUp"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.brightnessctl}/bin/brightnessctl set 5%+\")")
            { locked = true; repeating = true; }
          ];
        }
      ];

      # exec-once (startup)
      on = {
        _args = [
          "hyprland.start"
          (lib.generators.mkLuaInline ''
            function()
              hl.exec_cmd("${hyprland-exec}/bin/hyprland-exec")
            end
          '')
        ];
      };
    };
  };
}
