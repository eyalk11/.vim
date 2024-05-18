vim.opt.rtp:prepend( vim.fn.expand( '~/.vim' ))
require("lazy").setup(

{
    moduledir= 'c:\\users\\ekarni\\.vim\\',
  root = vim.g.pluginInstallPath,  -- share plugin folder with Plug
  defaults = {
      lazy = false, -- should plugins be lazy-loaded?
      version = false
  },
 --, performance = { rtp = {reset_packpath = false , paths = {vim.fn.expand( '~/.vim/plugged')  }}},
  spec = {
        {import = "plugins.noice" },
        {import = "plugins.lspconfig" },
        {
            "ibhagwan/fzf-lua",
            -- optional for icon support
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                -- calling `setup` is optional for customization
                require("fzf-lua").setup({})
            end
        },
        {
            "m-gail/diagnostic_manipulation.nvim",
            event = "VeryLazy",
            init = function ()
                require("diagnostic_manipulation").setup {
                    blacklist = {
                        function(diagnostic)
                            return string.find(diagnostic.message, "Undefined global `vim`")
                        end
                        --require("diagnostic_manipulation.builtin.tsserver").tsserver_codes({ 6133, 6196 })
                    },
                    whitelist = {
                        -- Your whitelist here
                    }
                }
            end
        },
        --{import = "plugins" },
        { "rafamadriz/friendly-snippets" },
        --{import = "plugins" },
      --{import="plugged/noice"},
      --{import="plugins"},
      --{import="noice"},
--[[      {]]
          --[["folke/tokyonight.nvim",]]
          --[[lazy = false,]]
          --[[priority = 1000,]]
          --[[opts = {},]]
      --[[},]]
    {"equalsraf/neovim-gui-shim",version="*", config = function () vim.cmd("colorscheme onedark") end,priority=10000},
    {'vim-airline/vim-airline',priority=1000    },
    {'unblevable/quick-scope',lazy=true,event="VeryLazy"},
    {'kana/vim-textobj-function', event="VeryLazy"} ,
    { 'rcarriga/nvim-notify'},
      LazyPlugSpecs,
      }
  } )
