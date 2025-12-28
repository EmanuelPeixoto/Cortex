{ pkgs, lib, osConfig ? null, ... }:
let
  videoDrivers = if osConfig != null
    then osConfig.services.xserver.videoDrivers
  else [];

  isNvidia = lib.lists.elem "nvidia" videoDrivers;
  isAmd    = lib.lists.elem "amdgpu" videoDrivers;

  btopPackage = if isNvidia then pkgs.btop-cuda
  else if isAmd then pkgs.btop-rocm
  else pkgs.btop;
in
{
  programs.btop = {
    enable = true;
    package = btopPackage;
    settings = {
      update_ms = 500;
      cpu_single_graph = true;
      show_io_stat = false;
    };
  };
}
