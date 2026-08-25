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

let g:minimal = get(g:, 'minimal', 0)
let g:onlyplug=  "'Yggdroot/LeaderF'"  "'neovim/nvim-lspconfig' 
let g:on_ek_computer = (($USERNAME . $USER) =~? 'karni')
let g:on_vimr= ( $VIM=~# ".*VimR.*")

let g:no_spec_map=1
"silent !pyenv global 2.7
"g:vimloc is ~/.vim folder
let g:vimloc=split(&packpath,',')[0]
let g:platform = get(g:, 'platform', (has('win32') || has('win64')) ? 'win' : 'mac')

function! SourceCommonConfig(name) abort
    execute 'source ' . fnameescape(g:vimloc . '/' . a:name . '.vim')
endfunction

function! SourcePlatformConfig(name) abort
    let l:path = g:vimloc . '/' . a:name . '_' . g:platform . '.vim'
    if filereadable(l:path)
        execute 'source ' . fnameescape(l:path)
    endif
endfunction

call SourcePlatformConfig('vimsettings')
if g:minimal == 0
    call SourceCommonConfig('vimsettings')
endif

"let &shell='/usr/bin/bash --login'
"source ~/.vim2/autoload/repmo.vim
"
"
if g:minimal == 1
    call plug#begin()
    "exe "Plug ". g:onlyplug
    Plug 'Yggdroot/LeaderF'
"	Plug 'Houl/vim-repmo' "repevt moves
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
"Plug 'Houl/vim-repmo' "repeat moves
"Plug 'sjl/gundo.vim'
"Plug 'w0rp/ale' " lint
"Plug 'IngoHeimbach/neco-vim'
"Plug 'inkarkat/vim-mark'
"Plug 'powerman/vim-plugin-AnsiEsc'
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
    call SourceCommonConfig('pluginSettings')
    call SourcePlatformConfig('pluginSettings')
    call SourceCommonConfig('newplug')
execute 'silent source ' . fnameescape(g:vimloc . '/t.lua')
execute 'silent source ' . fnameescape(g:vimloc . '/secret.vim')
    
call SourceCommonConfig('hacks')
call SourcePlatformConfig('hacks')
execute 'lua dofile(' . string(substitute(g:vimloc, '\\', '/', 'g') . '/myinit.lua') . ')'

"include math mappings
if filereadable(g:vimloc . '/math.vim')
	execute 'silent source ' . fnameescape(g:vimloc . '/math.vim')
endif

call SourceCommonConfig('mappings')
call SourcePlatformConfig('mappings')
endfunction

if g:minimal==0
    call Runit()
else
    "exe 'source' . " " . g:vimloc . "\\newplug.vim"
    "exe 'source' . " " . g:vimloc . "\\t.lua"
      "Lazy load airlinv
      "Lazy load quick-scopv
	"exe 'source' . " " . g:vimloc . "\\hacks.vim"
	"call CustomSources("newplug.vim") 
	"exe 'lua' . " dofile('" . substitute(g:vimloc,'\','\\\\',"g") . "\\\\myinit.lua')"
	call SourceCommonConfig('mappings')
	call SourcePlatformConfig('mappings')
	"exe 
endif 
if g:on_ek_computer 
    "py3 exec(open('c:\\Users\\ekarni\\mypy\\voicerec.py','rt').read())
endif

