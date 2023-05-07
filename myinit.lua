
local function locate( table, value )
    for i = 1, #table do
        if table[i] == value then return true end
    end
    return false
end
require("nvim-lsp-installer").setup {}
--require('navigator').setup({  default_mapping = false, lsp_installer = true})
require("grammar-guard").init()
--require'lspconfig'.grammarly.setup{
     --filetypes = { "markdown" }
 --}
 require'lightspeed'.setup { ignore_case = true, repeat_ft_with_target_char = true}
     require('telescope').setup{}
--require('fzf-lua').setup{} 
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '_Q', vim.diagnostic.open_float, opts)
--vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
--vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '_q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    ---- Mappings.
    ---- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', '<BS>', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<c-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '_wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '_wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '_wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end
    , bufopts)
    vim.keymap.set('n', '_D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'gR', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    --vim.keymap.set('n', 'gi', vim.lsp.buf.__, bufopts)
    --vim.keymap.set('n', '_f', vim.lsp.buf.formatting, bufopts)
    ----vim.keymap.set('n','gW',require('navigator.workspace').workspace_symbol_live())
    ----vim.keymap.set('n','g0',require('navigator.symbols').document_symbols())
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    --local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local opts = { noremap=true, silent=true }

    --buf_set_keymap('n', '_a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    --buf_set_keymap('v', '_a', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
end

local cmp = require'cmp'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    --['<C-b>'] = cmp.mapping.scroll_docs(-4),
    --['<C-f>'] = cmp.mapping.scroll_docs(4),
["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
        feedkey("<Plug>(ultisnips_expand)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
     if cmp.visible() then
        cmp.select_prev_item()
     else
         cmp.complete()
     end
    end, { "i", "s" }),
    ['<esc>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    {
    name = "dictionary",
    keyword_length = 2,
    },
    { name = 'ultisnips' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}
require('lspconfig')['pyright'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['tsserver'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['rust_analyzer'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
        ["rust-analyzer"] = {}
    }
}
require("lspconfig").yamlls.setup{
    capabilities = capabilities,
    on_attach = on_attach,
}

require("lspconfig").vimls.setup{
    capabilities = capabilities,
    on_attach = on_attach,
}
require'lspconfig'.sumneko_lua.setup{
    capabilities = capabilities,
    on_attach = on_attach,
}    

vim.lsp.set_log_level("debug")

require('lspconfig').pylsp.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    settings =
    {
        pylsp = {
            plugins =
            {
                pycodestyle = {
                    enabled = false,
                    ignore = {'E225','E231'},
                },
                pydocstyle = {
                    enabled= false
                },
                pylint = { enabled = false }
            }
        }
    }
}
--require'lspconfig'.jedi_language_server.setup{
--capabilities = capabilities,
   --on_attach = on_attach,
   ----root_dir = function() return vim.loop.cwd() end,
   --init_options = {
        --jediSettings={
        --debug=true},
        --workspace = {
             --extrapaths=   {'./src/compare_my_stocks/gui','./src/compare_my_stocks/engine','./src/compare_my_stocks/input','./src/compare_my_stocks'}
             ----extraPaths ={'src/compare_my_stocks','c:/Users/ekarni/compare-my-stocks/src/compare_my_stocks'} --,'./src/compare_my_stocks','src/compare_my_stocks', './src/compare_my_stocks/gui','./src/compare_my_stocks/engine','./src/compare_my_stocks/input','./gui','./engine','./input','src\\compare_my_stocks\\engine','src\\compare_my_stocks\\gui'
             ----            environmentPath= 'C:\\Users\\ekarni\\compare-my-stocks\\venv\\Scripts\\python.exe',
        --}
    --}
--}
--require("aerial").setup({
--open_automatic = function(bufnr)
    
    ----filter on file types in list 'python','lua' 
    ----
    ----

    ---- filter based on file type
    --local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')

    --local your_list = { 'lua', 'python', 'markdown' }
    

  ---- Enforce a minimum line count
  --return (locate(your_list,filetype)) and vim.api.nvim_buf_line_count(bufnr) < 1800
--end
--,


    --on_attach = function(bufnr)
        ---- Toggle the aerial window with <leader>a
        --vim.api.nvim_buf_set_keymap(bufnr, 'n', '\\s', '<cmd>AerialToggle!<CR>', { })
        ---- Jump forwards/backwards with '{' and '}'
        --vim.api.nvim_buf_set_keymap(bufnr, 'n', '!', '<cmd>AerialPrev<CR>', {})
        --vim.api.nvim_buf_set_keymap(bufnr, 'n', '~', '<cmd>AerialNext<CR>', {})
        ---- Jump up the tree with '[[' or ']]'
        --vim.api.nvim_buf_set_keymap(bufnr, 'n', '[[', '<cmd>AerialPrevUp<CR>', {})
        --vim.api.nvim_buf_set_keymap(bufnr, 'n', ']]', '<cmd>AerialNextUp<CR>', {})
    --end
--})
--require("lspconfig").grammar_guard.setup({capabilities = capabilities,
--on_attach = on_attach,
--workspace = {
    --library = vim.api.nvim_get_runtime_file("", true),
--},
  --cmd = { 'C:\\Users\\ekarni\\AppData\\Local\\nvim-data\\lsp_servers\\ltex\\ltex-ls\\bin\\ltex-ls.bat' }, -- add this if you install ltex-ls yourself
	--settings = {
		--ltex = {
			--enabled = { "latex", "tex", "bib", "markdown" },
			--language = "en",
			--diagnosticSeverity = "information",
			--setenceCacheSize = 2000,
			--additionalRules = {
				--enablePickyRules = true,
				--motherTongue = "en",
			--},
			--trace = { server = "verbose" },
			--dictionary = {'c:\\temp\\words'},
			--disabledRules = {},
			--hiddenFalsePositives = {},
		--},
	--},
--})
require("cmp_dictionary").setup({
		dic = {
			["*"] = { "c:\\temp\\words" },
			spelllang = {
				en_us = "c:\\temp\\words",
			},
		},
		-- The following are default values.
		--exact = 2,
		--first_case_insensitive = false,
		--document = false,
		--document_command = "wn %s -over",
		--async = false, 
		--capacity = 5,
		--debug = false,
	})
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  --capabilities = capabilities
--}
require'lspconfig'.powershell_es.setup{
    capabilities = capabilities,
    on_attach = on_attach,
}
 require("which-key").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
    require("chatgpt").setup(
    { 
        chat = {
            sessions_window={ 
                buf_options = { 
                    cinkeys= "chatgpt"
                }            
            }
        },
    popup_window = {
        buf_options = {
            cinkeys= "chatgpt"
        }
    },
    settings_window = {
        buf_options = {
            cinkeys= "chatgpt"
        }
    },
    popup_input = {
     buf_options = {
            cinkeys= "chatgpt"
        }
    },
    log_file = "C:\\users\\ekarni\\chatgptn.log",
}
)



local chatgpt = require("chatgpt")
wk=require('which-key')
wk.setup()
wk.register({
    p = {
        name = "ChatGPT",
        e = {
            function()
                chatgpt.edit_with_instructions()
            end,
            "Edit with instructions",
        },
    },
}, {
    prefix = "<leader>",
    mode = "v",
})
--require("transparent").setup({
    --groups = { -- table: default groups
--},
--extra_groups = {"NormalFloat"}, -- table: additional groups that should be cleared
--exclude_groups = {}, -- table: groups you don't want to clear
--})
--[[{]]

--[[edit_with_instructions = {]]
    --[[diff = false,]]
    --[[keymaps = {]]
      --[[accept = "gy",]]
      --[[toggle_diff = "gY",]]
      --[[toggle_settings = "gG",]]
      --[[cycle_windows = "gH",]]
      --[[use_output_as_input = "gI",]]
    --[[}]]
  --[[}}]]
