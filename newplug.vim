
function! PathExpand(path)
    return fnameescape(expand(a:path))
endfunction


let g:pluginInstallPath = "~/.vim/plugged"
" First source this gist:
exe "source ". " ". PathExpand(g:vimloc . "/env/editors/vim/manage_plugins.vim")
if !has('nvim')
    call plug#begin(g:pluginInstallPath)
endif
Plugit 'ipod825/vim-bookmark'
Plugit 'navarasu/onedark.nvim'
Plugit 'nvim-lua/plenary.nvim'
Plugit 'antoinemadec/FixCursorHold.nvim'
Plugit 'MunifTanjim/nui.nvim', {'event': 'VeryLazy'}
Plugit 'powerman/vim-plugin-AnsiEsc'
Plugit 'easymotion/vim-easymotion'
Plugit 'hgiesel/vim-motion-sickness'
Plugit 'vim-scripts/ingo-library'
Plugit 'vim-scripts/EnhancedJumps'
Plugit 'jeetsukumaran/vim-indentwise'
Plugit 'andymass/vim-matchup'
Plugit 'wellle/targets.vim'
Plugit 'tpope/vim-surround'
Plugit 'scrooloose/nerdcommenter'
Plugit 'PeterRincker/vim-argumentative'
Plugit 'mg979/vim-visual-multi'
Plugit 'tpope/vim-fugitive'
Plugit 'airblade/vim-gitgutter'
Plugit 'tpope/vim-repeat'
Plugit 'davvid/telescope-git-grep.nvim'
Plugit 'nvim-tree/nvim-tree.lua'
Plugit 'lambdalisue/fin.vim'
Plugit 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugit 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
Plugit 'yegappan/mru'
Plugit 'tamago324/nlsp-settings.nvim'
Plugit 'github/copilot.vim', {'event': 'VeryLazy'}
Plugit 'sheepy9/gipity.nvim', {'event':'VeryLazy'}
Plugit 'nvimtools/none-ls.nvim'
Plugit 'junegunn/fzf.vim'
Plugit 'nvim-telescope/telescope.nvim', {'event': 'VeryLazy'}
Plugit 'nvim-telescope/telescope-symbols.nvim'
Plugit 'nvim-telescop/telescope-live-grep-args.nvim'
Plugit 'ggandor/lightspeed.nvim'
Plugit 'mbbill/undotree'
Plugit 'kassio/neoterm'
Plugit 'folke/which-key.nvim'
Plugit 'PProvost/vim-ps1'
Plugit 'kana/vim-textobj-user'
Plugit 'SmiteshP/nvim-navic'
Plugit 'hasansujon786/nvim-navbuddy', {'event': 'VeryLazy'}
Plugit 'slim-template/vim-slim'
Plugit 'octol/vim-cpp-enhanced-highlight'
"Plugit 'WolfgangMehner/bash-support'
"Plugit 'nvim-treesitter/nvim-treesitter',
"Plugit 'nvim-treesitter/nvim-treesitter-refactor'
"Plugit 'ray-x/guihua.lua', {'do': 'cd lua\fzy && make' }
"Plugit 'ray-x/navigator.lua', {'event': 'VeryLazy'}

"==============================================================================
" UTILITIES
"==============================================================================
" Miscellaneous useful tools
Plugit 'simnalamburt/vim-mundo'
Plugit 'sjl/gundo.vim'
Plugit 'tmhedberg/SimpylFold'
if !has('nvim')
    call plug#end()
endif
