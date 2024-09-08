{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  services.displayManager.ly = {
    enable = true;
    settings = {
      waylandsessions = "${config.users.users.emanuel.home}/.nix-profile/share/wayland-sessions";
      animation = "matrix";
      clock = "%d/%m/%y - %R";
      xinitrc = "null";
      brightness_down_cmd = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
      brightness_down_key = "F5";
      brightness_up_cmd = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
      brightness_up_key = "F6";
    };
  };
}
