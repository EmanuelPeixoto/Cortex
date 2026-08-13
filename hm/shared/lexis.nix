{ inputs, pkgs, lib, ... }:
let
  nixvim = inputs.lexis.inputs.nixvim;
in
{
  home.packages = [
    (nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule {
      inherit pkgs;
      module = {
        imports = [ (import (inputs.lexis + "/config")) ];
        # only C/C++ (clangd) and Nix (nixd)
        plugins.vimtex.enable = lib.mkForce false;
        plugins.lsp.servers = {
          bashls.enable = lib.mkForce false;
          cssls.enable = lib.mkForce false;
          emmet_ls.enable = lib.mkForce false;
          gopls.enable = lib.mkForce false;
          html.enable = lib.mkForce false;
          jsonls.enable = lib.mkForce false;
          rust_analyzer.enable = lib.mkForce false;
          texlab.enable = lib.mkForce false;
          ts_ls.enable = lib.mkForce false;
        };
      };
    })
  ];
}
