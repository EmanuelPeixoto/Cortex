{
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [ "HD" ];
  networking.hostId = "e049c7ca"; # head -c 8 /etc/machine-id

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  fileSystems."/var/www" = {
    device = "HD/www";
    fsType = "zfs";
  };

  fileSystems."/var/lib/nextcloud" = {
    device = "HD/nextcloud";
    fsType = "zfs";
  };
}
