{lib, config, pkgs, ... }:
{


  programs.neovim =
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in
  {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      lua-language-server
      rnix-lsp
      luajitPackages.lua-lsp
      gopls
    ];

    plugins = with pkgs.vimPlugins; [

      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./plugins/lsp.lua;
      }
      {
        plugin = comment-nvim;
        config = toLua "require(\"Comment\").setup()";
      }
      {
        plugin = nvim-cmp;
        config = toLuaFile ./plugins/cmp.lua;
      }

      nvim-cmp
      vim-nix
      neodev-nvim
      luasnip
      cmp-nvim-lsp
      cmp_luasnip
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./options.lua}
    '';

  };


}
