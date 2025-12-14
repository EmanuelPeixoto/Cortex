{
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "HDs" ];
  networking.hostId = "e049c7ca"; # head -c 8 /etc/machine-id

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  fileSystems."/var/www" = {
    device = "HDs/www";
    fsType = "zfs";
  };

  fileSystems."/var/lib/nextcloud" = {
    device = "HDs/nextcloud";
    fsType = "zfs";
  };
}
