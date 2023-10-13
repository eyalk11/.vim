"
" By Eyal Karni
" PYTHONaATH C:\Users\ekarni\AppData\Local\Programs\Python\Python39\Lib\site-packages
":let $PYTHONsATHCOC='/Users/eyalkarni/impacket/impacket;/usr/local/lib/python2.7/site-packages;/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages'
" I will be applying some adaptations on my computer. That is only if the folder exists.
" some tips : remember commenter \Cc , remember <c-u>  and <M-Bslash> windows , remember \C
" close NR 
"
" We have q for s , alt-t for nmap tl current line m and ctrl-t for t all
" lines.
"ctrl-x ctrl-k directory  (ctrl-v guess)
" Search workspace symbols
"nnoremap <silent> _s  :<C-u>CocList -I symbols<cr>
" remember m-space to enter command and ~ to search and of course ` to enter
" and exit mode. and c-F to search (c-- c-= next back). but of course, c-` is c-o (btw alt-` is
" windows switcher). To print just this ` we have c-]).
"
" TODO: use set for inserts.
" ctrl-d ctrl-h ctrl-t for inside line search.
"
"Alt - q is the new macro recording ....
" also 'I and `I made to work.
" let us remember that ! is `
" Gdiffsplit! for merge!!!! onlyplg is minimal.
let $HOME=expand('~')

let g:minimal = 0
let g:onlyplug='neovim/nvim-lspconfig' 
let g:on_ek_computer=1 " (filewritable("\\Users/ekarni")==2)
let g:on_vimr= ( $VIM=~# ".*VimR.*")

let g:no_spec_map=1
"silent !pyenv global 2.7
"g:vimloc is ~/.vim folder
let g:vimloc=split(&packpath,',')[0]

if g:minimal == 0
    exe 'source' . " " . g:vimloc . "\\vimsettings.vim"
endif

"let &shell='/usr/bin/bash --login'
"source ~/.vim2/autoload/repmo.vim
"
"
if g:minimal == 0

call plug#begin('~/.vim/plugged')
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

Plug 'tamago324/nlsp-settings.nvim'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'


" Vim Script
"Plug 'ahmedkhalf/project.nvim'

Plug 'piersolenski/wtf.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

Plug 'dyng/ctrlsf.vim'

Plug 'lkhphuc/jupyter-kernel.nvim'
Plug 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'davvid/telescope-git-grep.nvim'
"Plug 'python-rope/ropevim'
Plug 'ThePrimeagen/refactoring.nvim'
Plug 'AndrewRadev/sideways.vim'
Plug 'jose-elias-alvarez/null-ls.nvim'
"Plug 'mfussenegger/nvim-lint'
Plug 'ludovicchabant/vim-gutentags'
Plug 'nvim-telescope/telescope-live-grep-args.nvim'
Plug 'SmiteshP/nvim-navic'
Plug 'numToStr/Comment.nvim'        " Optional
Plug 'SmiteshP/nvim-navbuddy'
"Plug 'simrat39/symbols-outline.nvim'
Plug 'folke/trouble.nvim'
Plug 'lambdalisue/fin.vim'
Plug 'relastle/vim-nayvy'
"Plug 'sickill/vim-pasta'
"Plug 'xiyaowong/transparent.nvim'
Plug 'blblb/speech-to-text.nvim'
Plug 'sbdchd/neoformat'
Plug 'MunifTanjim/nui.nvim'
Plug 'jackMort/ChatGPT.nvim'
Plug 'kosayoda/nvim-lightbulb'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'github/copilot.vim'
Plug 'ggandor/lightspeed.nvim'
"Plug 'rhysd/clever-f.vim'
"Plug 'craigemery/vim-autotag'
Plug 'kana/vim-arpeggio'
Plug 'sindrets/diffview.nvim'
"Plug 'tc50cal/vim-terminal'

"Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
" optional for icon support
"plug 'brettanomyces/nvim-terminus'
Plug 'natecraddock/workspaces.nvim'
Plug 'brymer-meneses/grammar-guard.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ray-x/guihua.lua', {'do': 'cd lua\fzy && make' }
Plug 'ray-x/navigator.lua'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'stevearc/aerial.nvim'
"Plug 'williamboman/nvim-lsp-installer'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
"Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
"Plug 'ray-x/cmp-treesitter'
Plug 'uga-rosa/cmp-dictionary'
Plug 'hrsh7th/nvim-cmp', { 'branch': 'main'}
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
"tpope/vim-eunuch.git best in linux env I guess...
Plug 'justinmk/vim-sneak'
Plug 'unblevable/quick-scope'
"Plug 'liuchengxu/vim-which-key'
Plug 'folke/lazy.nvim'
Plug 'folke/which-key.nvim'
Plug 'kamykn/popup-menu.nvim'
"Peek at registers before pasting
"Plug 'junegunn/vim-peekaboo'
Plug 'PeterRincker/vim-argumentative'
"match inner blocks and z% 
"Plug 'andymass/vim-matchup'
"Plug 'scrooloose/nerdtree'
"match strings 
Plug 'airblade/vim-matchquote'
"Plug 'ggvgc/vim-fuzzysearch'
"Plug 'benknoble/popsikey'
"Plug 'jacob-ogre/vim-syncr' RSYNC
"Plug 'inkarkat/vim-SpellCheck'
"Plug 'echuraev/translate-shell.vim', { 'do': 'wget -O ~/.vim/trans git.io/trans && chmod +x ~/.vim/trans' }
":VimscriptLastError finds last error
Plug 'rbtnn/vim-vimscript_lasterror'
"Plug 'mg979/vim-yanktools'
Plug 'matze/vim-tex-fold' 
":if !has('nvim')
Plug 'puremourning/vimspector'
"endif
 "Plug 'jlanzarotta/bufexplorer'
"Plug 'AndrewRadev/undoquit.vim'
"Plug 'Shougo/denite.nvim'
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
Plug 'simnalamburt/vim-mundo'
Plug 'sjl/gundo.vim'
Plug 'PProvost/vim-ps1'

Plug 'scrooloose/nerdcommenter'
"Plug 'rhysd/vim-grammarous'
Plug '907th/vim-auto-save'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
"switch tabs
Plug 'viniciusarcanjo/fzf-tabs.nvim'
Plug 'airblade/vim-gitgutter'
"needed? yes, just a collection of snippets
Plug 'honza/vim-snippets'
"tab completion 
"Plug 'ervandew/supertab'
"we dont need it right now
"Plug 'rafi/awesome-vim-colorschemes'
"backward search
Plug 'mhinz/neovim-remote'
Plug 'SirVer/ultisnips'
Plug 'lervag/vimtex'
Plug 'tpope/vim-repeat'

"Plug 'Shougo/neco-vim'
"completion for vim
"causes it to crash, vim syntax file
"Plug 'neoclide/coc-neco'
"Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

Plug 'kassio/neoterm'

"motion 
Plug 'wellle/targets.vim'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-function'
Plug 'hgiesel/vim-motion-sickness'
Plug 'easymotion/vim-easymotion'
Plug 'bfredl/nvim-ipy'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'udalov/kotlin-vim'
"Plug 'vim-ctrlspace/vim-ctrlspace'
" 
Plug 'yegappan/mru'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive' " Git
Plug 'joshdick/onedark.vim'
"Plug 'dense-analysis/ale'
"syntax highlight
Plug 'slim-template/vim-slim'

if or(or(has('python_dynamic'),has('python')),has('python3'))

Plug 'tpope/vim-surround'
Plug 'tmhedberg/SimpylFold'
"common
Plug 'inkarkat/vim-ingo-library'
endif
Plug 'octol/vim-cpp-enhanced-highlight' "additional vim c++ syntax highlighting
"Plug 'valloric/youcompleteme'
"Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/EnhancedJumps'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'jeetsukumaran/vim-indentwise'
Plug  'mg979/vim-visual-multi'
"Plug 'ipod825/vim-netranger'
    "Plug 'francoiscabrol/ranger.vim'
    Plug 'rbgrouleff/bclose.vim'

Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'jeetsukumaran/vim-pythonsense'
if !has('nvim')
	Plug 'powerline/powerline'
else
	Plug 'vim-airline/vim-airline-themes'
	Plug 'vim-airline/vim-airline'
endif
Plug 'eiginn/netrw'
"Plug 'WolfgangMehner/bash-support'
"Plug 'Shougo/deoplete.nvim' , { 'do': ':UpdateRemotePlugins' }
Plug 'ipod825/vim-bookmark'
Plug 'beeender/Comrade'
call plug#end()
else
    call plug#begin('~/.vim/plugged')
    exe "Plug ". g:onlyplug
	Plug 'Houl/vim-repmo' "repeat moves
    call plug#end()
endif
"Plug 'ivanov/vim-ipython'
"Plug 'vim-scripts/mru.vim'
"Plug 'kchmck/vim-coffee-script'
if !has('nvim')
 "use old vim session tools
"Plug 'thaerkh/vim-workspace'
"Plug 'xolox/vim-misc'
"Plug 'xolox/vim-session'
endif 
":CocInstall coc-vimlsp
"if ver == "3.7"
"Plug 'vim-vdebug/vdebug'
"
"else
"
"Plug 'vim-vdebug/vdebug', {'tag':'v1.5.2'}
"endi

"Plug 'valloric/youcompleteme'
"Plug 'tpope/vim-sleuth'
  "Plug 'roxma/vim-hug-neovim-rpc'
  "Plug 'roxma/nvim-yarp'
  "Plug 'Shougo/deoplete.nvim'
  "Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'tpope/vim-repeat'
"Plug 'rbgrouleff/bclose.vim'
"Plug 'francoiscabrol/ranger.vim'
"Plug 'scrooloose/nerdtree'
"Plug 'terryma/vim-multiple-cursors'
"Plug 'davidhalter/jedi-vim' " Python autocomplete
Plug 'Houl/vim-repmo' "repeat moves
"Plug 'sjl/gundo.vim'
Plug 'w0rp/ale' " lint
"Plug 'IngoHeimbach/neco-vim'
"Plug 'inkarkat/vim-mark'
Plug 'powerman/vim-plugin-AnsiEsc'
"Plug 'iamcco/vim-language-server'
"Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
"Plug 'vim-jp/syntax-vim-ex'
"Plug 'neoclide/coc-python'
"Plug 'xavierd/clang_complete'
if has('nvim')
else
endif
" Plug 'AndrewRadev/undoquit.vim'
" Plug 'python-mode/python-mode', { 'branch': 'develop' }
" Plug 'artur-shaik/vim-javacomplete2'
" Plug 'fatih/vim-go'
" if has('gui_running')
" endif
" Plug 'severin-lemaignan/vim-minimap'

function! Runit() 
exe 'source' . " " . g:vimloc    . "\\secret.vim"
    
exe 'source' . " " . g:vimloc . "\\pluginSettings.vim"
exe 'source' . " " . g:vimloc . "\\hacks.vim"
exe 'lua' . " dofile('" . substitute(g:vimloc,'\','\\\\',"g") . "\\\\myinit.lua')"

"include math mappings
if filereadable(" " . g:vimloc . "\\math.vim")
	exe 'source' . " " . g:vimloc . "\\math.vim"
endif

exe 'source' . " " . g:vimloc . "\\mappings.vim"
endfunction

if g:minimal==0
    call Runit()
else
    exe 'lua' . " dofile('" . substitute(g:vimloc,'\','\\\\',"g") . "\\\\myinit.lua')"
	exe 'source' . " " . g:vimloc . "\\mappings.vim"
endif 
if g:on_ek_computer 
    "py3 exec(open('c:\\Users\\ekarni\\mypy\\voicerec.py','rt').read())
endif

