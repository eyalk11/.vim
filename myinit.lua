
local function locate( table, value )
    for i = 1, #table do
        if table[i] == value then return true end
    end
    return false
end
require("nvim-lsp-installer").setup {}
local navbuddy = require("nvim-navbuddy")
local actions = require("nvim-navbuddy.actions")
navbuddy.setup {
    lsp = {
    auto_attach = true}}

--require("symbols-outline").setup()
--require('navigator').setup({  default_mapping = false, lsp_installer = true})
require("grammar-guard").init()
--require'lspconfig'.grammarly.setup{
     --filetypes = { "markdown" }
 --}
 require'lightspeed'.setup { ignore_case = true, repeat_ft_with_target_char = true}

local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")
local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

telescope.setup {
  extensions = {
    live_grep_args = {
        postfix = "",
        quote = false,
      auto_quoting = false, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = { -- extend mappings
        i = {
          --["<C-y>"] = lga_actions.quote_prompt(),
          --["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      },
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
    }
  }
}


local telescope=require('telescope')
--- Absolute path of the current node's directory
--- @return string|nil
local function node_dir_path()
local api =require('nvim-tree.api')
local node = api.tree.get_node_under_cursor()
  if not node then
    return
  end

  if node.parent and node.type == "file" then
    node = node.parent
  end

  return node.absolute_path
end
 local function find_files()
     telescope.find_files({ search_dirs = { node_dir_path() } })
 end

 local function live_grep()
     telescope.live_grep({ search_dirs = { node_dir_path() } })
 end

--require('fzf-lua').setup{} 
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '_Q', vim.diagnostic.open_float, opts)
--vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
--vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '_q', vim.diagnostic.setloclist, opts)
local function opencwd ()
    local api = require('nvim-tree.api')
    api.tree.open({ path = vim.fn.getcwd() })
end
vim.keymap.set('n', 'mt' , opencwd ,opts)
vim.keymap.set('n', 'mt' , opencwd ,opts)
vim.keymap.set('n','<esc>','<esc>',opts)
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
    vim.keymap.set("v", "<c-y>", live_grep_args_shortcuts.grep_visual_selection)
    --vim.keymap.set('n', 'gi', vim.lsp.buf.__, bufopts)
    --vim.keymap.set('n', '_f', vim.lsp.buf.formatting, bufopts)
    ----vim.keymap.set('n','gW',require('navigator.workspace').workspace_symbol_live())
    ----vim.keymap.set('n','g0',require('navigator.symbols').document_symbols())
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    --local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local opts = { noremap=true, silent=true }

    buf_set_keymap('n', '_a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('v', '_a', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
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

    ["<S-Tab>"] = cmp.mapping(function(fallback)
     if cmp.visible() then
        cmp.select_prev_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
     end
    end, { "i", "s" }),
    ['<esc>'] = cmp.mapping(function(fallback)
    if cmp.visible() then cmp.abort()
    else vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "n", true)
    end 
end ),
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
--require('lspconfig')['pyright'].setup{
    --capabilities = capabilities,
    --on_attach = on_attach,
    --flags = lsp_flags,
--}
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

--vim.lsp.set_log_level("debug")
local root_files = {
"pyproject.toml",
"setup.py",
"setup.cfg",
"requirements.txt",
"Pipfile",
"pyrightconfig.json",
}

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
                pylint = { enabled = false },
                rope = {enabled = true },
                rope_auto_import = {enabled = true},
                jedi_symbols = { enabled = true, all_scopes = true, include_import_symbols = true}
            },
            root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1])
        }
    }
}
--

--vim.api.nvim_create_autocmd("FileType", {
--pattern = "python",
--callback = function()
  --vim.lsp.start({
--name = "jedi-language-server",
--cmd= { 'C:\\Users\\ekarni\\.pyenv\\pyenv-win\\versions\\3.9.6\\Scripts\\jedi-language-server.EXE', '-v', '--log-file','c:\\temp\\jedi-language-server.log'},
 --root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
--config = { 
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


 --} )end } )
 


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
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
local function grep_at_current_tree_node()
    local node = require('nvim-tree.lib').get_node_at_cursor()
    if not node then return end
    require('telescope.builtin').live_grep({search_dirs = {node.absolute_path}})
end

  local function my_on_attach(bufnr)
    local api = require('nvim-tree.api')

      local function global_cd_node_path()
        local node = api.tree.get_node_under_cursor()
        print(node.absolute_path)

        if vm.fn.filereadble(node.absolute_path) == 2 then 
            local fil=node.absolute_path -- is dir
        else 
            local fil=vim.fn.fnamemodify(node.absolute_path,':h')
        end

        vim.api.nvim_command('cd ' .. fil  )
      end

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.del('n', 'x', { buffer = bufnr })
    vim.keymap.del('n', 'd', { buffer = bufnr })
    vim.keymap.del('n', 'y', { buffer = bufnr })
    vim.keymap.del('n', 'c', { buffer = bufnr })
    -- override a default
    vim.keymap.set('n', '<space>', api.node.open.edit,                       opts('Open'))
    vim.keymap.set('n', 'zM', api.tree.collapse_all,                       opts('Collapse All'))
    vim.keymap.set('n', 'zR', api.tree.expand_all,                       opts('Expand All'))
    vim.keymap.set('n', 'X', api.fs.remove,                       opts('Del'))
    vim.keymap.set('n', 'dd', api.fs.cut,                       opts('Cut'))
    vim.keymap.set('n', 'yy',api.fs.copy.node , opts('Copy'))
    vim.keymap.set('n', 'cn',api.fs.copy.filename , opts('Copy Name'))
    vim.keymap.set('n', 'cd',global_cd_node_path , opts('Change Cwd'))
    vim.keymap.set('n', '/',(function() vim.api.nvim_command('Fin -matcher=fuzzy') end) , opts('Find'))
    vim.keymap.set('n', '<C-[>',api.tree.change_root_to_parent , opts('Goto Parent'))
    vim.keymap.set('n', '<left>',api.tree.change_root_to_parent , opts('Goto Parent'))
    vim.keymap.set('n', '<right>',api.tree.change_root_to_node , opts('Root to Node'))
    vim.keymap.set('n', 'Mt' , (function() api.tree.change_root_to_node(); timer.performWithDelay(1000, function() vim.api.nvim_command('Fin -matcher=fuzzy') end , 0) end),opts('TT'))


    vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))

    vim.keymap.set('n', 'f',        find_files,                         opts('Find Files'))
    vim.keymap.set('n', 'g',        live_grep,                          opts('Live Grep'))
    vim.keymap.set('n', '<Leader>gr' , grep_at_current_tree_node , opts('Grep at current'))
    ---
  end

-- OR setup with some options
require("nvim-tree").setup({
on_attach = my_on_attach,
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  --actions = { change_dir = { global = true }},
  filters = {
    dotfiles = false,
    gitignore = false
  },
  live_filter = {
      prefix = "[FILTER]: ",
      always_show_folders = false,
  },
})
