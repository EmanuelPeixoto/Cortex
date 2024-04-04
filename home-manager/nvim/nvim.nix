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
      clang-tools
      emmet-ls
      gopls
      lua-language-server
      luajitPackages.lua-lsp
      nixd
      texlab
      vscode-langservers-extracted
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
      {
        plugin = gruvbox-nvim;
        config = "colorscheme gruvbox";
      }
      {
        plugin = lualine-nvim;
        config = toLua "require(\"lualine\").setup{icons_enabled = true,}";
      }

      cmp-nvim-lsp
      cmp_luasnip
      luasnip
      neodev-nvim
      nvim-cmp
      nvim-web-devicons
      vim-nix
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./options.lua}
    '';

  };
}
