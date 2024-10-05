vim.opt.rtp:prepend(vim.fn.expand("~/.vim"))
require("lazy").setup({
    moduledir = "c:\\users\\ekarni\\.vim\\",
    root = vim.g.pluginInstallPath, -- share plugin folder with Plug
    defaults = {
        lazy = false,            -- should plugins be lazy-loaded?
        version = false,
    },
    --, performance = { rtp = {reset_packpath = false , paths = {vim.fn.expand( '~/.vim/plugged')  }}},
    spec = {
        { import = "plugins.noice" },
        { import = "plugins.repmo" },
        { import = "plugins.lspconfig" },
        {
            "rcarriga/nvim-dap-ui",
            dependencies = "mfussenegger/nvim-dap",
            config = function()
                local dap = require("dap")
                local dapui = require("dapui")
                dapui.setup()
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open()
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close()
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close()
                end
            end,
        },
        {
            "mfussenegger/nvim-dap",
            config = function(_, opts)
                --require("core.utils").load_mappings("dap")
            end,
        },
        {
            "mfussenegger/nvim-dap-python",
            ft = "python",
            dependencies = {
                "mfussenegger/nvim-dap",
                "rcarriga/nvim-dap-ui",
                "nvim-neotest/nvim-nio",
            },
            config = function(_, opts)
                local path =
                [[ C:\Users\ekarni\AppData\Local\nvim-data\mason\packages\debugpy\venv\Scripts\python.exe ]] --"~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
                require("dap-python").setup(path)
                --require("core.utils").load_mappings("dap_python")
            end,
        },
        {
            "ibhagwan/fzf-lua",
            -- optional for icon support
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                -- calling `setup` is optional for customization
                require("fzf-lua").setup({})
            end,
        },
        {
            "m-gail/diagnostic_manipulation.nvim",
            event = "VeryLazy",
            init = function()
                require("diagnostic_manipulation").setup({
                    blacklist = {
                        function(diagnostic)
                            return string.find(diagnostic.message, "Undefined global `vim`")
                        end,
                        --require("diagnostic_manipulation.builtin.tsserver").tsserver_codes({ 6133, 6196 })
                    },
                    whitelist = {
                        -- Your whitelist here
                    },
                })
            end,
        },
        {
            "nvim-lualine/lualine.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                local function hello()
                  return  vim.uv.cwd()
                end

                require("lualine").setup({
                    options ={ path=1} ,
                    sections = {
                        lualine_c = {"filename",[[ | ]], hello}
                    },
                }
                )
            end,
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
        --{"equalsraf/neovim-gui-shim",version="*", config = function () vim.cmd("colorscheme onedark") end,priority=10000},
        -- {'vim-airline/vim-airline',priority=1000    },
        { "unblevable/quick-scope",      lazy = true,       event = "VeryLazy" },
        { "kana/vim-textobj-function",   event = "VeryLazy" },
        { "vim-ctrlspace/vim-ctrlspace", priority = 10000 },
        {
            "rcarriga/nvim-notify",
            config = function()
                vim.cmd("colorscheme onedark")
            end,
            priority = 10000,
        }, -- just for the colorscheme
        LazyPlugSpecs,
    },
})
