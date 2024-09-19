{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pamixer
    pavucontrol
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
}
