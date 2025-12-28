{ pkgs, ... }:
let
  prismPatched = pkgs.prismlauncher.override {
    prismlauncher-unwrapped = pkgs.prismlauncher-unwrapped.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (pkgs.fetchurl {
          url = "https://github.com/Misterio77/PrismLauncher/commit/2051b0b886b70d4efa9fbebc22d7d2fbe1e89255.diff";
          hash = "sha256-9/yYOPUkcHD5kL2PN9Ri8TsuthwbhHj4erx0wrr2mPQ=";
        })
      ];
    });
  };
in
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    applications = {
      apps = [
        {
          name = "Steam Big Picture";
          cmd = "${pkgs.steam}/bin/steam -bigpicture";
        }
        {
          name = "Prism Launcher";
          cmd = "${prismPatched}/bin/prismlauncher";
        }
        {
          name = "GTA SA";
          cmd = "${pkgs.wine}/bin/wine gta_sa.EXE";
          working_dir = "/home/emanuel/.wine/drive_c/Program Files/Rockstar Games/GTA San Andreas/";
        }

        {
          name = "Desktop";
          cmd = "${pkgs.bash}/bin/sh -c 'while true; do sleep 1000; done'";
        }
      ];
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "Hyprland";
        user = "emanuel";
      };

      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
  programs.hyprland.enable = true;
}
