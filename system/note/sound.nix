{ pkgs, ... }:
{
  # hardware.pulseaudio.extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";
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
