
set dictionary=C:\temp\words
"Vim settings
"includes autocmds and autocmds for file types and commands
"Should be indepdenent of plugins!
let g:python3_host_prog='C:\\Users\\ekarni\\.pyenv\\pyenv-win\\versions\\3.9\\python.exe'
let ver= "3.9.6" "system('pyenv version')
let g:on_windows=1
let g:pwmod=0
let g:sh = &shell 
let g:shf=&shellcmdflag
let g:shr=&shellredir
let g:shellpipe=&shellpipe
let g:shq=&shellquote
let g:shxq=&shellxquote


let g:ver=ver
"allows ctrl-c I think
set allowrevins
if has('nvim')
	set inccommand=split
endif 

command! -nargs=* -range PY <line1>,<line2>python3 <args>
set noerrorbells visualbell t_vb=
set noeb vb t_vb=
autocmd GUIEnter * set visualbell t_vb=

"let g:yanktools_main_key = 'Z'
":20verbose
"message log
redi >> ~/.vim/vimlog.log

if or(or(has('python_dynamic'),has('python')),has('python3'))
	"set termguicolors "for vimr bug terminal
	set fillchars+=stl:\ ,stlnc:\
	set laststatus=2
	set showtabline=2
	set encoding=utf-8
	"set t_Co=256
	"set t_AB=^[[48;5;%dm
	"set t_AF=^[[38;5;%dm
	"set term=xterm-256color
	"set termencoding=utf-8 has
	" #set noshowmode
	set nowrap
	set number
	set completeopt=menuone
	set completeopt+=noinsert 
    set mousemodel=popup
endif

"from shawn
"set relativenumber
set wildmenu
set cursorline
set nosplitright

set clipboard+=unnamed
":echo system('git --version') 

"plus
"set paste
set go+=a "???
set cpoptions+=y
:noh

setlocal spell
set spellfile = "~/.vim/spell/en.utf-8.add"
set spelllang=en_us

set updatetime =3000

"packadd! syntax-vim-ex
"autocmd filetype python :call PythonSetup()
" Defaults


syntax on
filetype plugin indent on

"
"set noswapfile
"for swap files
set directory=c:\\users\\ekarni\\.vim\\swap
set shortmess=a  "added now
set shm+=A
set shortmess+=A
set cmdheight=2
set showcmd

set list
set listchars=tab:>~,trail:~
set tabstop=4 shiftwidth=4 expandtab

set splitbelow
set splitright


"for workspaces
set hidden
" history
"
" default file /Users/eyalkarni/.local/share/nvim/shada/main.shada . save
" marks.
set shada=!,'100,<50,s10,h,f1,s100,%
"exec "set shadafile=".g:vimloc . "/shada"
set history=10000
" insert mode
set backspace=indent,eol,start
"set shiftwidth=4
"set expandtab
"
" line+
if has('gui_running') 
"set lines=75
    set scrolloff=3
endif



if !isdirectory($HOME."\\.vim")
	call mkdir($HOME."\\.vim", "", 0770)
endif
if !isdirectory($HOME."\\.vim\\undo")
	call mkdir($HOME."\\.vim\\undo", "", 0700)
endif

set undodir=~\\.vim\\undo
set undofile

"important autocmds
"
autocmd FileChangedShell * echohl WarningMsg | echo "File changed: " . @% | echohl None
"exit window using esc
:autocmd CmdwinEnter * nnoremap <buffer> <ESC> <C-c><C-c>
"exec and leave open
:autocmd CmdwinEnter * nmap <buffer> <F5> <CR>q: 
":autocmd InsertLeave * :let g:EasyMotion_add_search_history=1

au SwapExists * nested call OnSwap() 
function! OnSwap()
	let swap_info = swapinfo(v:swapname)
	echo "Recovery exist " . strftime("%Y %b %d %X",swap_info['mtime']) 
	let v:swapcommand='e'
endfunction 


au VimEnter * nested call OnLoad()
au VimLeave * nested call OnEnd()
au ExitPre * nested call timer_stop(g:autosaveWS)
function! OnLoad()
    if exists('g:GuiLoaded')
        :GuiFont! Fira\ Code:h12
    endif
    "set guifont=JetBrains\ Mono\ Medium:h11

    sleep 500ms
    "echom "onload"
    cd ~/.vim
function
":profile start /Users/eyalkarni/ab.log
":profile file /Users/eyalkarni/vimpy3/plugged/vim-ctrlspace/autoload/ctrlspace/workspaces.vim
"call ToggleVerbose() 
    "!cp /Users/eyalkarni/vimpy3/.git/cs_workspaces /tmp/onload 
". '~/vimpy3/'
:exe ":silent CtrlSpaceAddProjectRoot ". g:vimloc
	if !has('nvim')
		return
	endif 
	call MakeItFaster(0)
	if g:on_ek_computer
		let g:SessionFile = ($HOME."\\.vim\\session_file") 
		if exists('g:GuiLoaded') || ( g:on_vimr) || exists(':GonvimWorkspaceNew')
			let g:ctrlspaceWorkspace = ($HOME."\\.vim\\workspaces\\.cs_workspaces")
		else
			let g:ctrlspaceWorkspace = ($HOME."\\.vim\\workspaces\\.cs_workspacesCWD")
        endif 
		let g:overrideCWD=1
	endif
	
	 "Find the current process, the process parent, and use ps ax to obtain the path. Meant to work in mac. in Linux, it is easier with `/proc/XXX/cmdline'. 
    if expand("%:p:t")=="special"
        :CtrlSpaceLoadWorkspace default
    endif 
	if argc()==0
		"PY import vim
		"PY import os
		"PY pid=os.getpid()
		"PY kk=os.popen('ps -o ppid= -p ' + str(pid)).read()
		"PY kk=kk.replace('\n','')
		"PY tt=("let uu=system('ps ax | grep \""+kk + "\" | grep -v grep')")
		"PY vim.command(tt)
		"let uuA=substitute(uu,"^.\\{-}\/","",'g')
		"let uu="bash"
		"PY kk=os.popen('ps -o ppid= -p ' + str(kk)).read()
		"PY kk=kk.replace('\n','')
		""if it is 1 then fail 
		"PY if kk!=1: tt=("let uu=system('ps ax | grep \""+kk + "\" | grep -v grep')")
		"PY vim.command(tt)
		"let uu=substitute(uu,"^.\\{-}\/","",'g')
		"if (uu=~".*bash.*")
			""too much indentation
			"let uu=uuA
		"endif

 
		""echom 'cmdline: '.uu
		
		""for neovim-qt
		"let uu=substitute(uu," -psn.\\{-}$","",'g')
		"PY vim.command('let uu='+str(vim.eval('uu').replace('\n','').find(' ')))

		"if uu==-1
			""echom "loading"
			"":CocDisable
			"":CtrlSpaceLoadWorkspace default
		"endif
	endif
	"if exists('g:GuiLoaded') || ( g:on_vimr)
		"imap <c-s> <esc>:let g:EasyMotion_add_search_history=0<CR>i<c-o><Plug>(easymotion-sn)
	"endif 
	"if exists('g:GuiLoaded') || exists(':GonvimWorkspaceNew') || ( g:on_vimr)
		"imap <c-s> <esc>:let g:EasyMotion_add_search_history=0<CR>i<c-o><Plug>(easymotion-sn)
	"else
		"nnoremap <c-s> :w<CR>
	"endif
	"nvimQT
	
	if exists('g:GuiLoaded') || exists(':GonvimWorkspaceNew')
        "echom "exists"
		"set guifont=Meslo\ LG\ L\ DZ\ for\ Powerline:h12
        "set guifont=Inconsolata-dz\ for\ powerline:h14
		if !exists(':GonvimWorkspaceNew')
			":GuiTabline 0
			"source /users/eyalkarni/nvim-osx64/share/nvim/runtime/macmap.vim
			"it started to act normal
			imap <M-ß> :w<CR>
			nmap <D-W> :q<CR>
			nmap <D-w> :q<CR>
			nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
			inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
			vnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
			if g:on_ek_computer


                "source /Users/eyalkarni/neovim-0.4.2/runtime/macmap.vim 
				"nmap <leader>rv mwd:sleep 1<CR>:!osascript -e 'tell application "System Events" to keystroke "v" using {control down, shift down}'<CR>:qa!<CR>
				"nmap <leader>RV mwd:sleep 1<CR>:!osascript -e 'tell application "System Events" to keystroke "v" using {command down, shift down}'<CR>:qa!<CR> 
				"nmap <leader>rv mwd:sleep 1<CR>:exec '!start \"powershell  ps \| Where-Object -Property ProcessName  -Like \"*goneovim*\" \| \%{Write-Host $_.Id ,$_.ProcessName ;$_.Kill()} ;  C:\Users\ekarni\Downloads\Goneovim-v0.4.12-win64\goneovim.exe\"'
			endif
		else
			"~/nvimMACfiles/macmap042.vim
            if g:on_ek_computer
                nmap <leader>rv :exec "norm mwd"<bar>:sleep 2<bar>:exec "!start powershell ResetNeo"<CR>

                "source /Users/eyalkarni/neovim-0.4.2/runtime/macmap.vim 
            endif
		endif 
        set shell=cmd 

        exec "!echo ". v:servername . " > c:\\temp\\listen.txt"
        "override
        nmap <D-f> <Plug>(easymotion-s2) 

        "imap <D-v> <c-o>P
        nnoremap <Home> ^
        vnoremap <Home> ^
		"set guifont=Meslo\ LG\ S\ for\ Powerline:h14
"		set guifont=Monaco\ for\ Powerline:h12 
		set mouse+=a
        inoremap <c-p> <c-v>
        cnoremap <c-p> <c-v>
        imap <c-v> <c-r><c-p>+
        imap <c-v> <c-r><c-p>+
        cmap <c-v> <c-r>+
		nmap <c-v> p
        nnoremap <M-v> <c-v>
        nmap <M-a> ggVG
		"nmap <D-v> p
		"imap <D-V> 
		"imap <D-v> 
		"vmap <D-V> p
		"vmap <D-v> p
		"vmap <D-C> y
		"vmap <D-c> y
		"vmap <D-X> d
		"vmap <D-x> d
		"cmap <D-V> <c-r>+
		"cmap <D-v> <c-r>+
	else

		if g:on_ek_computer
			nmap <leader>rv mwd:!osascript -e 'do shell script "sh /users/eyalkarni/vimpy3/vimr.sh"'<CR>
		endif
	endif
	"echom "ignore this no such mapping"
if getcwd()=='/' || getcwd()=="c:\\Windows\\system32"
    cd ~
    "normal \ov
endif
	if !exists('g:dirs')
		call LoadDir()
		let g:lastdir=''
	endif
:GitGutterEnable
let g:autosaveWS=timer_start(10000,'TimerFunc',{'repeat':-1})
let g:autoreg=timer_start(2000,'GetLine',{'repeat':-1})
let g:autosaveInserts = timer_start(20000,'SaveInsertsFunc',{'repeat':-1})
"for solving ctags bug
"au! GonvimAu OptionSet
set mouse=a
endfunction

function! OnEnd()
	 "call ctrlspace#workspaces#SaveWorkspace("default")
endfunction
"autocmd VimEnter * call RestoreSession()
"function! RestoreSession()
	"if argc() == 0 && filereadable(eval('g:ses')) "vim called without arguments
		"execute "source " . g:ses
	"endif
"endfunction
function! PyAS()
    autocmd filetype python let b:auto_save = 1
endfunction
command Pyauto call PyAS()<CR>
" autocmds for  file types
autocmd filetype vim let b:auto_save = 1

"completing next function 
:autocmd FileType vim nnoremap <buffer> ]m /^\(\s\)*function<CR>
:autocmd FileType vim nnoremap <buffer> [m ?^\(\s\)*function<CR>
:autocmd FileType vim nnoremap <buffer> ]M /^\(\s\)*endfunction/b<CR>
:autocmd FileType vim nnoremap <buffer> [M ?^\(\s\)*endfunction/b<CR>



let $PATH="C:\\Users\\ekarni\\.pyenv\\pyenv-win\\versions\\3.9\\Scripts;". $PATH
let $PATH='C:\Users\ekarni\AppData\Local\SumatraPDF;'. $PATH
"autocmd! TermEnter * :startinsert

"commands
"
command! -nargs=* -complete=file C call CloseAllNR()<bar>:sleep 200m<bar>:vert topleft split <args>
command! -nargs=*  -complete=help Help vert :help <args>

" search
set noincsearch
:noh
set nohlsearch

augroup vimrc-noincsearch-highlight
    autocmd!
    autocmd CmdlineLeave / :set noincsearch | :noh
augroup END
