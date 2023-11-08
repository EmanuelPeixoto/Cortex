{lib, config, pkgs, ... }:
{
 
  #services.xserver.videoDrivers = [ "xf86-video-intel" ];
  services.xserver.videoDrivers = [ "modesetting" ];
 
  services.xserver.xrandrHeads = [ { output = "LVDS1"; primary = true; } "VGA1" ];

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  services.picom = {
    enable = true;
		vSync = true;
	};

  hardware.opengl = {
    enable = true;

    driSupport = true;
    driSupport32Bit = true;
    
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };


}
