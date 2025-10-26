{ pkgs, ... }:

let
  myRPackages = with pkgs.rPackages; [
    BiocManager
    stringr
  ];

in
{
  services.rstudio-server = {
    enable = true;
    listenAddr = "0.0.0.0";

    package = pkgs.rstudioServerWrapper.override {
      packages = myRPackages;
    };
  };

  systemd.services.rstudio-server.path = with pkgs; [
    bash
    coreutils
    gnumake
    gcc
    gfortran
    pkg-config
    zlib.dev
    libxml2.dev
    openssl.dev
    curl.dev
    libgit2
    eigen
    imagemagick
    fontconfig
    cairo
  ];
}
