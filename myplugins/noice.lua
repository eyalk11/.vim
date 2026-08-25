return {
        "folke/noice.nvim",
	enabled=true,
        priority=2000,
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            {
                "rcarriga/nvim-notify",
                config = function()
                    require("notify").setup({
                        top_down = false
                    })
                end,
            },
        },

        config = function()
require("noice").setup({
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
        hover = {
          enabled = false, -- Disable noice LSP hover to fix E5108 error
        },
      },
      --cmdline = { view="cmdline" },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        --command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        --lsp_doc_border = false, -- add a border to hover docs and signature help
      },
        routes = {
            {
                filter = { event = "msg_show", kind = "", find = "%d+L, %d+B" },
                opts = { skip = true },
            },
            {
                filter = { event = "msg_show", kind = "", find = "%[unix%]" },
                opts = { skip = true },
            },
            {
                filter = { event = "msg_show", kind = "", find = "%[dos%]" },
                opts = { skip = true },
            },
            {
                filter = { event = "msg_show", kind = "", find = "%[mac%]" },
                opts = { skip = true },
            },
            {
                filter = {
                    warning=true,
                    any = {
                        { find = 'nvim-treesitter.ts_utils.is_in_node_range'},
                        { find = 'make_range_params'},
                        { find = 'builtin jq'},
                        {find= 'lua-language-server' },
                        {find= 'Spawning language server with cmd' },
                        {find= 'Keyboard inte' },
                        {find= 'Unknown font' },
                    },
                },
                opts = { skip = true },
            },
            {
                filter = {
                    --event = "msg_show",
                    any = {
                        { find = "%d+L, %d+B" },
                        { find = "; after #%d+" },
                        { find = "; before #%d+" },
                        { find = "%d fewer lines" },
                        { find = "%d more lines" },
                        { find = "lines --" },
                        { find = "line --" },
                        { find = "CloseAll" },
                        { find = "Jumping to" },
                        { find = "next remote" },
                        { find = "No Information" },
                        { find = 'Cannot make changes' },
                        { find = 'Autocommands for "neoterm"' },
                        { find = ' Cancelled' },
                        { find = 'query.lua' },
                        { find = 'GoNext' },
                        { find = 'GoPrev' },
                        { find = 'ON_ATTACH_ERROR' } ,
                        { find = 'Creating new Claude Code terminal' },
                        { find = 'Cannot close last window'},
                        { find = 'LSP client '},
                        { find = 'No lines in buffer'},
                        { find = '(AutoSave)'},
                        { find = '[Nn][Aa][Tt][Ii][Vv][Ee] [Tt][Ee][Rr][Mm][Ii][Nn][Aa][Ll] [Oo][Pp][Ee][Nn][Ee][Dd]'},
                        { find = 'is_in_node_range'},
                        { find = 'nvim-treesitter.ts_utils.is_in_node_range'},
                        { find = 'make_range_params'},
                        { find = 'builtin jq'},
                        {find= 'lua-language-server' },
                        {find= '^%s*".*[\\/].*"%s*$' },
                        {find= 'Keyboard inte' },
                        {find= 'Unknown font' },
                    },
                },
                opts = { skip = true },
            },
        }}
    )

    vim.keymap.set("n", "<leader>em", "<cmd>NoiceHistory<cr>", { silent = true, desc = "Noice log" })
end,
    }
