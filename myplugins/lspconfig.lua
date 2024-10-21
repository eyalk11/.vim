local on_attach = function(client, bufnr)
    vim.diagnostic.config({ virtual_text = { severity = vim.diagnostic.severity.ERROR }, virtual_lines = true })
    vim.keymap.set("", "_l", function()
        if vim.diagnostic.config().virtual_text then
            -- vim.diagnostic.config({ virtual_text = false, virtual_lines = { only_current_line = true } })
            vim.diagnostic.config({ virtual_text = { severity = vim.diagnostic.severity.ERROR }, virtual_lines = true })
        else
            vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
        end
    end, { desc = "Toggle lsp_lines" })
    --local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    ---- Mappings.
    ---- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "<BS>", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "_k", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "_wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "_ws", function()
        set_workspace_dir(vim.fn.input("Directory: ", vim.fn.getcwd()))
    end)
    vim.keymap.set("n", "_wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "_wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "mD", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "_D", function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, bufopts)
    vim.keymap.set("n", "gR", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    local function symb(...)
        require("telescope.builtin").lsp_workspace_symbols({
            layout_config = {
                horizontal = {
                    width = function(_, max_columns)
                        local percentage = 0.99
                        local max = 200
                        return math.min(math.floor(percentage * max_columns), max)
                    end,
                    height = function(_, _, max_lines)
                        local percentage = 0.99
                        local min = 100
                        return math.max(math.floor(percentage * max_lines), min)
                    end,
                },
                preview_width = 0.55,
            },
            fname_width = 15,
            symbol_width = 50,
            path_display = { "tail" },
        })
    end
    vim.keymap.set("n", "_s", symb, bufopts)
    --vim.keymap.set("v", "<c-y>", live_grep_args_shortcuts.grep_visual_selection)
    --local function format()
    --vim.lsp.buf.format({ timeout_ms = 2000 })
    --end
    --vim.keymap.set("n", "_f", format, bufopts)
    --vim.keymap.set('n', 'gi', vim.lsp.buf.__, bufopts)
    --vim.keymap.set('n', '_f', vim.lsp.buf.formatting, bufopts)
    ----vim.keymap.set('n','gW',require('navigator.workspace').workspace_symbol_live())
    ----vim.keymap.set('n','g0',require('navigator.symbols').document_symbols())
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    --local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local opts = { noremap = true, silent = true }

    buf_set_keymap("n", "_a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("v", "_a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    vim.keymap.set("n", "_A", require("actions-preview").code_actions, opts)
end

return {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = { "debugpy" },
        },
    },
    { "williamboman/mason-lspconfig.nvim" },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "nvim-telescope/telescope-live-grep-args.nvim",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            --{ "antosha417/nvim-lsp-file-operations", config = true },
        },
        config = function()
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")
            local nlspsettings = require("nlspsettings")
            --require("mason").setup()
            --require("mason-lspconfig").setup()

            nlspsettings.setup({
                config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
                local_settings_dir = ".nlsp-settings",
                local_settings_root_markers_fallback = { ".git" },
                append_default_schemas = true,
                loader = "json",
            })
            local global_capabilities = vim.lsp.protocol.make_client_capabilities()
            global_capabilities.textDocument.completion.completionItem.snippetSupport = true

            lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
                capabilities = global_capabilities,
            })

            mason.setup()
            mason_lspconfig.setup()
            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities()
            )
            local lsp_flags = {
                -- This is the default in Nvim 0.7+
                debounce_text_changes = 150,
            }
            --require("lspconfig")["tsserver"].setup({
            --capabilities = capabilities,
            --on_attach = on_attach,
            --flags = lsp_flags,
            --})
            require("lspconfig")["rust_analyzer"].setup({
                on_attach = on_attach,
                flags = lsp_flags,
                -- Server-specific settings...
                settings = {
                    ["rust-analyzer"] = {},
                },
            })
            require("lspconfig").powershell_es.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
            require("lspconfig").yamlls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
            local root_files = {
                "pyproject.toml",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
                "Pipfile",
                "pyrightconfig.json",
            }
            require("lspconfig").pylsp.setup({
                capabilities = capabilities,
                 on_attach = function(client, bufnr)
                    client.server_capabilities.completionProvider = false
                    on_attach(client, bufnr)
                end,
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                enabled = false,
                                ignore = { "E225", "E231" },
                            },
                            pydocstyle = {
                                enabled = false,
                            },
                            pylint = { enabled = false },
                            rope = { enabled = true, ropefolder = "C:\\temp\\rope" },
                            --rope_autoimport = {enabled = true, {code_actions = {enabled = true}}},
                            --rope_autoimport = {enabled = false, {completions = {enabled = false}, {code_actions = {enabled = false}}}},
                            jedi_symbols = {
                                enabled = true,
                                all_scopes = true,
                                include_import_symbols = true,
                                ignore_paths = { "^(?=.*compare-my-stocks)(?!.*src)" },
                            },

                            --jedi = { enabled= true }
                            --jedi = { extra_paths = {"c:\\gitproj\\Auto-GPT"} }
                        },
                        --root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1])
                    },
                },
            })
            require("lspconfig")["html_lsp"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                flags = lsp_flags,
            })

            --require("lspconfig")['htmlbeautifier'].setup({
            --capabilities = capabilities,
            --on_attach = on_attach,
            --flags = lsp_flags,
            --})
            require("lspconfig")["pyright"].setup({
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    --client.server_capabilities.completionProvider = false
                    on_attach(client, bufnr)
                end,
                flags = lsp_flags,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "openFilesOnly",
                            --logLevel = "Trace",
                        },
                    },
                },
                --root_dir = function() vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]) end
                --verboseOutput = true
                --settings = { extraPaths = { 'C:\\gitproj\\Auto-GPT','c:/gitproj/Auto-GPT' } }
            })
            --require("lspconfig").lua_ls.setup({
            --capabilities = capabilities,
            --on_attach = on_attach,
            --flags = lsp_flags,
            --})

            --require("lspconfig").vimls.setup{
            --capabilities = capabilities,
            --on_attach = on_attach,
            --}
            require("lspconfig").jsonls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                flags = lsp_flags,
            })
            mason_lspconfig.setup_handlers({
                function(server_name)
                    --local ignore_list = { "lua_ls", "lua-language-server", "sourcery" }
                    local ignore_list = {  "sourcery" }
                    local ignore = false

                    for _, v in ipairs(ignore_list) do
                        if v == server_name then
                            ignore = true
                            break
                        end
                    end

                    if not ignore then
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            flags = lsp_flags,
                        })
                    end
                end,
            })
        end,
    },
}
