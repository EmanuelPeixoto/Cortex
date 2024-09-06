{ config, ... }:
{
  services.displayManager.ly = {
    enable = true;
    settings = {
      waylandsessions = "${config.users.users.emanuel.home}/.nix-profile/share/wayland-sessions";
    };
  };
}
