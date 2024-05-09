
function! PathExpand(path)
    return fnameescape(expand(a:path))
endfunction


let g:pluginInstallPath = "~/.vim/plugged"
" First source this gist:
exe "source ". " ". PathExpand(g:vimloc . "/env/editors/vim/manage_plugins.vim")
if !has('nvim')
    call plug#begin(g:pluginInstallPath)
endif
"let &rtp = 'C:\Users\ekarni\.vim\plugged\lazy.nvim,C:\Users\ekarni\.vim,C:\Users\ekarni\.vim\plugged\actions-preview.nvim,C:\Users\ekarni\.vim\plugged\vim-dirdiff,C:\Users\ekarni\.vim\plugged\ZFVimDirDiff,C:\Users\ekarni\.vim\plugged\ZFVimJob,C:\Users\ekarni\.vim\plugged\ZFVimIgnore,C:\Users\ekarni\.vim\plugged\ZFVimBackup,C:\Users\ekarni\.vim\plugged\markdown-preview.nvim,C:\Users\ekarni\.vim\plugged\nlsp-settings.nvim,C:\Users\ekarni\.vim\plugged\mason.nvim,C:\Users\ekarni\.vim\plugged\mason-lspconfig.nvim,C:\Users\ekarni\.vim\plugged\wtf.nvim,C:\Users\ekarni\.vim\plugged\telescope-fzf-native.nvim,C:\Users\ekarni\.vim\plugged\ctrlsf.vim,C:\Users\ekarni\.vim\plugged\jupyter-kernel.nvim,C:\Users\ekarni\.vim\plugged\magma-nvim,C:\Users\ekarni\.vim\plugged\telescope-git-grep.nvim,C:\Users\ekarni\.vim\plugged\refactoring.nvim,C:\Users\ekarni\.vim\plugged\sideways.vim,C:\Users\ekarni\.vim\plugged\null-ls.nvim,C:\Users\ekarni\.vim\plugged\vim-gutentags,C:\Users\ekarni\.vim\plugged\telescope-live-grep-args.nvim,C:\Users\ekarni\.vim\plugged\nvim-navic,C:\Users\ekarni\.vim\plugged\Comment.nvim,C:\Users\ekarni\.vim\plugged\nvim-navbuddy,C:\Users\ekarni\.vim\plugged\trouble.nvim,C:\Users\ekarni\.vim\plugged\fin.vim,C:\Users\ekarni\.vim\plugged\vim-nayvy,C:\Users\ekarni\.vim\plugged\speech-to-text.nvim,C:\Users\ekarni\.vim\plugged\neoformat,C:\Users\ekarni\.vim\plugged\nui.nvim,C:\Users\ekarni\.vim\plugged\ChatGPT.nvim,C:\Users\ekarni\.vim\plugged\nvim-lightbulb,C:\Users\ekarni\.vim\plugged\FixCursorHold.nvim,C:\Users\ekarni\.vim\plugged\copilot.vim,C:\Users\ekarni\.vim\plugged\lightspeed.nvim,C:\Users\ekarni\.vim\plugged\vim-arpeggio,C:\Users\ekarni\.vim\plugged\diffview.nvim,C:\Users\ekarni\.vim\plugged\workspaces.nvim,C:\Users\ekarni\.vim\plugged\grammar-guard.nvim,C:\Users\ekarni\.vim\plugged\nvim-web-devicons,C:\Users\ekarni\.vim\plugged\guihua.lua,C:\Users\ekarni\.vim\plugged\navigator.lua,C:\Users\ekarni\.vim\plugged\nvim-treesitter-refactor,C:\Users\ekarni\.vim\plugged\nvim-treesitter,C:\Users\ekarni\.vim\plugged\plenary.nvim,C:\Users\ekarni\.vim\plugged\telescope.nvim,C:\Users\ekarni\.vim\plugged\telescope-symbols.nvim,C:\Users\ekarni\.vim\plugged\aerial.nvim,C:\Users\ekarni\.vim\plugged\nvim-lspconfig,C:\Users\ekarni\.vim\plugged\cmp-nvim-lsp,C:\Users\ekarni\.vim\plugged\cmp-path,C:\Users\ekarni\.vim\plugged\cmp-cmdline,C:\Users\ekarni\.vim\plugged\cmp-dictionary,C:\Users\ekarni\.vim\plugged\nvim-cmp,C:\Users\ekarni\.vim\plugged\cmp-nvim-ultisnips,C:\Users\ekarni\.vim\plugged\vim-sneak,C:\Users\ekarni\.vim\plugged\quick-scope,C:\Users\ekarni\.vim\plugged\which-key.nvim,C:\Users\ekarni\.vim\plugged\popup-menu.nvim,C:\Users\ekarni\.vim\plugged\vim-argumentative,C:\Users\ekarni\.vim\plugged\vim-matchquote,C:\Users\ekarni\.vim\plugged\vim-vimscript_lasterror,C:\Users\ekarni\.vim\plugged\vim-tex-fold,C:\Users\ekarni\.vim\plugged\vimspector,C:\Users\ekarni\.vim\plugged\LeaderF,C:\Users\ekarni\.vim\plugged\vim-mundo,C:\Users\ekarni\.vim\plugged\gundo.vim,C:\Users\ekarni\.vim\plugged\vim-ps1,C:\Users\ekarni\.vim\plugged\nerdcommenter,C:\Users\ekarni\.vim\plugged\vim-auto-save,C:\Users\ekarni\.vim\plugged\YCM-Generator,C:\Users\ekarni\.vim\plugged\fzf-tabs.nvim,C:\Users\ekarni\.vim\plugged\vim-gitgutter,C:\Users\ekarni\.vim\plugged\vim-snippets,C:\Users\ekarni\.vim\plugged\neovim-remote,C:\Users\ekarni\.vim\plugged\ultisnips,C:\Users\ekarni\.vim\plugged\vimtex,C:\Users\ekarni\.vim\plugged\vim-repeat,C:\Users\ekarni\.vim\plugged\neoterm,C:\Users\ekarni\.vim\plugged\targets.vim,C:\Users\ekarni\.vim\plugged\vim-textobj-user,C:\Users\ekarni\.vim\plugged\vim-textobj-function,C:\Users\ekarni\.vim\plugged\vim-motion-sickness,C:\Users\ekarni\.vim\plugged\vim-easymotion,C:\Users\ekarni\.vim\plugged\nvim-ipy,C:\Users\ekarni\.fzf,C:\Users\ekarni\.vim\plugged\fzf.vim,C:\Users\ekarni\.vim\plugged\kotlin-vim,C:\Users\ekarni\.vim\plugged\mru,C:\Users\ekarni\.vim\plugged\ctrlp.vim,C:\Users\ekarni\.vim\plugged\undotree,C:\Users\ekarni\.vim\plugged\vim-fugitive,C:\Users\ekarni\.vim\plugged\onedark.vim,C:\Users\ekarni\.vim\plugged\vim-slim,C:\Users\ekarni\.vim\plugged\vim-surround,C:\Users\ekarni\.vim\plugged\SimpylFold,C:\Users\ekarni\.vim\plugged\vim-ingo-library,C:\Users\ekarni\.vim\plugged\vim-cpp-enhanced-highlight,C:\Users\ekarni\.vim\plugged\EnhancedJumps,C:\Users\ekarni\.vim\plugged\vim-python-pep8-indent,C:\Users\ekarni\.vim\plugged\vim-indentwise,C:\Users\ekarni\.vim\plugged\vim-visual-multi,C:\Users\ekarni\.vim\plugged\bclose.vim,C:\Users\ekarni\.vim\plugged\nvim-tree.lua,C:\Users\ekarni\.vim\plugged\vim-pythonsense,C:\Users\ekarni\.vim\plugged\vim-airline-themes,C:\Users\ekarni\.vim\plugged\vim-airline,C:\Users\ekarni\.vim\plugged\netrw,C:\Users\ekarni\.vim\plugged\vim-bookmark,C:\Users\ekarni\.vim\plugged\Comrade,C:\Users\ekarni\AppData\Local\nvim,C:\Users\ekarni\AppData\Local\nvim-data\site,C:\Users\ekarni\Neovim\share\nvim\runtime,C:\Users\ekarni\Neovim\share\nvim\runtime\pack\dist\opt\cfilter,C:\Users\ekarni\Neovim\lib\nvim,C:\Users\ekarni\AppData\Local\nvim-data\site\after,C:\Users\ekarni\AppData\Local\nvim\after,C:/Users/ekarni/Neovim/bin/../share/nvim-qt/runtime,C:\Users\ekarni\.vim\plugged\ctrlsf.vim\after,C:\Users\ekarni\.vim\plugged\vim-nayvy\after,C:\Users\ekarni\.vim\plugged\vim-arpeggio\after,C:\Users\ekarni\.vim\plugged\cmp-nvim-lsp\after,C:\Users\ekarni\.vim\plugged\cmp-path\after,C:\Users\ekarni\.vim\plugged\cmp-cmdline\after,C:\Users\ekarni\.vim\plugged\cmp-dictionary\after,C:\Users\ekarni\.vim\plugged\cmp-nvim-ultisnips\after,C:\Users\ekarni\.vim\plugged\vim-tex-fold\after,C:\Users\ekarni\.vim\plugged\ultisnips\after,C:\Users\ekarni\.vim\plugged\vimtex\after,C:\Users\ekarni\.vim\plugged\vim-textobj-function\after,C:\Users\ekarni\.vim\plugged\vim-cpp-enhanced-highlight\after,C:\Users\ekarni\.vim\plugged\vim-pythonsense\after,C:\Users\ekarni\.vim\after'
" Keys will do nothing in vim, but will create lazyLoad keys for lazy.nvim.
"Plugit 'wellle/targets.vim', {
"            \ 'keys': MakeLazyKeys({
"            \ 'n': ['[', ']'],
"            \ 'ov': ['i,', 'a', 'I', 'A'],
"            \ })}
"
"Plugit 'equalsraf/neovim-gui-shim'
Plugit 'aznhe21/actions-preview.nvim'
Plugit 'will133/vim-dirdiff'
Plugit 'ZSaberLv0/ZFVimDirDiff', {'on':'LazyVimStarted'}
Plugit 'ZSaberLv0/ZFVimJob' 
" required
Plugit 'ZSaberLv0/ZFVimIgnore' 
" optional, but recommended for auto ignore setup
Plugit 'ZSaberLv0/ZFVimBackup' 
" optional, but recommended for auto backup
Plugit 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plugit 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

Plugit 'tamago324/nlsp-settings.nvim'
Plugit 'williamboman/mason.nvim'
Plugit 'williamboman/mason-lspconfig.nvim'


" Vim Script
"Plugit 'ahmedkhalf/project.nvim'

Plugit 'piersolenski/wtf.nvim'
Plugit 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

Plugit 'dyng/ctrlsf.vim'

Plugit 'lkhphuc/jupyter-kernel.nvim'
Plugit 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugits' }

Plugit 'davvid/telescope-git-grep.nvim'
"Plugit 'python-rope/ropevim'
Plugit 'ThePrimeagen/refactoring.nvim'
Plugit 'AndrewRadev/sideways.vim'
Plugit 'jose-elias-alvarez/null-ls.nvim'
"Plugit 'mfussenegger/nvim-lint'
Plugit 'ludovicchabant/vim-gutentags'
Plugit 'nvim-telescope/telescope-live-grep-args.nvim'
Plugit 'SmiteshP/nvim-navic'
Plugit 'numToStr/Comment.nvim'        
" Optional
Plugit 'SmiteshP/nvim-navbuddy'
"Plugit 'simrat39/symbols-outline.nvim'
Plugit 'folke/trouble.nvim'
Plugit 'lambdalisue/fin.vim'
Plugit 'relastle/vim-nayvy'
"Plugit 'sickill/vim-pasta'
"Plugit 'xiyaowong/transparent.nvim'
Plugit 'blblb/speech-to-text.nvim'
Plugit 'sbdchd/neoformat'
Plugit 'MunifTanjim/nui.nvim'
Plugit 'jackMort/ChatGPT.nvim'
Plugit 'kosayoda/nvim-lightbulb'
Plugit 'antoinemadec/FixCursorHold.nvim'
Plugit 'github/copilot.vim'
Plugit 'ggandor/lightspeed.nvim'
"Plugit 'rhysd/clever-f.vim'
"Plugit 'craigemery/vim-autotag'
Plugit 'kana/vim-arpeggio'
Plugit 'sindrets/diffview.nvim'
"Plugit 'tc50cal/vim-terminal'

"Plugit 'ibhagwan/fzf-lua', {'branch': 'main'}
" optional for icon support
"plug 'brettanomyces/nvim-terminus'
Plugit 'natecraddock/workspaces.nvim'
Plugit 'brymer-meneses/grammar-guard.nvim'
Plugit 'kyazdani42/nvim-web-devicons'
Plugit 'ray-x/guihua.lua', {'do': 'cd lua\fzy && make' }
Plugit 'ray-x/navigator.lua'
Plugit 'nvim-treesitter/nvim-treesitter-refactor'
Plugit 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plugit 'nvim-lua/plenary.nvim'
Plugit 'nvim-telescope/telescope.nvim'
Plugit 'nvim-telescope/telescope-symbols.nvim'
Plugit 'stevearc/aerial.nvim'
"Plugit 'williamboman/nvim-lsp-installer'
Plugit 'neovim/nvim-lspconfig'
Plugit 'hrsh7th/cmp-nvim-lsp'
"Plugit 'hrsh7th/cmp-buffer'
Plugit 'hrsh7th/cmp-path'
Plugit 'hrsh7th/cmp-cmdline'
"Plugit 'ray-x/cmp-treesitter'
Plugit 'uga-rosa/cmp-dictionary'
Plugit 'hrsh7th/nvim-cmp', { 'branch': 'main'}
Plugit 'quangnguyen30192/cmp-nvim-ultisnips'
"tpope/vim-eunuch.git best in linux env I guess...
Plugit 'justinmk/vim-sneak'
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
Plugit 'airblade/vim-matchquote'
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
Plugit 'kana/vim-textobj-function'
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
Plugit 'joshdick/onedark.vim'
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
Plugit 'jeetsukumaran/vim-pythonsense'
if !has('nvim')
	Plugit 'powerline/powerline'
else
	Plugit 'vim-airline/vim-airline-themes' 
    ", {lazy= false} 
	Plugit 'vim-airline/vim-airline'
endif
Plugit 'eiginn/netrw'
"Plugit 'WolfgangMehner/bash-support'
"Plugit 'Shougo/deoplete.nvim' , { 'do': ':UpdateRemotePlugits' }
Plugit 'ipod825/vim-bookmark'
"Plugit 'beeender/Comrade'
Plugit 'Houl/vim-repmo' 
"call LoadPlugitOnEvent('quick-scope', 'VimEnter')
"call LoadPlugitOnEvent('airline', 'VimEnter')
"repeat moves
"Plug 'sjl/gundo.vim'
"Plugit 'w0rp/ale'
" lint
"Plug 'IngoHeimbach/neco-vim'
"Plug 'inkarkat/vim-mark'
Plugit 'powerman/vim-plugin-AnsiEsc'
let g:vim_shell_plug_args = {'dependencies': []}
if has('nvim')
    let g:vim_shell_plug_args['event'] = 'VeryLazy'
endif

if !has('nvim')
    call plug#end()
endif
