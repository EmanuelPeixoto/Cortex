{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pwvucontrol
  ];

  security.rtkit.enable = true;
  services.pipewire.enable = true;
}
