return {
        'milanglacier/minuet-ai.nvim',
        enabled=false,
        event = { 'BufReadPre' },
        config = function()
            require('minuet').setup {
                provider = 'gemini',
                request_timeout = 2,
                throttle = 2000,
                virtualtext = {
                    auto_trigger_ft = { 'lua', 'python', 'javascript', 'typescript', 'vim', 'go', 'rust', 'c', 'cpp' },
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
                    codestral = {
                        optional = {
                            stop = { '\n\n' },
                            max_tokens = 256,
                        },
                    },
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
                    openai = {
                        optional = {
                            max_tokens = 256,
                            top_p = 0.9,
                        },
                    },
                    openai_compatible = {
                        api_key = 'OPENROUTER_API_KEY',
                        end_point = 'https://openrouter.ai/api/v1/chat/completions',
                        model = 'mistralai/devstral-small',
                        name = 'Openrouter',
                        optional = {
                            max_tokens = 56,
                            top_p = 0.9,
                            provider = {
                                -- Prioritize throughput for faster completion
                                sort = 'throughput',
                            },
                        },
                    },
                },
            }
        end,
    }
