

local api = vim.api
function GotoMap()
	local str = vim.fn.input("Enter the mapping: ")
	local output = vim.api.nvim_exec("verbose nmap " .. str, true)
	local lines = {}
	for s in output:gmatch("[^\r\n]+") do
		table.insert(lines, s)
	end
	for i, line in ipairs(lines) do
		if line:find("^n  .*") then
			-- This line is a mapping
			local lhs = line:match("^n  (.-)%s+.*")
			if lhs then
				-- Get the source file and line number from the next line
				local source_line = lines[i + 1]
				local source_file = source_line:match("Last set from (.-) line")
				local line_number = tonumber(source_line:match("line (%d+)"))
				if source_file and line_number then
					-- Check if the source file exists
					api.nvim_command("edit " .. source_file)
                    
					api.nvim_command(tostring(line_number) .. ":")
				end
			end
		end
	end
end

function _G.BufIsBig(bufnr)
	local max_filesize = 100 * 1024 -- 100 KB
	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
	if ok and stats and stats.size > max_filesize then
		return true
	else
		return false
	end
end

function _G.set_workspace_dir(dir)
	vim.lsp.buf.add_workspace_folder(dir)
	local folders = vim.lsp.buf.list_workspace_folders()
	for i = 1, #folders do
		if dir ~= folders[i] then
			vim.lsp.buf.remove_workspace_folder(folders[i])
		end
	end
end

vim.api.nvim_create_autocmd({ "CmdLineLeave", "BufLeave", "BufEnter", "WinEnter" }, {
	callback = function(args)
		vim.cmd("noh")
	end,
})
-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function _G.tprint(tbl, indent)
	if not indent then
		indent = 0
	end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2
	for k, v in pairs(tbl) do
		pcall(function()
			toprint = toprint .. string.rep(" ", indent)
			if type(k) == "number" then
				toprint = toprint .. "[" .. k .. "] = "
			elseif type(k) == "string" then
				toprint = toprint .. k .. "= "
			end

			if type(v) == "number" then
				toprint = toprint .. v .. ",\r\n"
			elseif type(v) == "string" then
				toprint = toprint .. '"' .. v .. '",\r\n'
			elseif type(v) == "table" then
				toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
			else
				toprint = toprint .. '"' .. tostring(v) .. '",\r\n'
			end
		end)
	end
	toprint = toprint .. string.rep(" ", indent - 2) .. "}"
	pcall(function()
		print(toprint)
	end)
end

--function _G.set_all_workspace_dir(dir)
--for t in vim.lsp.buf.list_workspace_folders() do
--vim.lsp.buf.remove_workspace_folder(t)
--end
--vim.lsp.buf.add_workspace_folder(dir)
--end
local function locate(table, value)
	for i = 1, #table do
		if table[i] == value then
			return true
		end
	end
	return false
end
--require("nvim-lsp-installer").setup {}
local navbuddy = require("nvim-navbuddy")
local actions = require("nvim-navbuddy.actions")
navbuddy.setup({
	lsp = {
		auto_attach = true,
	},
	window = { size = "85%" },
})

--require("symbols-outline").setup()
--require('navigator').setup({  default_mapping = false, lsp = {disable_lsp  = "all" }} )
require("grammar-guard").init()
--require'lspconfig'.grammarly.setup{
--filetypes = { "markdown" }
--}
require("lightspeed").setup({ ignore_case = true, repeat_ft_with_target_char = true })

local lga_actions = require("telescope-live-grep-args.actions")
require("nvim-lightbulb").setup({
	ignore = { ft = { "python" } },
	autocmd = { enabled = true },
	action_kinds = { "quickfix", "refactor" },
	number = {
		enabled = true,
		-- Highlight group to highlight the number column if there is a lightbulb.
		hl = "LightBulbNumber",
	},
})

local telescope = require("telescope")

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<esc>"] = actions.close,
				["<c-i>"] = actions.to_fuzzy_refine,
			},
		},
	},

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
		},
	},
})
--lua require'telescope.builtin'.lsp_workspace_symbols({layout_config = { vertical = {
--width = function(_, max_columns)
--local percentage = 0.5
--local max = 70
--return math.min(math.floor(percentage * max_columns), max)
--end,
--height = function(_, _, max_lines)
--local percentage = 0.5
--local min = 70
--return math.max(math.floor(percentage * max_lines), min)
--end
--}}})

vim.keymap.set("n", "<esc>", "<esc>")
vim.keymap.set("i", "<esc>", "<esc>")
--lua require'telescope.builtin'.lsp_workspace_symbols({["layout_config.preview_width"]    = 0.8})
--lua telescope.builtin.lsp_workspace_symbols({layout_config.width   = 0.8})
--- Absolute path of the current node's directory
--- @return string|nil
local function node_dir_path()
	local api = require("nvim-tree.api")
	local node = api.tree.get_node_under_cursor()
	if not node then
		return
	end

	if node.parent and node.type == "file" then
		node = node.parent
	end

	return node.absolute_path
end

--require('fzf-lua').setup{}
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "_Q", vim.diagnostic.open_float, opts)
--vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
--vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "_q", vim.diagnostic.setloclist, opts)
local function opencwd()
	local api = require("nvim-tree.api")
	local pathb = vim.fn.getcwd()
	api.tree.open({ path = vim.fn.getcwd() })
	api.tree.change_root(pathb) --in case
end
vim.keymap.set("n", "mt", opencwd, opts)
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local cmp = require("cmp")

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
cmp.setup({
	--snippet = {
	---- REQUIRED - you must specify a snippet engine
	--expand = function(args)
	---- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
	---- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
	---- require('snippy').expand_snippet(args.body) -- For `snippy` users.
	--vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.

	--end,
	--},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),doc flags
		-- rep
	},
	mapping = cmp.mapping.preset.insert({
		["<C-e>"] = cmp.mapping.abort(),
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

		["<S-Tab>"] = cmp.mapping(function(fallback) -- inoremap <S-TAB> <esc><<^i
			if cmp.visible() then
				cmp.select_prev_item()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s" }),
		["<esc>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.abort()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "n", true)
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "n", true)
			end
		end),
		["<C-Y>"] = cmp.mapping.confirm({ select = false }), -- Confirm the selection even if not explicitly
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<C-CR>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({ select = true })
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "n", true)
			else
				fallback()
			end
		end),
	}),
	sources = cmp.config.sources({
		{ name = "buffer", priority = 1 },
		{ name = "path", proiority = 5 },
		{ name = "nvim_lsp", priority = 200 },
	}),
})
vim.api.nvim_create_autocmd("BufReadPre", {
	callback = function(t)
		if not BufIsBig(t.buf) then
			sources = cmp.config.sources({
				{ name = "buffer", priority = 1 },
				{ name = "path", priority = 5 },
				{ name = "nvim_lsp", priority = 200 },
			})
		else
            --vim.lsp.stop_client(vim.lsp.get_clients())
			cmp.setup.buffer({
				sources = {},
			})
            print("Buffer is big, stopping clients and setting up empty sources")  -- added here
            vim.api.nvim_echo({{'Buffer is big, stopping clients and setting up empty sources', 'Normal'}}, true, {})  -- added here

		end
	end,
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- Setup lspconfig.
-- cmp_nvim_lsp.
--local capabilities = require('cmp_nvim_lsp').default_capabilities()

--require'lspconfig'.sumneko_lua.setup{
--capabilities = capabilities,
--on_attach = on_attach,
--}

vim.lsp.set_log_level("debug")

--
--require'lspconfig'.jedi_language_server.setup{
--capabilities = capabilities,
--on_attach = on_attach
------root_dir = function() return vim.loop.cwd() end
--}

--vim.api.nvim_create_autocmd("FileType", {
--pattern = "python",
--callback = function()
--vim.lsp.start({
--name
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
require("refactoring").setup({})
--
local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.code_actions.refactoring,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.jq,
        null_ls.builtins.formatting.prettier,
        --null_ls.builtins.completion.spell,
    },
})
--require('lint').linters_by_ft = {
--py = {'black','mypy','isort',}
--}
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
require("which-key").setup({
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
})
require("chatgpt").setup({
	["chat.sessions_window.buf_options.cinkeys"] = "chatgpt",
	["popup_window.buf_options.cinkeys"] = "chatgpt",
	["settings_window.buf_options.cinkeys"] = "chatgpt",
	["popup_input.buf_options.cinkeys"] = "chatgptp",
	log_file = "C:\\users\\ekarni\\chatgptn.log",
})

local chatgpt = require("chatgpt")
wk = require("which-key")
wk.setup({ plugins = { presets = { operators = false } }, 
triggers_blacklist = { c = { "*" ,"%"}, v= { "*" } } 
})
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

local SORT_METHODS = {
	"name",
	"modification_time",
	"extension",
}
local sort_current = 1

local cycle_sort = function()
	local api = require("nvim-tree.api")
	if sort_current >= #SORT_METHODS then
		sort_current = 1
	else
		sort_current = sort_current + 1
	end
	print(SORT_METHODS[sort_current])
	api.tree.reload()
end

local sort_by = function()
	return SORT_METHODS[sort_current]
end

-- empty setup using defaults
local function grep_at_current_tree_node()
	local node = require("nvim-tree.lib").get_node_at_cursor()
	if not node then
		return
	end
	require("telescope.builtin").live_grep({ search_dirs = { node.absolute_path } })
end

local function my_on_attach(bufnr)
	local function find_files()
		local telescope = require("telescope")

		telescope.find_files({ search_dirs = { node_dir_path() } })
	end

	local function live_grep()
		local telescope = require("telescope")
		telescope.live_grep({ search_dirs = { node_dir_path() } })
	end
	local api = require("nvim-tree.api")

	local function global_cd_node_path()
		local node = api.tree.get_node_under_cursor()
		print(node.absolute_path)
		local fil = "aaa"
		if node == nil then
			fil = require("nvim-tree.core").get_cwd()
			--fil= vim.fn.get_line('.')
			--# remove last 3 letters
			--fil = string.sub(fil, 1, -4)
		elseif vim.fn.filereadable(node.absolute_path) == 2 then
			fil = node.absolute_path -- is dir
		else
			fil = vim.fn.fnamemodify(node.absolute_path, ":h")
		end

		vim.api.nvim_command("cd " .. fil)
	end

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	api.config.mappings.default_on_attach(bufnr)
	vim.keymap.del("n", "x", { buffer = bufnr })
	vim.keymap.del("n", "d", { buffer = bufnr })
	vim.keymap.del("n", "y", { buffer = bufnr })
	vim.keymap.del("n", "c", { buffer = bufnr })
	-- override a default
	vim.keymap.set("n", "<space>", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "zM", api.tree.collapse_all, opts("Collapse All"))
	vim.keymap.set("n", "zR", api.tree.expand_all, opts("Expand All"))
	vim.keymap.set("n", "X", api.fs.remove, opts("Del"))
	vim.keymap.set("n", "dd", api.fs.cut, opts("Cut"))
	vim.keymap.set("n", "yy", api.fs.copy.node, opts("Copy"))
	vim.keymap.set("n", "cn", api.fs.copy.filename, opts("Copy Name"))
	vim.keymap.set("n", "cd", global_cd_node_path, opts("Change Cwd"))
	vim.keymap.set("n", "/", function()
		vim.api.nvim_command("Fin -matcher=fuzzy")
	end, opts("Find"))
	vim.keymap.set("n", "<C-[>", api.tree.change_root_to_parent, opts("Goto Parent"))
	vim.keymap.set("n", "<left>", api.tree.change_root_to_parent, opts("Goto Parent"))
	vim.keymap.set("n", "<right>", api.tree.change_root_to_node, opts("Root to Node"))
	vim.keymap.set("n", "Mt", function()
		api.tree.change_root_to_node()
		timer.performWithDelay(1000, function()
			vim.api.nvim_command("Fin -matcher=fuzzy")
		end, 0)
	end, opts("TT"))
	vim.keymap.set("n", "S", cycle_sort, opts("Cycle Sort by"))

	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))

	vim.keymap.set("n", "f", find_files, opts("Find Files"))
	--vim.keymap.set('n', 'g',        live_grep,                          opts('Live Grep'))
	vim.keymap.set("n", "<Leader>gr", grep_at_current_tree_node, opts("Grep at current"))
	---
end

-- OR setup with some options
require("nvim-tree").setup({
	on_attach = my_on_attach,
	sort = {
		sorter = sort_by,
	},
	view = {
		width = 30,
	},
	renderer = {
		group_empty = true,
	},
	--actions = { change_dir = { global = true }},
	filters = {
		dotfiles = false,
		git_ignored = false,
	},
	live_filter = {
		prefix = "[FILTER]: ",
		always_show_folders = false,
	},
})

require("telescope").load_extension("git_grep")
--require('telescope').load_extension('projects')
--require('telescope').load_extension('fzf')
--function fuzzyFindFiles()
--builtin.grep_string({
--path_display = { 'smart' },
--only_sort_text = true,
--word_match = "-w",
--search = '',
--})
--end
require("wtf").setup()
--require("project_nvim").setup {
-- your configuration comes here
-- or leave it empty to use the default settings
-- refer to the configuration section below
--}C:\Users\ekarni\Neovim\bin

require("workspaces").setup({
	path = vim.fn.stdpath("data") .. "/workspaces",
	hooks = {
		open = function()
			set_workspace_dir(require("workspaces").path())
			print("workspace dir is " .. require("workspaces").path())
		end,
	},
})
require("actions-preview").setup({})
--require('mouse').setup()
--local configs = require'nvim-treesitter.configs'
--require'nvim-treesitter.configs'.setup {
    --matchup = {
        --enable = true, 
        --enable_quotes= true } }
--configs.get_module('matchup').enable_quotes= true
--vim.keymap.set('n', '<C-g>', '<cmd>lua fuzzyFindFiles{}<cr>', {})
