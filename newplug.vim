
function! PathExpand(path)
    return fnameescape(expand(a:path))
endfunction


let g:pluginInstallPath = "~/.vim/plugged"
" First source this gist:
exe "source ". " ". PathExpand(g:vimloc . "/env/editors/vim/manage_plugins.vim")
if !has('nvim')
    call plug#begin(g:pluginInstallPath)
endif

"==============================================================================
" PLUGIN ORGANIZATION
"==============================================================================
" Core/Dependencies - Essential plugins that others depend on
" UI/Appearance - Themes, statuslines, and visual enhancements
" Navigation/Motion - Movement, jumping, and navigation plugins
" Editing/Text Objects - Text manipulation and objects
" Git - Git integration tools
" File Management - File browsers and managers
" Search/Fuzzy Finding - Search and fuzzy finding tools
" LSP/Completion - Language servers and code completion
" Language Specific - Support for specific programming languages
" Utilities - Miscellaneous useful tools
"==============================================================================
Plugit 'madox2/vim-ai'
"==============================================================================
" CORE DEPENDENCIES
"==============================================================================
" Essential plugins that others depend on
Plugit 'nvim-lua/plenary.nvim'
Plugit 'MunifTanjim/nui.nvim', {'event': 'VeryLazy'}
Plugit 'inkarkat/vim-ingo-library'
Plugit 'antoinemadec/FixCursorHold.nvim'
Plugit 'ZSaberLv0/ZFVimJob', {'event': 'VeryLazy'}
Plugit 'ZSaberLv0/ZFVimIgnore', {'event': 'VeryLazy'}
Plugit 'rbgrouleff/bclose.vim'
Plugit 'kana/vim-textobj-user'

"==============================================================================
" UI/APPEARANCE
"==============================================================================
" Themes, statuslines, and visual enhancements
Plug 'navarasu/onedark.nvim'
"Plugit 'joshdick/onedark.vim'
if !has('nvim')
    Plugit 'powerline/powerline'
else
    "Plugit 'vim-airline/vim-airline-themes'
    "Plugit 'vim-airline/vim-airline'
endif
Plugit 'nvim-tree/nvim-web-devicons'
"Plugit 'kyazdani42/nvim-web-devicons'
"Plugit 'xiyaowong/transparent.nvim'
Plugit 'powerman/vim-plugin-AnsiEsc'
Plugit 'kamykn/popup-menu.nvim'
Plugit 'kosayoda/nvim-lightbulb'
"Plugit 'rafi/awesome-vim-colorschemes'

"==============================================================================
" NAVIGATION/MOTION
"==============================================================================
" Movement, jumping, and navigation plugins
Plugit 'easymotion/vim-easymotion'
Plugit 'ggandor/lightspeed.nvim'
"Plugit 'rhysd/clever-f.vim'
"Plugit 'justinmk/vim-sneak'
"Plugit 'unblevable/quick-scope'
Plugit 'hgiesel/vim-motion-sickness'
Plugit 'wellle/targets.vim'
Plugit 'vim-scripts/EnhancedJumps'
Plugit 'jeetsukumaran/vim-indentwise'
Plugit 'andymass/vim-matchup'
"Plugit 'Houl/vim-repmo'
"Plugit 'airblade/vim-matchquote'

"==============================================================================
" EDITING/TEXT OBJECTS
"==============================================================================
" Text manipulation and objects
Plugit 'tpope/vim-surround'
Plugit 'tpope/vim-repeat'
Plugit 'numToStr/Comment.nvim'
Plugit 'scrooloose/nerdcommenter'
Plugit 'PeterRincker/vim-argumentative'
Plugit 'AndrewRadev/sideways.vim'
Plugit 'mg979/vim-visual-multi'
"Plugit 'kana/vim-textobj-function'
"Plugit 'sickill/vim-pasta'
Plugit '907th/vim-auto-save'
Plugit 'kana/vim-arpeggio'
Plugit 'matze/vim-tex-fold'
"Plugit 'mg979/vim-yanktools'
"Plugit 'junegunn/vim-peekaboo'

"==============================================================================
" GIT
"==============================================================================
" Git integration tools
Plugit 'tpope/vim-fugitive'
Plugit 'airblade/vim-gitgutter'
Plugit 'sindrets/diffview.nvim'
Plugit 'davvid/telescope-git-grep.nvim'

"==============================================================================
" FILE MANAGEMENT
"==============================================================================
" File browsers and managers
Plugit 'nvim-tree/nvim-tree.lua'
Plugit 'eiginn/netrw'
"Plugit 'scrooloose/nerdtree'
"Plugit 'ipod825/vim-netranger'
"Plugit 'francoiscabrol/ranger.vim'
Plugit 'will133/vim-dirdiff', {'event': 'VeryLazy'}
Plugit 'ZSaberLv0/ZFVimDirDiff', {'event': 'VeryLazy'}
Plugit 'ZSaberLv0/ZFVimBackup', {'event': 'VeryLazy'}
Plugit 'natecraddock/workspaces.nvim', {'event': 'VeryLazy'}
Plugit 'lambdalisue/fin.vim'
"Plugit 'ahmedkhalf/project.nvim'
"tpope/vim-eunuch.git best in linux env I guess...

"==============================================================================
" SEARCH/FUZZY FINDING
"==============================================================================
" Search and fuzzy finding tools
Plugit 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugit 'junegunn/fzf.vim'
Plugit 'nvim-telescope/telescope.nvim', {'event': 'VeryLazy'}
Plugit 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plugit 'nvim-telescope/telescope-symbols.nvim'
Plugit 'nvim-telescope/telescope-live-grep-args.nvim'
Plugit 'dyng/ctrlsf.vim'
Plugit 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
"Plugit 'ibhagwan/fzf-lua', {'branch': 'main'}
"Plugit 'ctrlpvim/ctrlp.vim'
"Plugit 'ggvgc/vim-fuzzysearch'
Plugit 'yegappan/mru'
Plugit 'viniciusarcanjo/fzf-tabs.nvim'

"==============================================================================
" LSP/COMPLETION
"==============================================================================
" Language servers and code completion
Plugit 'hrsh7th/nvim-cmp', { 'branch': 'main'}
Plugit 'hrsh7th/cmp-nvim-lsp'
Plugit 'hrsh7th/cmp-path'
Plugit 'hrsh7th/cmp-cmdline'
"Plugit 'hrsh7th/cmp-buffer'
"Plugit 'ray-x/cmp-treesitter'
Plugit 'uga-rosa/cmp-dictionary'
Plugit 'quangnguyen30192/cmp-nvim-ultisnips'
Plugit 'tamago324/nlsp-settings.nvim'
"Plugit 'williamboman/mason.nvim'
"Plugit 'williamboman/mason-lspconfig.nvim'
"Plugit 'williamboman/nvim-lsp-installer'
"Plugit 'neovim/nvim-lspconfig'
Plugit 'nvimtools/none-ls.nvim'
"Plugit 'mfussenegger/nvim-lint'
Plugit 'SirVer/ultisnips'
Plugit 'honza/vim-snippets'
Plugit 'ludovicchabant/vim-gutentags'
Plugit 'SmiteshP/nvim-navic'
Plugit 'SmiteshP/nvim-navbuddy', {'event': 'VeryLazy'}
Plugit 'stevearc/aerial.nvim'
Plugit 'folke/trouble.nvim'
Plugit 'folke/which-key.nvim'
"Plugit 'liuchengxu/vim-which-key'
"Plugit 'folke/lazy.nvim'
Plugit 'github/copilot.vim', {'event': 'VeryLazy'}
Plugit 'jackMort/ChatGPT.nvim', {'event': 'VeryLazy'}
Plugit 'piersolenski/wtf.nvim'
Plugit 'aznhe21/actions-preview.nvim'
Plugit 'ThePrimeagen/refactoring.nvim'
"Plugit 'simrat39/symbols-outline.nvim'
"Plugit 'Shougo/neco-vim'
"Plugit 'neoclide/coc-neco'
"Plugit 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
"Plugit 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugits' }
"Plugit 'ervandew/supertab'
"Plugit 'sbdchd/neoformat'
"Plugit 'craigemery/vim-autotag'
"Plugit 'valloric/youcompleteme'
Plugit 'rdnetto/YCM-Generator', { 'branch': 'stable'}

"==============================================================================
" LANGUAGE SPECIFIC
"==============================================================================
" Support for specific programming languages
Plugit 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plugit 'jeetsukumaran/vim-pythonsense'
Plugit 'Vimjas/vim-python-pep8-indent'
Plugit 'relastle/vim-nayvy'
"Plugit 'python-rope/ropevim'
Plugit 'lervag/vimtex'
Plugit 'hashivim/vim-terraform'
Plugit 'udalov/kotlin-vim'
Plugit 'PProvost/vim-ps1'
Plugit 'slim-template/vim-slim'
Plugit 'octol/vim-cpp-enhanced-highlight'
"Plugit 'WolfgangMehner/bash-support'
Plugit 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Plugit 'nvim-treesitter/nvim-treesitter-refactor'
"Plugit 'ray-x/guihua.lua', {'do': 'cd lua\fzy && make' }
"Plugit 'ray-x/navigator.lua', {'event': 'VeryLazy'}

"==============================================================================
" UTILITIES
"==============================================================================
" Miscellaneous useful tools
Plugit 'mbbill/undotree'
Plugit 'simnalamburt/vim-mundo'
Plugit 'sjl/gundo.vim'
Plugit 'tmhedberg/SimpylFold'
Plugit 'ipod825/vim-bookmark'
Plugit 'kassio/neoterm'
Plugit 'bfredl/nvim-ipy'
Plugit 'lkhphuc/jupyter-kernel.nvim', {'event':'VeryLazy'}
Plugit 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugits' }
Plugit 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plugit 'mhinz/neovim-remote'
Plugit 'puremourning/vimspector'
Plugit 'rbtnn/vim-vimscript_lasterror'
Plugit 'blblb/speech-to-text.nvim'
Plugit 'brymer-meneses/grammar-guard.nvim'
Plugit 'Sheker/mouse_scrolling'
"Plugit 'rhysd/vim-grammarous'
"Plugit 'inkarkat/vim-SpellCheck'
"Plugit 'echuraev/translate-shell.vim', { 'do': 'wget -O ~/.vim/trans git.io/trans && chmod +x ~/.vim/trans' }
"Plugit 'AndrewRadev/undoquit.vim'
"Plugit 'Shougo/denite.nvim'
"Plugit 'tc50cal/vim-terminal'
"Plugit 'brettanomyces/nvim-terminus'
"Plugit 'vim-ctrlspace/vim-ctrlspace'
"Plugit 'benknoble/popsikey'
"Plugit 'jacob-ogre/vim-syncr' RSYNC
"Plugit 'jlanzarotta/bufexplorer'
"Plugit 'dense-analysis/ale'
"Plugit 'w0rp/ale'

if or(or(has('python_dynamic'),has('python')),has('python3'))
    " Python-dependent plugins
    Plugit 'tpope/vim-surround'
    Plugit 'tmhedberg/SimpylFold'
    Plugit 'inkarkat/vim-ingo-library'
endif

if !has('nvim')
    call plug#end()
endif


