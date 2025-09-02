{
  boot = {
    plymouth = {
      enable = true;
    };

    consoleLogLevel = 0;
    initrd.verbose = false;
    loader.timeout = 0;

    kernelParams = [
      "boot.shell_on_fail"
      "loglevel=3"
      "quiet"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "splash"
      "udev.log_priority=3"
    ];
  };
}
