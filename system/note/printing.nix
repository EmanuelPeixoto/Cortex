{ config, lib, pkgs, ... }:
let
  py = pkgs.python3.withPackages (p: [ p.pillow ]);
  pdftoppm = pkgs."poppler-utils";

  filter = pkgs.writeScript "diebold-im453h-filter" ''
    #!${py}/bin/python
    ${builtins.readFile ./diebold-filter.py}
  '';

  ppd = pkgs.writeText "diebold-im453h.ppd" ''
    *PPD-Adobe: "4.3"
    *FormatVersion: "4.3"
    *FileVersion: "1.0"
    *LanguageVersion: Portuguese
    *LanguageEncoding: ISOLatin1
    *PCFileName: "DIEBOLD.PPD"
    *Manufacturer: "Diebold"
    *Product: "(IM453H)"
    *ModelName: "Diebold IM453H"
    *ShortNickName: "Diebold IM453H"
    *NickName: "Diebold IM453H"
    *PSVersion: "(3010.000) 0"
    *LanguageLevel: "3"
    *ColorDevice: False
    *DefaultColorSpace: Gray
    *TTRasterizer: Type42
    *cupsVersion: 1.1
    *cupsSNMPSupplies: False
    *cupsLanguages: "pt"
    *cupsFilter2: "application/pdf application/vnd.cups-raw 0 diebold-im453h-filter"
    *cupsFilter2: "application/postscript application/vnd.cups-raw 0 diebold-im453h-filter"

    *OpenUI *PageSize/Media Size: PickOne
    *OrderDependency: 10 AnySetup *PageSize
    *DefaultPageSize: Tag95x40
    *PageSize Tag95x40/Etiqueta 95x40mm: "<</PageSize[269.291 113.386]>>setpagedevice"
    *PageSize 57mm/Recibo 57mm: "<</PageSize[161.575 595.276]>>setpagedevice"
    *PageSize 80mm/Recibo 80mm: "<</PageSize[226.772 595.276]>>setpagedevice"
    *CloseUI: *PageSize

    *DefaultImageableArea: Tag95x40
    *ImageableArea Tag95x40/Etiqueta 95x40mm: "0 0 269.291 113.386"
    *ImageableArea 57mm/Recibo 57mm: "0 0 161.575 595.276"
    *ImageableArea 80mm/Recibo 80mm: "0 0 226.772 595.276"
    *DefaultPaperDimension: Tag95x40
    *PaperDimension Tag95x40/Etiqueta 95x40mm: "269.291 113.386"
    *PaperDimension 57mm/Recibo 57mm: "161.575 595.276"
    *PaperDimension 80mm/Recibo 80mm: "226.772 595.276"
  '';

  dieboldDrv = pkgs.runCommand "diebold-im453h-cups" { } ''
    mkdir -p $out/lib/cups/filter $out/share/cups/model $out/bin
    cp ${filter} $out/lib/cups/filter/diebold-im453h-filter
    chmod +x $out/lib/cups/filter/diebold-im453h-filter
    cp ${ppd} $out/share/cups/model/diebold-im453h.ppd
    ln -s ${pdftoppm}/bin/pdftoppm $out/bin/pdftoppm
  '';
in
{
  services.printing = {
    enable = true;
    drivers = [ dieboldDrv ];
    extraConf = "FileDevice Yes";
  };

  # Keep usblp (CUPS blacklists it; filter writes to /dev/usb/lp0).
  # mkForce must be on the value, not the whole set, or it wipes the other blacklists.
  boot.blacklistedKernelModules = { usblp = lib.mkForce false; };

  # Register the queue at boot (idempotent) and set it as default.
  systemd.services.cups-diebold = {
    wantedBy = [ "multi-user.target" ];
    after = [ "cups.service" ];
    requires = [ "cups.service" ];
    serviceConfig.Type = "oneshot";
    path = [ pkgs.cups ];
    script = ''
      lpadmin -p IM453H -E -v file:///dev/null -m diebold-im453h.ppd -o PageSize=Tag95x40
      lpadmin -d IM453H
    '';
  };
}
