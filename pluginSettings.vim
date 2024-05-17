
"plugin settings. but not including mappings.
"includes special functions/adaptations of the plugins
"""
"
"let g:airline_theme="tokyonight"

if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif
"packadd! syntax-vim-ex asdasd
"colorscheme onedark

if or(or(has('python_dynamic'),has('python')),has('python3'))
" powerline
if !has('nvim')
    PY from powerline.vim import setup as powerline_setup
    PY powerline_setup()
    PY del powerline_setup
    set guifont=Inconsolata\ for\ Powerline:h14
    let g:Powerline_symbols = 'fancy'
endif
endif

let g:vimsyn_folding='f'

"airline
let g:line=''

function! GetLine(timer)
	if !exists('g:reg_tog')
		return 
	endif
	if g:reg_tog==0 
		return
	endif 
	if (getreg('0')==getreg('*'))
		let regs=['+','1','2','3','x','z','4','5']
	else
		let regs=['*','0','1','2','x','z','4','5']
	endif 

	let tot=0
	let wid=winwidth(0)
	let s=""
	let tl=0
	let avg=0

	let countmore=0
	let lenlessthan=0
	let lenmore=0

	for it in regs
		let t=printf('%s',getreg(it))
		let t=substitute(t,"\<NL>","^M","g")
		let t=substitute(t,"\t","    ","g")
		let l= len(t) 

		if l<(wid-25)/(len(regs)+1)
			let lenlessthan+=l
		else
			let lenmore+=l 
			let countmore+=1
		endif 
	endfor 

	let neededavg = ((wid-25-(3*countmore)) - lenlessthan + 0.01) / (countmore+ 0.01)



	for it in regs
		let t=printf('%s',getreg(it))
		let t=substitute(t,"\<NL>","","g")
		let t=substitute(t,"\t","    ","g")
		let l= len(t) 
		if  l>=(wid-25)/(len(regs)+1) 
			let ll=min([len(t),float2nr(floor(neededavg))])
		else
			let ll=len(t)
		endif 
		if ll>0
			if (len(s)+ll<wid-25)
				if ll<l
					let s=s . printf('%s',it) . ': ' . t[0:ll] .'..| '
				else
					let s=s . printf('%s',it) . ': ' . t[0:ll] .' | '
				endif 
			endif
		endif
	endfor
	let g:line=s
endfunction

function! RegsToggle()
	if !exists('g:reg_tog')
		let g:reg_tog=0
	endif


	let g:reg_tog=!(g:reg_tog)
	if g:reg_tog
		let g:airline_section_a_temp= g:airline_section_a
		let g:airline_section_a=""
		let g:airline_section_x_temp= g:airline_section_x
		let g:airline_section_x=""
		let g:airline_section_y_temp= g:airline_section_y
		let g:airline_section_y=""
		let g:airline_section_z_temp= g:airline_section_z
		let g:airline_section_z=""
		let g:airline_section_c= "%{g:line}"
		"*=  %-0.40{printf('%s',getreg('*'))}  0=  %-0.40{printf('%s',getreg(0))}  1= %-0.40{printf('%s',getreg(1))}  2= %-0.40{printf('%s',getreg(2))} 3= %-0.40{printf('%s',getreg(3))} x= %-0.40{printf('%s',getreg('x'))}"
		let g:airline_section_error_temp= g:airline_section_error
		let g:airline_section_error=""
		let g:airline_section_warning_temp= g:airline_section_warning
		let g:airline_section_warning=""
	else
		let g:airline_section_error= g:airline_section_error_temp
		let g:airline_section_warning = g:airline_section_warning_temp
		let g:airline_section_a= g:airline_section_a_temp
		let g:airline_section_x= g:airline_section_x_temp
		let g:airline_section_y= g:airline_section_y_temp
		let g:airline_section_z= g:airline_section_z_temp
		let g:airline_section_c= '%<%{tabpagenr()} %<%{getcwd()} | %f%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
	endif
	:AirlineRefresh
	"call airline#extensions#tabline#buflist#invalidate()
	":redraw!
endfunction

if has('nvim')
	let g:airline#extensions#tabline#enabled = 1
	"let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing', 'long', 'mixed-indent-file', 'conflicts' ]
	let g:airline#extensions#whitespace#checks = [ 'indent', 'conflicts' ]
	" add the current folder to the display
	let g:airline_section_c= '%<%{tabpagenr()} %<%{getcwd()} | %f%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
    "let g:airline#extensions#branch#vcs_checks = []
	if !exists('g:gui_oni')
		let g:airline_powerline_fonts = 1
		set t_Co=256
	endif
endif

let g:clang_library_path='/Applications/Xcode.app/Contents/Developer/usr/lib/llvm-gcc/4.2.1/'
"let g:session_autosave='yes'
let g:EnhancedJumps_CaptureJumpMessages = 0
let g:gruvbox_contrast_dark = 'hard'
" let g:pymode_python = 'PY'

"let g:multi_cursor_select_all_key      = '<C-L>'

" Plugin configurations
set wildignore+=/node_modules/*,*/.eggs/*
let g:ctrlp_match_window = 'max:20'
let g:ctrlp_show_hidden = 1


let g:plug_url_format = 'https://github.com/%s.git'

"asdasdasd
"autocompleting
set wildmode=list:longest,list:full
" File type patches

""autocmd FileType java setlocal omnifunc=javacomplete#Complete
"au BufNewFile,BufRead *.jbuilder setf ruby
"au BufNewFile,BufRead *.json.jbuilder setf ruby
"au BufNewFile,BufRead *.json setf javascript
"au BufNewFile,BufRead *.slim setf slim
"au BufNewFile,BufRead *.html.slim setf slim

    let g:trans_directions_list = [
        \['en', 'he'],
        \['he', 'en'],
    \]
let g:trans_bin = "~/.vim"
" Lint
"


"
"ALE
"
let g:ale_cursor_detail =0
let g:ale_close_preview_on_insert =1
let g:ale_completion_enabled = 0
let g:ale_linters_explicit = 1
"let g:ale_enabled = 0

let g:ale_linters = {'tex': 'all'}
"autocmd FileType tex let &l:ale_enabled=1
"let g:ale_linters = {
			"\ 'javascript':       ['eslint'],
			"\ 'latex'     :       ['chktex','lacheck','proselint','textlint','latexindent'],
			"\ 'tex'       :       ['chktex','lacheck','proselint','textlint','latexindent','texlab','vale','writegood'],
			"\ 'python'    :       ['black']
			"\ }
"let g:ale_fixers = {'*' :[
			"\  'textlint' , 'latexindent','prettier.vim','mix_format','generic','autopep8','bibclean','black','brittany','clangformat','clangtidy','cmakeformat','dartfmt','dfmt','elm_format','eslint', 
			"\ 'fecs','fixjson','floskell','generic','generic_python','gnatpp','gofmt','goimports','gomod','google_java_form','hackfmt','help','hfmt','hindent','hlint','importjs','isort','jq','ktlint','latexindent','mix_format',
			"\ 'ocamlformat','ocp_indent','perltidy','pgformatter','php_cs_fixer','phpcbf','prettier','prettier_eslint','prettier_standar','puppetlint','qmlfmt','refmt','reorder_python_i','rubocop','rufo','rustfmt','scalafmt',
			"\ 'shfmt','sorbet','sqlfmt','sqlformat','standard','standardrb','stylelint','styler','stylish_haskell','swiftformat','terraform','textlint','tidy','tslint','uncrustify','xmllint','xo','yapf'] }
let g:ale_fixers = { 'python' : ['black'],'tex':['latexindent','textlint'],'text':['textlint']}
" E501: line too long
" W503: line ending before operator
" E261: two spaces before inline comment
" E241: multiple spaces after ':' (formatted dict)
" E272: multiple spaces before keyword (formatted dict)
let g:ale_python_flake8_args="--ignore=E501,W503,E261,E241,E272"


let g:SimpylFold_docstring_preview = 1
if !exists('g:deoplete#omni#input_patterns')
      let g:deoplete#omni#input_patterns = {}
  endif
  let g:deoplete#omni#input_patterns.tex = '\\(?:'
        \ .  '\w*cite\w*(?:\s*\[[^]]*\]){0,2}\s*{[^}]*'
        \ . '|\w*ref(?:\s*\{[^}]*|range\s*\{[^,}]*(?:}{)?)'
        \ . '|hyperref\s*\[[^]]*'
        \ . '|includegraphics\*?(?:\s*\[[^]]*\]){0,2}\s*\{[^}]*'
        \ . '|(?:include(?:only)?|input)\s*\{[^}]*'
        \ . '|\w*(gls|Gls|GLS)(pl)?\w*(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
        \ . '|includepdf(\s*\[[^]]*\])?\s*\{[^}]*'
        \ . '|includestandalone(\s*\[[^]]*\])?\s*\{[^}]*'
        \ .')'

let g:auto_save_events = ["InsertLeave", "TextChanged","CursorHold"]
  
"if exists('g:deoplete#enable_at_startup')
let g:deoplete#enable_at_startup = 1
"call deoplete#custom#source('buffer', 'filetypes', ['tex','vim'])
":CocDisable
"endif
" Language configuration
"let g:jedi#popup_on_dot = 0
"let g:jedi#popup_select_first = 0
"let g:jedi#show_call_signatures = 1
"let g:jedi#smart_auto_mappings = 0 " disable 'from X ' automatically typing 'import'

let g:JavaComplete_ImportSortType = 'packageName'

let g:ale_ruby_rubocop_options="--except "
  + "Metrics/BlockLength,"
  + "Metrics/LineLength,"
  + "Style/MutableConstant,"
  + "Style/NegatedIf,"
  + "Style/Not,"
  + "Style/StringLiterals,"
  + "Style/TrailingCommaInLiteral,"
  + "Style/WordArray"
  "disable categories of refcatoring and comment
let g:ale_python_pylint_options = '--disable=C,R'
let g:ale_javascript_eslint_options="--config ".$HOME."/.vim/.eslintrc.yml"
if has('nvim')
	let g:session_menu = 0 "disable session menu for vim-session
endif
let g:session_lock_enabled=0
let MRU_File = $HOME . '/.vim/vim_mru'

set foldmethod=syntax
set foldnestmax=99

let g:is_pythonsense_suppress_motion_keymaps = 0

let NERDTreeShowHidden=1
let g:ctrlp_max_filescs_workspaces=20000
let g:ctrlp_max_depth=40


"ctrlspace

let g:CtrlSpaceLoadLastWorkspaceOnStart = 0
"endif
let g:CtrlSpaceSaveWorkspaceOnSwitch = 0
let g:CtrlSpaceSaveWorkspaceOnExit = 0
"let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
"display registers in the status bar



let g:CtrlSpaceUseArrowsInTerm = 1

"call ctrlspace#init#Init()
"change in ctrlspace
let g:defRoot= g:vimloc

"easymotion
"


let g:EasyMotion_do_mapping =1

let g:EasyMotion_smartcase = 1

" Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion
let g:EasyMotion_off_screen_search = 1
"

" Ultisnips
"function! UltiSnips#map_keys#MapKeys() abort
    "if exists("g:UltiSnipsExpandOrJumpTrigger")
        "exec "inoremap <silent> " . g:UltiSnipsExpandOrJumpTrigger . " <C-R>=UltiSnips#ExpandSnippetOrJump()<cr>"
        "exec "snoremap <silent> " . g:UltiSnipsExpandOrJumpTrigger . " <Esc>:call UltiSnips#ExpandSnippetOrJump()<cr>"
    "elseif exists("g:UltiSnipsJumpOrExpandTrigger")
        "exec "inoremap <silent> " . g:UltiSnipsJumpOrExpandTrigger . " <C-R>=UltiSnips#JumpOrExpandSnippet()<cr>"
        "exec "snoremap <silent> " . g:UltiSnipsJumpOrExpandTrigger . " <Esc>:call UltiSnips#JumpOrExpandSnippet()<cr>"
    "elseif g:UltiSnipsExpandTrigger == g:UltiSnipsJumpForwardTrigger
        "exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=UltiSnips#ExpandSnippetOrJump()<cr>"
        "exec "snoremap <silent> " . g:UltiSnipsExpandTrigger . " <Esc>:call UltiSnips#ExpandSnippetOrJump()<cr>"
    "else
        "exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=UltiSnips#ExpandSnippet()<cr>"
        "exec "snoremap <silent> " . g:UltiSnipsExpandTrigger . " <Esc>:call UltiSnips#ExpandSnippet()<cr>"
    "endif
    "exec "xnoremap <silent> " . g:UltiSnipsExpandTrigger. " :call UltiSnips#SaveLastVisualSelection()<cr>gvs"
    "if len(g:UltiSnipsListSnippets) > 0
        "exec "inoremap <silent> " . g:UltiSnipsListSnippets . " <C-R>=UltiSnips#ListSnippets()<cr>"
        "exec "snoremap <silent> " . g:UltiSnipsListSnippets . " <Esc>:call UltiSnips#ListSnippets()<cr>"
    ""endif

    "snoremap <silent> <BS> <c-g>"_c
    "snoremap <silent> <DEL> <c-g>"_c
    "snoremap <silent> <c-h> <c-g>"_c
    "snoremap <c-r> <c-g>"_c<c-r>
    "endf
    "let g:UltiSnipsJumpForwardTrigger = '<tab>'
    "let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
    "
    let g:UltiSnipsRemoveSelectModeMappings = 1
    let g:UltiSnipsExpandTrigger = '<c-g>'
    let  g:UltiSnipsJumpForwardTrigger   =     '<c-j>'
    let  g:UltiSnipsJumpBackwardTrigger  =     '<c-k>'
    let g:UltiSnipsListSnippets = '\ulv'
    "
    "

    "Nerdtree
    "
    function! NERDDoClose()
        let node = g:NERDTreeFileNode.GetSelected()
        if !(node.path.isDirectory)
            execute "norm x"
        elseif node.path.isDirectory && (node.isOpen==1)
            execute "norm \<CR>zt"
        endif
    endfunction

    function! NERDDoOpen()
        let node = g:NERDTreeFileNode.GetSelected()
        if node.path.isDirectory && (node.isOpen==0)
            execute "norm \<CR>ztj"
        endif
    endfunction

    function! DoClose()
        PY<<EOF
        import vim
        nod=netranger.api.NETRApi.ranger.cur_node
        cur_ind=int(vim.eval("line('.')")) - 1
        for i in range(cur_ind,0,-1):
            nod=netranger.api.NETRApi.ranger.cur_buf.nodes[i]
            if nod.is_DIR:
                if (nod.expanded):
                    netranger.api.NETRApi.ranger.cur_buf.set_clineno_by_node(nod)
                    netranger.api.NETRApi.ranger.cur_buf.clineNo=i
                    netranger.api.NETRApi.ranger.NETRToggleExpand()
                    break
                    EOF
                endfunction

                function! DoOpen()
                    PY<<EOF
                    import vim
                    nod=netranger.api.NETRApi.ranger.cur_node
                    if nod.is_DIR:
                        if not (nod.expanded):
                            netranger.api.NETRApi.ranger.NETRToggleExpand()
                            vim.command("norm kztjj")
                            EOF
                        endfunction

                        function! Duplicate(dst)
                            PY dst=vim.eval('a:dst')
                            PY import os
                            PY di=vim.eval('getcwd()')
                            PY nod=netranger.api.NETRApi.ranger.cur_node
                            PY fil=nod.name
                            PY import fs_server
                            PY fs_server.cp(os.path.join(di,fil),os.path.join(di,dst))
                        endfunction
                        " other
                        "To use for consecutive searches. Saves the need to enter search seperately
"each time. TODO: only on file xzt
"let g:NETRIgnore=[]
"
function! ShowHid()
if !exists('g:showhid')
	PY netranger.api.NETRApi.ranger.NETRToggleShowHidden()
	let g:showhid=1
endif
endfunction

let g:NETRDefaultMapSkip = ['m']
let g:NETRBookmarkGo = ["M"]
"let g:NETRDefaultMapSkip = ['l']
"let g:NETRBufPanelOpen = ['l']
let g:NETRMinFileNumToLoadInParallel=9999999999
let g:NETROpenCmd="edit"
let g:NETRPreviewDefaultOn=0
" NETRANGER autocmds
"let g:NETRAutochdir="a"
" sort by modified
:autocmd FileType netranger setlocal noswapfile
call EasyMotion#command_line#cmap(["<C-K>","<CR><CR>:call DoOpen()<CR>"])
:autocmd FileType netranger nmap <buffer> R SM
:autocmd FileType netranger cmap <buffer> <C-K> <CR><CR>
:autocmd FileType netranger nmap <buffer> <space> za
:autocmd FileType netranger nmap <buffer> <M-Right> :call DoOpen()<CR><c-s>
:autocmd FileType netranger cmap <buffer> <M-Right> <CR>:call DoOpen()<CR><c-s>
:autocmd FileType netranger nmap <buffer> <M-left> :call DoClose()<CR>
:autocmd FileType netranger nmap <buffer> <leader>sp :call CloseAllWindowsButCurrent()<CR>:vnew %<CR>
:autocmd FileType netranger cmap <buffer> <M-left> :call DoClose()<CR>
":autocmd FileType netranger nmap <buffer> <C-K> :call DoOpen()<CR><c-s>
":autocmd FileType netranger cmap <buffer> <C-K> <CR>:call DoOpen()<CR><c-s>
":autocmd FileType netranger nmap <buffer> <C-N> :call DoClose()<CR>
":autocmd FileType netranger cmap <buffer> <C-N> :call DoClose()<CR>
:autocmd FileType netranger nnoremap <buffer> cd :PY netranger.api.NETRApi.ranger.NETRVimCD()<CR>
:autocmd FileType netranger nnoremap <buffer> CD :exe "edit ". getcwd()<CR>
":autocmd FileType netranger mm :LeaderfMru<CR>
":autocmd FileType netranger nnoremap <buffer> <CR>  :call feedkeys("ep")<CR>
:autocmd FileType netranger command! -nargs=* DF call Duplicate(<f-args>)

":autocmd FileType nerdtree cmap <buffer> <M-Right> <CR>:call DoOpen2()<CR>Y
:autocmd FileType nerdtree cmap <buffer> <M-Right> <CR>:call DoOpen()<CR><c-s>
:autocmd FileType nerdtree cmap <buffer> <M-left> <CR>x
:autocmd FileType nerdtree nmap <buffer> <M-Right> :call DoOpen()<CR><c-s>
"<CR>ztj,
:autocmd FileType nerdtree nmap <buffer> <M-left> x

"leaderf
"
"command! -bang -nargs=* LinesWithPreview call fzf#vim#grep( 'rg --with-filename --column --line-number --no-heading --color=always --smart-case . '.fnameescape(expand('%')), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4.. --no-sort'}, 'up:50%', '?'), 1)
"let g:Lf_PreviewInPopup = 0 "causes bug 417
"command LeaderfTogglePreview let g:Lf_PreviewInPopup = !g:Lf_PreviewInPopup 
command! LeaderfEnablePreview let g:Lf_PreviewResult = {
			\ 'File': 1,
			\ 'Buffer': 1,
			\ 'Mru': 0,
			\ 'Tag': 0,
			\ 'BufTag': 1,
			\ 'Function': 1,
			\ 'Line': 1,
			\ 'Colorscheme': 0,
			\ 'Rg' : 1
			\}

command LeaderfDisablePreview let g:Lf_PreviewResult = {
\ 'File': 0,
\ 'Buffer': 0,
\ 'Mru': 0,
\ 'Tag': 0,
\ 'BufTag': 0,
\ 'Function': 0,
\ 'Line': 0,
\ 'Colorscheme': 0,
\ 'Rg' : 0
\}

let g:Lf_DevIconsFont = "DroidSansMono Nerd Font Mono"

set ambiwidth=double
let g:Lf_PreviewResult = {
			\ 'File': 0,
			\ 'Buffer': 1,
			\ 'Mru': 0,
			\ 'Tag': 0,
			\ 'BufTag': 1,
			\ 'Function': 1,
			\ 'Line': 1,
			\ 'Colorscheme': 0,
			\ 'Rg' : 1
			\}
let g:Lf_PopupPreviewPosition='top'
"When you go to normal mode , doing I inserts the line
"call win_execute(%d, "exec 'norm! %yy'")""" % (self._preview_winid, line_nr))
			"\'Line':[['I','"zyy:exec g:Lf_py "lineExplManager.quit()"<CR>"zp']],

"			\'Line':[['I','exec g:Lf_py "call win_execute(%d, "exec ''norm! "zyy''")" % (lineExplManager._preview_winid)<CR>:exec g:Lf_py "lineExplManager.quit()"<CR>"zp']]
let g:Lf_NormalMap ={ 
			\ 'Line':[['I','"zyt[:exec g:Lf_py "lineExplManager.quit()"<CR>"zp']],
			\ 'File':[['I','"zyy:exec g:Lf_py "lineExplManager.quit()"<CR>"zp']],
		\ 'History' :[['I','"zyy:exec g:Lf_py "lineExplManager.quit()"<CR>"zp']]
			\} 

let g:Lf_StlSeparator = { 'left': '', 'right': '' }

let g:Lf_StlColorscheme = 'powerline'
"Make c-h , c-l a valid option in leaderf
let g:Lf_CommandMap = {'<C-k>':['<C-h>'], '<C-j>':['<C-l>'], '<Down>': ['<C-j>','<Down>'], '<UP>': ['<C-k>','<UP>']}

let g:Lf_MruMaxFiles=100000
let g:Lf_ShowHidden  = 1
let g:Lf_MaxCount = 0
let g:Lf_PreviewInPopup =0

let g:Lf_PopupHeight =0.5
let g:Lf_PopupWidth =0.9
let g:Lf_WindowPosition = 'popup'

""ideally would be called each time
let g:Lf_PopupPosition=[max([float2nr(&lines * 0.4),10]),1]
let g:Lf_CacheDirectory = "c:\\users\\ekarni\\.vim\\lcache"
let g:Lf_IndexTimeLimit =7
let g:Lf_RgConfig = [ "--max-columns=150"]
let g:Lf_WorkingDirectoryMode = 'c'

"FZF
"
function! FZFOpen(command_str)
  if (expand('%') =~# '^N:.*' && winnr('$') > 1)
    exe "normal! \<c-w>\<c-w>"
  endif
  exe 'normal! ' . a:command_str . "\<cr>"
endfunction
command! -bang -nargs=* FzfRgB
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>).' , 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=* FzfRg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=* FzfRgDir
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case "" '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

let g:fzf_action = {'ctrl-o' : '!open'}
"let g:fzf_history= "~/.fzf/history"
let g:fzf_history=  "C:\\users\\ekarni\\.fzf\\history_f"
set shell=cmd.exe
let $FZF_DEFAULT_OPTS="--history=" . ("C:/users/ekarni/.fzf/history_file")
" had to change ~/.fzf to add escape for default_OPTS
"#. "\\.fzf\\history_file"
"nvim-ipy stuff
let g:nvim_ipy_perform_mappings=0


"
"Multicursors
"
"
let g:VM_maps = {}
let g:VM_maps["Run Normal"] = '\['

let g:VM_mouse_mappings=1

"vimtex

let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abmg'  "'abdmg'
let g:vimtex_enabled=1
let g:vimtex_mappings_override_existing=1
let g:vimtex_imaps_enabled=0
"let g:vimtex_mappings_disable = {
	"\ 'n': ['tse', 'tsd','tsD','tsc'],
	"\ 'x': ['tsd','tsD','tsc']
	"\}
let g:vimtex_complete_recursive_bib=1
"let g:vimtex_fold_manual=1
let g:vimtex_fold_enabled =1
"autocmd BufEnter *.tex set foldmethod=expr
"autocmd BufEnter *.tex set foldexpr=vimtex#fold#level(v:lnum)
"autocmd BufEnter *.tex set foldtext=vimtex#fold#text()
"
"let g:vimtex_view_method = 'skim'
let g:vimtex_view_method = 'general'
let g:vimtex_compiler_progname = 'nvr'
"    \ 'build_dir' : '/tmp/builddir',
  let g:vimtex_view_general_viewer = 'SumatraPDF'
  let g:vimtex_view_general_options
      \ = '-reuse-instance -forward-search @tex @line @pdf'
  let g:vimtex_view_general_options_latexmk = '-reuse-instance'

let g:vimtex_compiler_latexmk = {
    \ 'backend' : 'nvim',
    \ 'background' : 1,
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'options' : [
    \ '-g',
    \ '-f-',
    \   '-no-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}
"custom vimtex settings
 let g:mathshortcuts = ''

"supertab 
let g:SuperTabMappingForward = '<tab>'
let g:SuperTabMappingBackward = '<s-tab>'
let g:SuperTabDefaultCompletionType = "<c-x><c-n>"
let g:SuperTabContextDefaultCompletionType = "<c-x><c-n>" 
let g:SuperTabLongestEnhanced=1
let g:SuperTabLongestHighlight=1


"custom

"


"let $NVIM_COC_LOG_LEVEL = 'debug

"custom vimtex setting
"YCM

let g:ycm_filetype_whitelist = {'c': 1,'cpp':1} "'tex':1

if g:on_ek_computer
"JDevlieghere/dotfiles
	"let g:ycm_global_ycm_extra_conf= '~/vimpy3/globalycm.py'
endif

"Coc
"
command! -nargs=0 Format :call CocAction('format')
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

let $NVIM_COC_LOG_LEVEL = 'debug'
"that is a patch in coc that remove some files
"let g:coc_files=' *.py,*.tex,*.vimrc '
let g:coc_files=' *.py '
"let g:coc_files=' * '
"
 "//"languageserver": {
 "//   "ccls": {
 "//     "command": "ccls",
 "//     "filetypes": ["c", "cpp", "objc", "objcpp"],
 "//     "rootPatterns": [".ccls", "compile_commands.json", ".vim/", ".git/", ".hg/"],
 "//     "initializationOptions": {
 "//        "cache": {
 "//          "directory": "/tmp/ccls"
 "//        }
 "//      }
 "//   }
 " } ,
 "
 "vimspector
" "
 ""
""let g:vimspector_base_dir=expand( '$HOME/.vim/plugged/vimspector' )
 
""let g:vimspector_sidebar_width = 80
""let g:vimspector_code_minwidth = 85
""let g:vimspector_code_maxwidth = 105
""let g:vimspector_terminal_minwidth = 75
""let g:vimspector_terminal_maxwidth = 85
""let g:vimspector_bottombar_height = 25
""{
""  "reportGeneralTypeIssues": false,
""
""   "reportUnknownParameterType":false,
""
""   "reportUnknownArgumentType":false,
""
""   "reportUnknownLambdaType":false,
""
""   "reportUnknownVariableType":false,
""
""   "reportUnknownMemberType":false
""   }
"textobj
"
let g:textobj_function_no_default_key_mappings=1

"fugitive
"
"C:\Program Files\Git\bin
"let g:fugitive_git_executable = 'C:\\Program Files\\Git\\bin\\git.exe'

"Bookmarks
"

"targets
"
"
"autocmd User targets#mappings#user call targets#mappings#extend({
    "\ ',': {},
    "\ })
let g:neoterm_eof = "\r"
"quickscope
"
"unblevable
" Trigger a highlight only when pressing f and F.
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

"nmap F <Plug>(QuickScopeF)
"omap F <Plug>(QuickScopeF)
"xmap F <Plug>(QuickScopeF)

"nmap <c-f> <Plug>(QuickScopef)
"nmap T <Plug>(QuickScopeT)
"omap T <Plug>(QuickScopeT)
"xmap T <Plug>(QuickScopeT)

"nmap T <Plug>(QuickScopeT)
"omap T <Plug>(QuickScopeT)
"xmap T <Plug>(QuickScopeT)

" <M-t> is within mapping

let g:qs_ignorecase=1

highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
"sneak
let g:sneak#s_next = 0
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
let g:sneak#use_ic_scs = 1

"vim terminal
"let g:Terminal_PyVersion =3 
"let g:Terminal_PyExe = g:python3_host_prog
"
"
"let g:clever_f_ignore_case=1
"let g:clever_f_not_overwrites_standard_mappings=1
"let g:clever_f_timeout_ms=10000
"let g:clever_f_chars_match_any_signs=';'
"<Plug>(clever-f-f)                    *<Plug>(clever-f-f)*
"<Plug>(clever-f-F)                    *<Plug>(clever-f-F)*
"<Plug>(clever-f-t)                    *<Plug>(clever-f-t)*
"<Plug>(clever-f-T)                    *<Plug>(clever-f-T)*

"<Plug>(clever-f-repeat-back)          *<Plug>(clever-f-repeat-back)*
function! DisableT(a)
    silent! nunmap <c-b>
    nmap <c-b> <plug>ttt
endfunction
augroup lightspeed_active
autocmd!
autocmd User LightspeedEnter nmap <expr> <c-b> "<Plug>Lightspeed_,_ft"
autocmd User LightspeedLeave let g:tm=timer_start(1000,'DisableT',{'repeat':1})
augroup end
"nmap <c-b> <Plug>Lightspeed_;_ft
"nmap <expr> <c-b> "<Plug>Lightspeed_;_ft"

"function! DisableT(a)
    "silent! nunmap t 
    "silent! nunmap T
    "nmap t :w<CR>
"endfunction
"let g:lightspeed_active =0
"augroup lightspeed_active
"autocmd!
"autocmd User LightspeedEnter let g:lightspeed_active = 1  
"autocmd User LightspeedLeave let g:lightspeed_active = 0 | :echo "b" 
"augroup end
"let g:lightspeed_last_motion = ''
"augroup lightspeed_last_motion
    "autocmd!
    "autocmd User LightspeedEnter let g:lightspeed_last_motion = 'sx'
    "autocmd User LightspeedEnter let g:lightspeed_last_motion = 'ft'
"augroup end
"map <expr> , g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_,_sx" : "<Plug>Lightspeed_,_ft"
"map <expr> t g:lightspeed_last_motion == 'ft' ? "<Plug>Lightspeed_t" : "<Plug>Lightspeed_;_ft"
"map <expr> , g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_,_sx" : "<Plug>Lightspeed_,_ft"
  let g:qs_highlight_on_keys = []

 let g:EasyMotion_leader_key='\rs'

let g:ctrlsf_backend = 'rg'
let g:Lf_Rg='C:\ProgramData\chocolatey\bin\rg.EXE'
let g:neoformat_enabled_powershell=['PowerShellBeautifier']


let g:peekaboo_ins_prefix = 0

let g:airline_extensions = ['branch', 'fugitiveline','tabline','hunks']

let g:autotagVerbosityLevel	= 10 
let g:gutentags_define_advanced_commands=1
let g:gutentags_file_list_command = {
    \ 'markers': {
        \ '.git': 'git ls-files *.py *.vim',
        \ },
    \ }
"au FileType python call gutentags#setup_gutentags()
let g:pymode=1
let g:pymode_rope = 1
let g:pymode_rope_autoimport =1
let g:pymode_warnings = 0
let g:pymode_trim_whitespaces = 0
let g:pymode_options = 0
let g:pymode_options_colorcolumn = 0
let g:pymode_indent = 0
let g:pymode_motion = 0
let g:pymode_doc = 0
let g:pymode_virtualenv = 0
let g:pymode_run = 0
let g:pymode_breakpoint = 0
let g:pymode_lint = 0
let g:pymode_lint_on_write = 0
let g:pymode_lint_message = 0
let g:pymode_lint_cwindow = 0
let g:pymode_lint_signs = 0
let g:pymode_rope_regenerate_on_write = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_syntax = 0
let g:pymode_syntax_slow_sync = 0
let g:pymode_syntax_all = 0
let g:pymode_folding = 0
let g:pymode_debug = 0
