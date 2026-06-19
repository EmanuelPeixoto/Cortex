{
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      ControllerMode = "dual";
    };
    Policy = {
      AutoEnable = true;
    };
  };
  services.blueman.enable = true;

  systemd.services.bluetooth.serviceConfig = {
    StandardOutput = "null";
    StandardError = "null";
  };
}
