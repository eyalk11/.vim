return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
      debug= false,
      provider = "claudet",
      cursor_applying_provider = 'openai',
      vendors = {
    },
    providers= {
        ggrok = {
            __inherited_from = "openai",
            model= "grok-2-latest",
            endpoint="https://api.x.ai/v1",
            api_key_name ="GROK_API_KEY",
            max_tokens = 131072
        },
        claude37 = {

        __inherited_from = "claude",
        model = "claude-3-7-sonnet-latest",
        disable_tools = true,

        },

        claude = {

            model = "claude-sonnet-4-20250514",

        },claudet = {
            __inherited_from = "claude",
            disable_tools = true,

        model = "claude-sonnet-4-20250514",

    },

    },
      behaviour = {
      --- ... existing behaviours
      enable_cursor_planning_mode = false, -- enable cursor planning mode!
  },
  

  --grok = { 
      --model= "grok-2-latest",
      --endpoint="https://api.x.ai/v1",
      --api_key_name ="GROK_API_KEY",
    --max_tokens = 131072
  --},
      auto_suggestions_provider = nil,--"copilot",
    -- add any opts here
    web_search_engine = {
      provider = "google", -- tavily, serpapi, searchapi, google or kagi
    },
    rag_service = {
      enabled = false, -- Enables the rag service, requires OPENAI_API_KEY to be set
    },

-- 
  },
  keys = {
    { "<leader>ac", ":AvanteClear<CR>", desc = "Clear Avante" }
  },

  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --build = "make",
 build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false", -- for windows
  dependencies = {
    --"nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
