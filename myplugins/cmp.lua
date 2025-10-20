-- CMP (completion) plugin configuration for Lazy.nvim
return {
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{
				"uga-rosa/cmp-dictionary",
				config = function()
					require("cmp_dictionary").setup({
						dic = {
							["*"] = { "c:\\temp\\words" },
							spelllang = {
								en_us = "c:\\temp\\words",
							},
						},
					})
				end,
			},
		},
		config = function()
			local cmp = require("cmp")

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-e>"] = cmp.mapping.abort(),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<esc>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.abort()
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<esc>", true, true, true),
								"n",
								true
							)
						else
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<esc>", true, true, true),
								"n",
								true
							)
						end
					end),
					["<C-Y>"] = cmp.mapping.confirm({ select = false }), 
				["<M-CR>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = false })
						vim.api.nvim_feedkeys(
							vim.api.nvim_replace_termcodes("<CR>", true, true, true),
							"n",
							true
						)
					else
						fallback()
					end
				end), 

					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<esc>", true, true, true),
								"n",
								true
							)
						else
							fallback()
						end
					end),
				}),
				sources = cmp.config.sources({
					{ name = "buffer", priority = 1 },
					{ name = "path", priority = 5 },
					{ name = "nvim_lsp", priority = 200 },
				}),
			})

			-- Auto-disable cmp for large buffers
			vim.api.nvim_create_autocmd("BufReadPre", {
				callback = function(t)
					if not BufIsBig(t.buf) then
						cmp.setup.buffer({
							sources = cmp.config.sources({
								{ name = "buffer", priority = 1 },
								{ name = "path", priority = 5 },
								{ name = "nvim_lsp", priority = 200 },
							}),
						})
					else
						cmp.setup.buffer({
							sources = {},
						})
						print("Buffer is big, disabling cmp sources")
						vim.api.nvim_echo({
							{ "Buffer is big, disabling cmp sources", "Normal" },
						}, true, {})
					end
				end,
			})

			-- Set configuration for specific filetype.
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "cmp_git" },
				}, {
					{ name = "buffer" },
				}),
			})

			-- Use buffer source for `/`
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':'
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

		end,
	},
}
