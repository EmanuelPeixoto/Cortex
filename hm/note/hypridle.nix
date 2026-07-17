{ pkgs, ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "hyprctl dispatch dpms off";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 230;
          on-timeout = "${pkgs.libnotify}/bin/notify-send 'Inactivity Warning' 'You are away. The computer will enter sleep mode in 30 seconds.' -a Hypridle";
        }
        {
          timeout = 300;
          on-timeout = "hyprlock";
        }
        {
          timeout = 450;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  systemd.user.services.hypridle.Service.StandardOutput = "null";
}
