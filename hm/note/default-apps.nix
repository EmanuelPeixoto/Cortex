{ pkgs, ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "zathura.desktop";
      "application/x-bittorrent" = "qbittorrent.desktop";
      "application/x-extension-htm" = "zen-beta.desktop";
      "application/x-extension-html" = "zen-beta.desktop";
      "application/x-extension-shtml" = "zen-beta.desktop";
      "application/x-extension-xht" = "zen-beta.desktop";
      "application/x-extension-xhtml" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
      "audio/mpeg" = "vlc.desktop";
      "audio/x-wav" = "vlc.desktop";
      "image/gif" = "nomacs.desktop";
      "image/jpeg" = "nomacs.desktop";
      "image/png" = "nomacs.desktop";
      "message/rfc822" = "userapp-Thunderbird-PO8FT2.desktop";
      "text/html" = "zen-beta.desktop";
      "text/plain" = "nvim.desktop";
      "video/mp4" = "vlc.desktop";
      "video/x-matroska" = "vlc.desktop";
      "x-scheme-handler/chrome" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/magnet" = "qbittorrent.desktop";
      "x-scheme-handler/mailto" = "userapp-Thunderbird-PO8FT2.desktop";
    };
  };

  xdg.desktopEntries = {
    zathura = {
      name = "Zathura";
      exec = "${pkgs.zathura}/bin/zathura";
      mimeType = [ "application/pdf" ];
    };

    nomacs = {
      name = "Nomacs";
      exec = "${pkgs.nomacs}/bin/nomacs";
      mimeType = [ "image/jpeg" "image/png" "image/gif" ];
    };
  };
}
