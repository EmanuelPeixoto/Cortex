{ pkgs, lib, ... }:
let
  driver = pkgs.fetchurl {
    url = "https://github.com/armel/uv-k1-k5v3-firmware-custom/releases/download/v5.5.0/f4hwn.fusion.chirp.v5.5.0.py";
    hash = "sha256-3yQSQ5SacJIIZLkoSZAofU57oAKA4fNoQaC0mMbNIDw=";
  };

  chirp-with-driver = pkgs.chirp.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      echo "Installing F4HWN driver into CHIRP..."

      DRIVER_DIR=$out/${pkgs.python3.sitePackages}/chirp/drivers
      mkdir -p $DRIVER_DIR

      cp ${driver} $DRIVER_DIR/f4hwn.py
    '';
  });

in
  {
  home.packages = [ chirp-with-driver ];

  # 🔹 entry desktop (corrigido)
  xdg.desktopEntries.chirp = {
    name = "CHIRP";
    comment = "Programador de rádios (UV-K5 F4HWN)";
    exec = "${lib.getExe chirp-with-driver}";
    icon = "chirp";
    terminal = false;
    categories = [ "Utility" "HamRadio" ];
  };
}
