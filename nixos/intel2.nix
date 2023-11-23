{lib, config, pkgs, ... }:
{

  services.xserver.videoDrivers = [ "modesetting" ];

  #services.xserver.xrandrHeads = [ { output = "LVDS1"; primary = true; } "VGA1" ];

  /*nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };*/

  hardware.opengl = {
    enable = true;

    driSupport = true;
    driSupport32Bit = true;

    package = (pkgs.mesa.override {
      galliumDrivers = [ "crocus" "swrast" ];
      vulkanDrivers = [ "intel" ];
      enableGalliumNine = false;
    }).drivers;

    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      #vaapiVdpau
      #libvdpau-va-gl
    ];
  };


}
