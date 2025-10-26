{ pkgs, ... }:

let
  # para instalar os pacotes por aqui, busque os disponiveis no nixpkgs ex.: rPackages.BiocManager e coloque apenas BiocManager abaixo.
  myRPackages = with pkgs.rPackages; [
    BiocManager
    DiagrammeR
    DiagrammeRsvg
    Matrix
    UCSCXenaShiny
    UCSCXenaTools
    UpSetR
    VIM
    caret
    circlize
    data_table
    doParallel
    foreach
    fs
    ggplot2
    ggpubr
    ggtext
    gridExtra
    kableExtra
    lightgbm
    magick
    mice
    missForest
    openxlsx
    pROC
    pdftools
    remotes
    rentrez
    reshape2
    rio
    rms
    rsvg
    stringi
    survival
    survivalROC
    survminer
    tidyverse
    tiff
    timeROC
    xgboost
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
    binutils
    cairo
    cmake
    coreutils
    curl.dev
    diffutils
    eigen
    fontconfig.dev
    freetype.dev
    gawk
    gcc
    getconf
    gfortran
    gnutar
    gnumake
    gzip
    imagemagick.dev
    libgit2
    libjpeg
    libpng.dev
    librsvg
    libtiff
    libxml2.dev
    nlopt
    openssl.dev
    pkg-config
    poppler
    zlib.dev
  ];
}
