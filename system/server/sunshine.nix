{
  config,
  lib,
  pkgs,
  ...
}:
let
  micPort = 12345;
  steamUiArgs = "-gamepadui";
  gamescopeBin = "${config.security.wrapperDir}/gamescope";

  steam-session = pkgs.writeShellApplication {
    name = "steam-session";
    runtimeInputs = [ pkgs.systemd ];
    text = ''
      systemctl --user start graphical-session.target

      exec ${gamescopeBin} -W 1920 -H 1080 -r 60 -e --rt -- ${lib.getExe pkgs.steam} ${steamUiArgs}
    '';
  };
in
{
  networking.firewall.allowedTCPPorts = [ micPort ];

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;

    settings = {
      csrf_allowed_origins = "https://localhost:47990,https://127.0.0.1:47990,https://192.168.0.10:47990";
    };

    applications = {
      apps = [
        {
          name = "Steam";
          cmd = "${lib.getExe pkgs.steam} ${steamUiArgs}";
        }
      ];
    };
  };

  services.pipewire = {
    enable = true;

    extraConfig.pipewire."99-sunshine-mic" = {
      "context.modules" = [
        {
          name = "libpipewire-module-loopback";
          args = {
            "node.name" = "sunshine-mic";
            "node.description" = "Sunshine Microphone";
            "capture.props" = {
              "media.class" = "Audio/Sink";
              "node.name" = "sunshine-mic-sink";
            };
            "playback.props" = {
              "media.class" = "Audio/Source";
              "node.name" = "sunshine-mic";
            };
          };
        }
      ];
    };
  };

  systemd.user.services.mic-receiver = {
    description = "Receive mic audio from Moonlight notebook";
    wantedBy = [ "default.target" ];
    after = [ "pipewire.service" ];
    serviceConfig = {
      Type = "simple";
      # To reduce latency, add --latency 480/48000 (10ms) or 256/48000 (~5ms) to pw-cat.
      # Values below 256 can cause stutter (underrun).
      ExecStart = "${pkgs.bash}/bin/bash -c 'while true; do ${pkgs.netcat}/bin/nc -l ${toString micPort} | ${pkgs.pipewire}/bin/pw-cat -ap --latency 480/48000 --target=sunshine-mic-sink --format s16 --rate 48000 --channels 1 -; done'";
      Restart = "always";
      RestartSec = 3;
    };
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${lib.getExe steam-session}";
        user = "emanuel";
      };

      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --time --cmd ${lib.getExe steam-session}";
        user = "greeter";
      };
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;

  security.polkit.enable = true;
}
