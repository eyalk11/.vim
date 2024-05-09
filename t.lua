require("lazy").setup(

{
  root = vim.g.pluginInstallPath,  -- share plugin folder with Plug
  defaults = {
      lazy = false, -- should plugins be lazy-loaded?
      version = false 
  },
  spec = {
    {"equalsraf/neovim-gui-shim",version="*",priority=10000},
    --{'vim-airline/vim-airline',priority=3},
    {'unblevable/quick-scope',lazy=false},

      LazyPlugSpecs,
      }
})
