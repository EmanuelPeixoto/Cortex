{ config, pkgs, ... }:
{
  home.packages = [ pkgs.satty ];

  xdg.configFile."satty/config.toml".text = ''
    [general]
    output-filename = "~/Pictures/satty-%Y-%m-%d_%H:%M:%S.png"
    floating-hack = true
    early-exit = ["all"]
    resize = { mode = "smart" }
  '';

  programs.noctalia = {
    enable = true;

    settings = {
      bar.default = {
        position = "top";
        start = [ "session" "clock" "group:g1" "privacy" ];
        center = [ "workspaces" ];
        end = [ "media" "volume" "network" "notifications" "tray" ];
        thickness = 35;
        margin_edge = 0;
        margin_ends = 0;
        radius_top_left = 0;
        radius_top_right = 0;
        radius_bottom_left = 12;
        radius_bottom_right = 12;
        concave_edge_corners = true;

        capsule_group = [
          {
            id = "g1";
            members = [ "temp" "sysmon_2" "battery" "sysmon_3" ];
          }
        ];
      };

      wallpaper = {
        directory = "${config.home.homeDirectory}/Nextcloud/Wallpapers";
        fill_mode = "crop";

        automation = {
          enabled = true;
          interval_seconds = 1800;
          order = "random";
          recursive = true;
        };
      };

      audio = {
        enable_overdrive = true;  # volume slider até 150%
      };

      nightlight = {
        enabled = true;
        temperature_day = 6500;
        temperature_night = 4000;
      };

      weather = {
        enabled = false;
      };

      lockscreen = {
        enabled = true;
        lock_before_suspend = true;
        fingerprint = true;
        blurred_desktop = true;
        blur_intensity = 0.6;
      };

      shell = {
        polkit_agent = true;
        settings_show_advanced = true;
        clipboard_history_max_entries = 500;
        panel = {
          session_placement = "floating";
          session_position = "center";
        };
        screenshot = {
          save_to_file = false;
          copy_to_clipboard = true;
          pipe_to_command = true;
          pipe_command = "satty -f -";
        };
      };

      widget = {
        clock = {
          format = "{:%d/%m/%Y %H:%M}";
        };
        workspaces = {
          capsule = true;
          capsule_fill = "on_primary";
          show_labels = true;
          label_source = "id";
        };
        tray = {
          capsule = true;
          capsule_fill = "on_secondary";
        };
        media = {
          hide_when_no_media = true;
        };
        privacy = {
          type = "privacy";
          hide_inactive = true;
        };
        temp = {
          show_value = false;
        };
        sysmon_2 = {
          type = "sysmon";
          stat = "gpu_temp";
          glyph = "gpu-usage";
          show_value = false;
        };
        sysmon_3 = {
          type = "sysmon";
          stat = "ram_used";
          glyph = "cpu-2";
        };
      };
    };
  };
}
