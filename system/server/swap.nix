{
  swapDevices = [
    {
      device = "/swapfile";
      size = 16384;
    }
  ];

  # Prefer RAM; swap only under real memory pressure (avoids needless slowdown).
  boot.kernel.sysctl."vm.swappiness" = 10;
}
