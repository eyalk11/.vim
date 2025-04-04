
function! PathExpand(path)
    return fnameescape(expand(a:path))
endfunction


let g:pluginInstallPath = "~/.vim/plugged"
" First source this gist:
exe "source ". " ". PathExpand(g:vimloc . "/env/editors/vim/manage_plugins.vim")
if !has('nvim')
    call plug#begin(g:pluginInstallPath)
endif
" Keys will do nothing in vim, but will create lazyLoad keys for lazy.nvim.
"Plugit 'wellle/targets.vim', {
"            \ 'keys': MakeLazyKeys({
"            \ 'n': ['[', ']'],
"            \ 'ov': ['i,', 'a', 'I', 'A'],
"            \ })}
"
Plugit 'aznhe21/actions-preview.nvim'
Plugit 'will133/vim-dirdiff', {'event': 'VeryLazy'}
Plugit 'ZSaberLv0/ZFVimDirDiff', {'event': 'VeryLazy'}
Plugit 'ZSaberLv0/ZFVimJob' , {'event': 'VeryLazy'}
" required
Plugit 'ZSaberLv0/ZFVimIgnore' , {'event': 'VeryLazy'}
" optional, but recommended for auto ignore setup
Plugit 'ZSaberLv0/ZFVimBackup' , {'event': 'VeryLazy'}
" optional, but recommended for auto backup
Plugit 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plugit 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

Plugit 'tamago324/nlsp-settings.nvim'
"Plugit 'williamboman/mason.nvim'
"Plugit 'williamboman/mason-lspconfig.nvim'


" Vim Script
"Plugit 'ahmedkhalf/project.nvim'

Plugit 'piersolenski/wtf.nvim'
Plugit 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

Plugit 'dyng/ctrlsf.vim'

Plugit 'lkhphuc/jupyter-kernel.nvim' , {'event':'VeryLazy'}
Plugit 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugits' }

Plugit 'davvid/telescope-git-grep.nvim'
"Plugit 'python-rope/ropevim'
Plugit 'ThePrimeagen/refactoring.nvim'
Plugit 'AndrewRadev/sideways.vim'
Plugit 'nvimtools/none-ls.nvim'
"Plugit 'mfussenegger/nvim-lint'
Plugit 'ludovicchabant/vim-gutentags'
Plugit 'nvim-telescope/telescope-live-grep-args.nvim'
Plugit 'SmiteshP/nvim-navic'
Plugit 'numToStr/Comment.nvim'        
" Optional
Plugit 'SmiteshP/nvim-navbuddy', {'event': 'VeryLazy'}
"Plugit 'simrat39/symbols-outline.nvim'
Plugit 'folke/trouble.nvim'
Plugit 'lambdalisue/fin.vim'
Plugit 'relastle/vim-nayvy'
"Plugit 'sickill/vim-pasta'
"Plugit 'xiyaowong/transparent.nvim'
Plugit 'blblb/speech-to-text.nvim'
"Plugit 'sbdchd/neoformat'
Plugit 'MunifTanjim/nui.nvim' , {'event': 'VeryLazy'}
Plugit 'jackMort/ChatGPT.nvim' , {'event': 'VeryLazy'}
Plugit 'kosayoda/nvim-lightbulb'
Plugit 'antoinemadec/FixCursorHold.nvim'
Plugit 'github/copilot.vim' , {'event': 'VeryLazy'}
Plugit 'ggandor/lightspeed.nvim'
"Plugit 'rhysd/clever-f.vim'
"Plugit 'craigemery/vim-autotag'
Plugit 'kana/vim-arpeggio'
Plugit 'sindrets/diffview.nvim'
"Plugit 'tc50cal/vim-terminal'

"Plugit 'ibhagwan/fzf-lua', {'branch': 'main'}
" optional for icon support
"plug 'brettanomyces/nvim-terminus'
Plugit 'natecraddock/workspaces.nvim', {'event': 'VeryLazy'}
Plugit 'brymer-meneses/grammar-guard.nvim'
"Plugit 'kyazdani42/nvim-web-devicons'
"Plugit 'ray-x/guihua.lua', {'do': 'cd lua\fzy && make' }
"Plugit 'ray-x/navigator.lua', {'event': 'VeryLazy'}
"Plugit 'nvim-treesitter/nvim-treesitter-refactor'
"Plugit 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plugit 'nvim-lua/plenary.nvim'
Plugit 'nvim-telescope/telescope.nvim', {'event': 'VeryLazy'}
Plugit 'nvim-telescope/telescope-symbols.nvim'
Plugit 'stevearc/aerial.nvim'
"Plugit 'williamboman/nvim-lsp-installer'
"Plugit 'neovim/nvim-lspconfig'
Plugit 'hrsh7th/cmp-nvim-lsp'
"Plugit 'hrsh7th/cmp-buffer'
Plugit 'hrsh7th/cmp-path'
Plugit 'hrsh7th/cmp-cmdline'
"Plugit 'ray-x/cmp-treesitter'
Plugit 'uga-rosa/cmp-dictionary'
Plugit 'hrsh7th/nvim-cmp', { 'branch': 'main'}
Plugit 'quangnguyen30192/cmp-nvim-ultisnips'
"tpope/vim-eunuch.git best in linux env I guess...
"Plugit 'justinmk/vim-sneak'
"Plugit 'unblevable/quick-scope'
"Plugit 'liuchengxu/vim-which-key'
"Plugit 'folke/lazy.nvim'
Plugit 'folke/which-key.nvim' 
Plugit 'kamykn/popup-menu.nvim'
"Peek at registers before pasting
"Plugit 'junegunn/vim-peekaboo'
Plugit 'PeterRincker/vim-argumentative'
"match inner blocks and z% 
"Plugit 'andymass/vim-matchup'
"Plugit 'scrooloose/nerdtree'
"match strings 
"Plugit 'airblade/vim-matchquote'
"Plugit 'ggvgc/vim-fuzzysearch'
"Plugit 'benknoble/popsikey'
"Plugit 'jacob-ogre/vim-syncr' RSYNC
"Plugit 'inkarkat/vim-SpellCheck'
"Plugit 'echuraev/translate-shell.vim', { 'do': 'wget -O ~/.vim/trans git.io/trans && chmod +x ~/.vim/trans' }
":VimscriptLastError finds last error
Plugit 'rbtnn/vim-vimscript_lasterror'
"Plugit 'mg979/vim-yanktools'
Plugit 'matze/vim-tex-fold' 
":if !has('nvim')
Plugit 'puremourning/vimspector'
"endif
 "Plugit 'jlanzarotta/bufexplorer'
"Plugit 'AndrewRadev/undoquit.vim'
"Plugit 'Shougo/denite.nvim'
Plugit 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
Plugit 'simnalamburt/vim-mundo'
Plugit 'sjl/gundo.vim'
Plugit 'PProvost/vim-ps1'

Plugit 'scrooloose/nerdcommenter'
"Plugit 'rhysd/vim-grammarous'
Plugit '907th/vim-auto-save'
Plugit 'rdnetto/YCM-Generator', { 'branch': 'stable'}
"switch tabs
Plugit 'viniciusarcanjo/fzf-tabs.nvim'
Plugit 'airblade/vim-gitgutter'
"airline needs it
"needed? yes, just a collection of snippets
Plugit 'honza/vim-snippets'
"tab completion 
"Plugit 'ervandew/supertab'
"we dont need it right now
"Plugit 'rafi/awesome-vim-colorschemes'
"backward search
Plugit 'mhinz/neovim-remote'
Plugit 'SirVer/ultisnips'
Plugit 'lervag/vimtex'
"for better .
Plugit 'tpope/vim-repeat'

"Plugit 'Shougo/neco-vim'
"completion for vim
"causes it to crash, vim syntax file
"Plugit 'neoclide/coc-neco'
"Plugit 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

Plugit 'kassio/neoterm'

"motion 
Plugit 'wellle/targets.vim'
Plugit 'kana/vim-textobj-user'
"Plugit 'kana/vim-textobj-function'
Plugit 'hgiesel/vim-motion-sickness'
Plugit 'easymotion/vim-easymotion'
Plugit 'bfredl/nvim-ipy'
Plugit 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugit 'junegunn/fzf.vim'
Plugit 'udalov/kotlin-vim'
"Plugit 'vim-ctrlspace/vim-ctrlspace'
" 
Plugit 'yegappan/mru'
Plugit 'ctrlpvim/ctrlp.vim'
Plugit 'mbbill/undotree'
Plugit 'tpope/vim-fugitive' 
" Git
"Plugit 'joshdick/onedark.vim'
Plug 'navarasu/onedark.nvim'
"Plugit 'dense-analysis/ale'
"syntax highlight
Plugit 'slim-template/vim-slim'

if or(or(has('python_dynamic'),has('python')),has('python3'))

Plugit 'tpope/vim-surround'
Plugit 'tmhedberg/SimpylFold'
"common
Plugit 'inkarkat/vim-ingo-library'
endif
Plugit 'octol/vim-cpp-enhanced-highlight' 
"additional vim c++ syntax highlighting
"Plugit 'valloric/youcompleteme'
"Plugit 'scrooloose/nerdtree'
Plugit 'vim-scripts/EnhancedJumps'
Plugit 'Vimjas/vim-python-pep8-indent'
Plugit 'jeetsukumaran/vim-indentwise'
Plugit  'mg979/vim-visual-multi'
"Plugit 'ipod825/vim-netranger'
    "Plugit 'francoiscabrol/ranger.vim'
    Plugit 'rbgrouleff/bclose.vim'

Plugit 'nvim-tree/nvim-tree.lua'
Plugit 'nvim-tree/nvim-web-devicons'
"Plug 'ryanoasis/vim-devicons'
Plugit 'jeetsukumaran/vim-pythonsense'
if !has('nvim')
	Plugit 'powerline/powerline'
else
	"Plugit 'vim-airline/vim-airline-themes' 
    ", {lazy= false} 
	"Plugit 'vim-airline/vim-airline'
endif
Plugit 'eiginn/netrw'
"Plugit 'WolfgangMehner/bash-support'
"Plugit 'Shougo/deoplete.nvim' , { 'do': ':UpdateRemotePlugits' }
Plugit 'ipod825/vim-bookmark'
"Plugit 'beeender/Comrade'
"Plugit 'Houl/vim-repmo' 
Plugit 'andymass/vim-matchup'
"call LoadPlugitOnEvent('quick-scope', 'VimEnter')
"call LoadPlugitOnEvent('airline', 'VimEnter')
"repeat moves
"Plug 'sjl/gundo.vim'
"Plugit 'w0rp/ale'
" lint
"Plug 'IngoHeimbach/neco-vim'
"Plug 'inkarkat/vim-mark'
Plugit 'powerman/vim-plugin-AnsiEsc'

if !has('nvim')
    call plug#end()
endif


