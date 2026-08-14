return {
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    },
    --{ "girishji/pythondoc.vim" },
    --{ "vim-scripts/LargeFile" },
    {
        "luckasRanarison/nvim-devdocs",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {},
		enabled=false,
    },
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- calling `setup` is optional for customization
            require("fzf-lua").setup({
                winopts = {
                    width  = 0.95,
                    height = 0.90,
                    row    = 0.50,
                    col    = 0.50,
                    preview = {
                        layout     = "horizontal",
                        horizontal = "right:55%",
                    },
                },
                files = {
                    -- show hidden files, exclude diff/patch files
                    cmd = "rg --files --hidden --glob '!*.diff' --glob '!*.patch'",
                },
            })
        end,
    },
    {
        "m-gail/diagnostic_manipulation.nvim",
        event = "VeryLazy",
        init = function()
            require("diagnostic_manipulation").setup({
                blacklist = {
                    function(diagnostic)
                        return string.find(diagnostic.message, "Undefined global `vim`") or string.find(diagnostic.message, "is not a known attribute of \"None\"") or string.find(diagnostic.message, "Try to avoid using")
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
                return vim.uv.cwd()
            end

            require("lualine").setup({
                options = { path = 1 },
                sections = {
                    lualine_c = { "filename", [[ | ]], hello },
                    lualine_d = {
                        function()
                            return vim.b.autosave and "Autosave On" or "Autosave Off"
                        end,
                    },
                },
            })
        end,
    },
    --{import = "plugins" },
    --{ "rafamadriz/friendly-snippets" },
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
    },
    {
    "robitx/gp.nvim",
    enabled=false,
    config = function()
        local conf = {
            agents=
            {
                { 
                    provider = "openai", 
                    name = "CodeGPT4o-mini", 
                    chat = true, 
                    command = true, 
                    -- string with model name or table with model name and parameters 
                    model = { model = "gpt-4o-mini", temperature = 0.7, top_p = 1 }, 
                    -- system prompt (use this to specify the persona/role of the AI) 
                    system_prompt = "Please return ONLY code snippets.\nSTART AND END YOUR ANSWER WITH:\n\n```", 
                },   { 
                    provider = "openai", 
                    name = "GPT5", 
                    chat = true, 
                    openai_api_key = os.getenv("OPENAI_API_KEY"),
                    command = true, 
                    -- string with model name or table with model name and parameters 
                    model = { model = "gpt-5", temperature = 0.7, top_p = 1 }, 
                    -- system prompt (use this to specify the persona/role of the AI) 
                    system_prompt = "Please return ONLY code snippets.\nSTART AND END YOUR ANSWER WITH:\n\n```", 
                },
            }
            -- For customization, refer to Install > Configuration in the Documentation/Readme
        }
        require("gp").setup(conf)

        -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
    end,
    }, --[[{]]
    --[["greggh/claude-code.nvim",]]
    --[[dependencies = {]]
      --[["nvim-lua/plenary.nvim", -- Required for git operations]]
    --[[},]]
    --[[config = function()]]
      --[[require("claude-code").setup({ keymaps = {]]
    --[[toggle = {]]
      --[[normal = "<C-,>",       -- Normal mode keymap for toggling Claude Code, false to disable]]
      --[[terminal = "<C-,>",     -- Terminal mode keymap for toggling Claude Code, false to disable]]
      --[[variants = {]]
        --[[continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag]]
        --[[verbose = "<leader>cV",  -- Normal mode keymap for Claude Code with verbose flag]]
      --[[},]]
    --[[}} })]]
    --[[end]]
  --[[}]]
  {
  "coder/claudecode.nvim",
  dependencies = {  },
  config = true,
  lazy = false,
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>aS", "<cmd>call CloseClaudeBufferInWindow()<cr><cmd>ClaudeCodeStart!<cr>", desc = "Claude Force Start" },
    { "<leader>av", "<cmd>lua ClaudeVSplit()<cr>", desc = "Claude in vsplit" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    { "<c-b>", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
    },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
  } ,{
  "okuuva/auto-save.nvim",
  version = '^1.0.0', -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release 
  cmd = "ASToggle", -- optional for lazy loading on command
  event = { "InsertLeave", "TextChanged","BufEnter" }, -- optional for lazy loading on trigger events
  opts = {
 condition = function(buf)
    -- Check buffer-local and global auto_save variables
    local b_auto_save = vim.b[buf].auto_save
    local g_auto_save = vim.g.auto_save

    -- If buffer-local variable is explicitly set, use it
    if b_auto_save ~= nil then
      if not b_auto_save then
        return false
      end
    -- Otherwise, check global variable
    elseif g_auto_save ~= nil then
      if not g_auto_save then
        return false
      end
    end

    -- Exclude claudecode diff buffers by buffer name patterns
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname:match('%(proposed%)') or bufname:match('%(NEW FILE %- proposed%)') or bufname:match('%(New%)') then
      return false
    end

    -- Exclude by buffer variables (claudecode sets these)
    if
      vim.b[buf].claudecode_diff_tab_name
      or vim.b[buf].claudecode_diff_new_win
      or vim.b[buf].claudecode_diff_target_win
    then
      return false
    end

    -- Exclude by buffer type (claudecode diff buffers use "acwrite")
    local buftype = vim.fn.getbufvar(buf, '&buftype')
    if buftype == 'acwrite' then
      return false
    end

    return true -- Safe to auto-save
  end
    -- your config goes here
    -- or just leave it empty :)
  },
},{
"folke/snacks.nvim",
enabled = false,
priority = 1000,
lazy = false,
---@type snacks.Config
opts = {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  terminal = {enabled=false },
  bigfile = { enabled = true },
  dashboard = { enabled = false },
  explorer = { enabled = false },
  indent = { enabled = true },
  input = { enabled = true },
  picker = { enabled = true },
  notifier = { enabled = false },
  quickfile = { enabled = false },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
},
},
{
    "aznhe21/actions-preview.nvim",
    event = "VeryLazy",
    config = function()
        require("actions-preview").setup()
    end,
},
{
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
        { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document Diagnostics (Trouble)" },
        { "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics (Trouble)" },
        { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
        { "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", desc = "LSP References (Trouble)" },
        { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
        { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ..." },
        { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
    },
},
{
  "nvim-telescope/telescope-frecency.nvim",
  -- install the latest stable version
  version = "*",
  config = function()
    require("telescope").setup {
      extensions = {
        frecency = {
          db_safe_mode = false,
        },
      },
    }
    require("telescope").load_extension "frecency"
  end,
}

}
