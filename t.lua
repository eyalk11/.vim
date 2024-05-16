vim.opt.rtp:prepend( vim.fn.expand( '~/.vim' ))
require("lazy").setup(

{
    moduledir= 'c:\\users\\ekarni\\.vim\\',
  root = vim.g.pluginInstallPath,  -- share plugin folder with Plug
  defaults = {
      lazy = false, -- should plugins be lazy-loaded?
      version = false 
       
  },
-- , performance = { rtp = {reset_packpath = false , paths = {vim.fn.expand( '~/.vim/plugged')  }}},
  spec = {
        {import = "plugins" },
        --{import = "plugins" },
      --{import="plugged/noice"},
      --{import="plugins"},
      --{import="noice"},
    {"equalsraf/neovim-gui-shim",version="*", config = function () vim.cmd("colorscheme onedark") end,priority=10000},
    {'vim-airline/vim-airline',priority=1000    },
    --{'vim-airline/vim-airline',priority=3},
    {'unblevable/quick-scope',lazy=true,event="VeryLazy"},
    {'kana/vim-textobj-function', event="VeryLazy"} ,
    { 'rcarriga/nvim-notify'},
      LazyPlugSpecs,
      } 
  } )
