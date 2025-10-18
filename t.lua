vim.opt.rtp:prepend(vim.fn.expand("~/.vim"))
require("lazy").setup({
	--moduledir = "c:\\users\\ekarni\\.vim\\",
	root = vim.g.pluginInstallPath, -- share plugin folder with Plug
	defaults = {
		lazy = false, -- should plugins be lazy-loaded?
		version = false,
	},
	--, performance = { rtp = {reset_packpath = false , paths = {vim.fn.expand( '~/.vim/plugged')  }}},  
	spec = {
		{ import = "plugins.noice" },
		--{ import = "plugins.repmo" },
		{ import = "plugins.lspconfig" },
		{ import = "plugins.avante" },
		{ import = "plugins.cmp" },
		{ import =  "plugins.lazyplugs" },
		-- just for the colorscheme
		LazyPlugSpecs,
	},
})
