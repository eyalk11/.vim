return {
        'milanglacier/minuet-ai.nvim',
        enabled=true,
        event = { 'BufReadPre' },
        config = function()
            require('minuet').setup {
                provider = 'claude',
                request_timeout = 2,
                throttle = 2000,
                virtualtext = {
                    auto_trigger_ft = { 'lua', 'python', 'javascript', 'typescript', 'vim', 'go', 'rust', 'c', 'cpp' ,'tex','markdown'},
                    keymap = {
                        accept = '<C-j>',
                        accept_line = '<M-w>',
                        accept_n_lines = '<M-n>',
                        prev = '<M-[>',
                        next = '<M-j>',
                        dismiss = '<esc>'
                    },
                    show_on_completion_menu = true,
                },
                notify = 'error',
                provider_options = {
                    gemini = {
                        api_key="GOOGLE_GEMINI_API",
                        optional = {
                            generationConfig = {
                                maxOutputTokens = 256,
                                topP = 0.9,
                            },
                            safetySettings = {
                                --{
                                    --category = 'HARM_CATEGORY_DANGEROUS_CONTENT',
                                    --threshold = 'BLOCK_NONE',
                                --},
                                --{
                                    --category = 'HARM_CATEGORY_HATE_SPEECH',
                                    --threshold = 'BLOCK_NONE',
                                --},
                                --{
                                    --category = 'HARM_CATEGORY_HARASSMENT',
                                    --threshold = 'BLOCK_NONE',
                                --},
                                --{
                                    --category = 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
                                    --threshold = 'BLOCK_NONE',
                                --},
                            },
                        },
                    },
                    claude = {
                        max_tokens = 556,
                        model = 'claude-haiku-4-5',
                        stream = true,
                        api_key = 'ANTHROPIC_MINUET_API_KEY',
                    }
                },
            }
        end,
    }
