{
  services = {
    libinput = {
      enable = true;

      mouse.accelProfile = "flat";

      touchpad = {
        accelProfile = "flat";
        accelSpeed = "0.65";
      };
    };
  xserver = {
    enable = true;
    exportConfiguration = true;

    xkb = {
      layout = "br";
      variant = "";
      model = "";
    };

    windowManager.dwm.enable = true;
    desktopManager.xterm.enable = false;
  };
  };
}
