

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

-- Print LSP capabilities for a given server
-- Usage: PrintLspCapabilities('jedi_language_server')
function _G.PrintLspCapabilities(server_name)
	local lspconfig = require('lspconfig')
	if not lspconfig[server_name] then
		print("LSP server '" .. server_name .. "' not found in lspconfig")
		return
	end

	local manager = lspconfig[server_name].manager
	if manager and manager.config and manager.config.capabilities then
		print("Capabilities for " .. server_name .. ":")
		print(vim.inspect(manager.config.capabilities))
	else
		print("No active manager or capabilities found for " .. server_name)
		print("The server might not be running yet. Try opening a file that uses this LSP.")
	end
end

-- Print LSP config for a given server
-- Usage: PrintLspConfig('jedi_language_server')
function _G.PrintLspConfig(server_name)
	local lspconfig = require('lspconfig')
	if not lspconfig[server_name] then
		print("LSP server '" .. server_name .. "' not found in lspconfig")
		return
	end

	local manager = lspconfig[server_name].manager
	if manager and manager.config then
		print("Config for " .. server_name .. ":")
		print(vim.inspect(manager.config))
	else
		print("No active manager or config found for " .. server_name)
		print("The server might not be running yet. Try opening a file that uses this LSP.")
	end
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
--require("grammar-guard").init()
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
				["<c-j>"] = require('telescope.actions').move_selection_next,
				["<c-k>"] = require('telescope.actions').move_selection_previous,
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

-- nnoremap TN <nowait> :tabnew<CR> add this as lua 
vim.keymap.set("n", "TN", ":tabnew<CR>", {  silent = true })

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
-- CMP configuration has been moved to myplugins/cmp.lua (loaded via Lazy.nvim)

vim.lsp.set_log_level("debug")

--
-- require'lspconfig'.jedi_language_server.setup{
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
        null_ls.builtins.diagnostics.proselint,
        null_ls.builtins.completion.spell, --toremove
    },
})
--require('lint').linters_by_ft = {
--py = {'black','mypy','isort',}
--}
-- cmp_dictionary setup has been moved to myplugins/cmp.lua (loaded via Lazy.nvim)
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
	vim.keymap.set("n", "<M-right>", function()
		local api = require("nvim-tree.api")
		local node = api.tree.get_node_under_cursor()
		if node and (node.type == "directory" or (node.parent and node.type == "file")) then
			local target_dir = node.type == "directory" and node.absolute_path or node.parent.absolute_path
			api.tree.change_root_to_node()
			vim.schedule(function()
				vim.api.nvim_command("Fin -matcher=fuzzy")
			end)
		end
	end, opts("Navigate into directory and Find"))
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
--
--
--add lua that when enter buffer, updates c:\temp\active_buffer with the file name (if there is ) 
vim.api.nvim_create_autocmd('BufEnter', {
pattern = '*',
callback = function()
local filename = vim.api.nvim_buf_get_name(0)
if filename ~= '' then
local file = io.open('c:\\temp\\active_buffer', 'w')
if file then
file:write(filename)
file:close()
end
end
end
})
