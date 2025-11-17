{ pkgs, ... }:
{
  services.rstudio-server = {
    enable = true;
    listenAddr = "0.0.0.0";
    rserverExtraConfig = "www-root-path=/rstudio";
    package = pkgs.rstudioServerWrapper.override {
      packages = with pkgs.rPackages; [
        BiocManager
        DiagrammeR
        DiagrammeRsvg
        Matrix
        # UCSCXenaShiny
        # UCSCXenaTools
        # UCSC_utils
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
        patchwork
        pROC
        pdftools
        remotes
        rentrez
        reshape2
        rio
        R_utils
        rms
        rsvg
        Seurat
        SeuratObject
        sctransform
        stringi
        survival
        survivalROC
        survminer
        tidyverse
        tiff
        timeROC
        xgboost
      ];
    };
  };

  systemd.services.rstudio-server = {
    path = with pkgs; [
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
      toybox
      zlib.dev
    ];
  };
}
