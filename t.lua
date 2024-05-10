require("lazy").setup(

{
  root = vim.g.pluginInstallPath,  -- share plugin folder with Plug
  defaults = {
      lazy = false, -- should plugins be lazy-loaded?
      version = false 
       
  }, performance = { rtp = {reset_packpath = true, paths = { '~/.vim'  }}},
  spec = {
      {import="plugged.noice"},
      {import="noice"},
      {import="noice.lua"},
      {import="plugged"},
    {"equalsraf/neovim-gui-shim",version="*", config = function () vim.cmd("colorscheme onedark") end,priority=10000},
    {'vim-airline/vim-airline',priority=1000    },
    --{'vim-airline/vim-airline',priority=3},
    {'unblevable/quick-scope',lazy=true,event="VeryLazy"},
    {'kana/vim-textobj-function', event="VeryLazy"} ,
    { 'rcarriga/nvim-notify'},
      LazyPlugSpecs,
      } 
  } )
