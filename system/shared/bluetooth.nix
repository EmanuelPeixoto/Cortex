{
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      ControllerMode = "dual";
    };
    Policy = {
      AutoEnable = false;
    };
  };
  services.blueman.enable = true;

  systemd.services.bluetooth.serviceConfig = {
    StandardOutput = "null";
    StandardError = "null";
  };
}
