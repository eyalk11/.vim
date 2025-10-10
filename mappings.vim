
let fil="/\caccess attribute\\|access member\\|undefined \\|expected \\|syntax\\|not defined\\|Arguments missing\\|No Parameter\\|Expected.*arguments/"
"let fil="/\caccess member\|undefined \|expected \|syntax\|not defined\|Arguments missing\|No Parameter\|Expected.*arguments/"
nnoremap <leader>XF <CMD>lua vim.diagnostic.setloclist()<CR><CMD>exe "Lfilter " . fil<CR>   
nnoremap <leader>xf <CMD>call DiagnosticsGitOnly()<CR><CMD>exe "Cfilter " . fil<CR>
"nnoremap <leader>xf <CMD>lua vim.diagnostic.setqflist()<CR><CMD>Cfilter /\caccess member\\|undefined \\|expected \\|syntax\\|not defined\\|Arguments missing\\|No Parameter/<CR>   
 function! DiagnosticsGitOnly() abort
     " First get all diagnostics
     lua vim.diagnostic.setqflist()
     
     " Get list of git files
     let tmp = getcwd()
     let git_cmd = systemlist("git rev-parse --show-toplevel")
     if v:shell_error
         echo "Not in a git repository"
         return
     endif
     
     let top = git_cmd[0]
     exe 'cd ' . top
     let git_files = systemlist("git ls-files --full-name 2>NUL")
     exe 'cd ' . tmp
     
     " Convert git files to full paths and create a dictionary for fast lookup
     let git_files_dict = {}
     let diag_list = {} 
     for file in git_files
         " Handle Windows paths by replacing forward slashes with backslashes
         let full_path = fnamemodify(top . '/' . file, ':p')
         let git_files_dict[full_path] = 1
     endfor
     
     " Filter quickfix list to only include git files
     let qf_list = getqflist()
     let filtered_list = []
     
     for item in qf_list
         let file_path = bufname(item.bufnr)
         let full_path = fnamemodify(file_path, ':p')
         let file_path = substitute(full_path, '\\', '/', 'g')
         let file_path = substitute(full_path, '\', '/', 'g')
 
         let diag_list[file_path] =1
         " Check if file is in git files dictionary
         "echo git_files_dict
         "echo file_path
         "echo has_key(git_files_dict, file_path)
         if has_key(git_files_dict, file_path)
             if item.type!='W'
             call add(filtered_list, item)
         endif
         endif
     endfor
     
     "echom (filtered_list)
     " Update quickfix list with filtered results
     call setqflist([], 'r', {'items': filtered_list, 'title': 'LSP Diagnostics (Git files only)'})
 
     
     " Apply the existing filter pattern
 endfunction
 
 
 imap <c-l> <c-o>u
 cnoremap <c-y> <c-v>
 function! AlignWithTopLine() range
 " Handle case when selection is at the start of the file
 if a:firstline <= 1
     " If at the start of file, use default indentation (0)
     let reference_indent = 0
     let above_line = ""
 else
     " Find the first non-empty line above the selection
     let above_line_num = a:firstline - 1
     while above_line_num >= 1 && getline(above_line_num) =~ '^\s*$'
         let above_line_num = above_line_num - 1
     endwhile
     
     " If we couldn't find a non-empty line, use default indentation
     if above_line_num < 1
         let reference_indent = 0
         let above_line = ""
     else
         let above_line = getline(above_line_num)
         let reference_indent = indent(above_line_num)
     endif
 endif
 
 " Check characteristics of the line above (if it exists)
 let ends_with_colon = !empty(above_line) && above_line =~# ':$'
 let starts_with_special = !empty(above_line) && above_line =~# '^\s*\(with\|await\|if\|for\|while\|def\|class\)'
 let is_continuation = !empty(above_line) && above_line =~# '\((\|\[\|{\).*\(,\|\\\)$'
 
 " Determine target indentation
 let target_indent = reference_indent
 
 " Handle different cases for alignment
 if ends_with_colon || starts_with_special
     " For block starts or special constructs, add one level of indentation
     let target_indent = reference_indent + &shiftwidth
 elseif is_continuation
     " For line continuations (ending with comma or backslash), align with extra indent
     let target_indent = reference_indent + &shiftwidth
 endif
 
 " Get the first line's current indentation as reference for relative shifts
 let first_line = getline(a:firstline)
 let first_line_indent = indent(a:firstline)
 let first_line_content = substitute(first_line, '^\s*', '', '')
 
 " Check if the first line of selection is a continuation of a previous statement
 let first_line_is_continuation = !empty(above_line) && 
                                \ (above_line =~# '\((\|\[\|{\|\\$\|,$\)' && 
                                \ first_line_content !~# '^\()\|]\|}\)')
 
 " Calculate the indentation shift needed
 let indent_shift = 0
 if first_line_is_continuation
     let indent_shift = target_indent - first_line_indent
 else
     let indent_shift = target_indent - first_line_indent
 endif
 
 " Apply the indentation to all lines in the selection
 for lineno in range(a:firstline, a:lastline)
     let line = getline(lineno)
     let current_indent = indent(lineno)
     let current_line_content = substitute(line, '^\s*', '', '')
     
     " Skip empty lines
     if current_line_content == ''
         continue
     endif
     
     " Calculate new indentation preserving relative structure
     let new_indent = current_indent + indent_shift
     
     " Special handling for closing brackets/braces/parentheses
     if current_line_content =~# '^\()\|]\|}\)'
         " Closing brackets align with the opening line (one level back)
         let new_indent = max([0, target_indent - &shiftwidth])
     endif
     
     " Ensure indentation is never negative
     let new_indent = max([0, new_indent])
     
     " Create the new line with proper indentation
     let new_line = repeat(' ', new_indent) . current_line_content
     
     call setline(lineno, new_line)
 endfor
 endfunction
 
 function! ConditionalAlign()
 if &filetype == 'python'
     " Store the original selection boundaries
     let l:start_line = a:firstline
     let l:end_line = a:lastline
     
     " Run autopep8 on the selection, assume indentation = 0 . we add def for
     " indention to work in global scopre
    let stat='!cat - | sh -c "' . "echo 'def xxaa():' && cat -  ". '"'
    "echo l:start_line . ',' . l:end_line . stat . ' | autopep8 - | sh -c "tail -n +2"'
    silent execute l:start_line . ',' . l:end_line . stat . ' | autopep8 - | sh -c "tail -n +2"'
    "sh -c "tail -n +2"'
     silent execute l:start_line . ',' . l:end_line . stat . ' | autopep8 - | sh -c "tail -n +2"'
     norm gv<
     silent execute l:start_line . ',' . l:end_line . 'call AlignWithTopLine()'
 else
     normal! gv=
 endif
 endfunction
 
 
 "vnoremap = :'<,'>call ConditionalAlign()<CR>
 
 function! FormatCurrentBlock()
     " Determine the current block based on indentation
     let current_line = line('.')
     let current_indent = indent(current_line)
     let current_content = getline(current_line)
     
     " Check if current line is a block starter (ends with colon)
     let is_block_starter = current_content =~ ':\s*$'
     
     " Find the start of the block
     let start_line = current_line
     
     " If current line is a block starter, use it as the start
     if is_block_starter
         " Use current line as start
     else
         " Look for block start by going up
         while start_line > 1
             let prev_line = start_line - 1
             let prev_indent = indent(prev_line)
             let prev_content = getline(prev_line)
             
             " Check if previous line is a block starter
             let prev_is_starter = prev_content =~ ':\s*$'
             
             " Stop if we find a block starter or a line with less indentation
             if prev_is_starter || prev_indent < current_indent
                 if prev_is_starter
                     let start_line = prev_line
                 endif
                 break
             endif
             
             " Stop if we find an empty line
             if prev_content =~ '^\s*$'
                 break
             endif
             
             let start_line = prev_line
         endwhile
     endif
     
     " Find the end of the block
     let end_line = current_line
     let last_line = line('$')
     
     " If current line is a block starter, we need to find its body
     if is_block_starter
         let expected_indent = current_indent + &shiftwidth
         let end_line = current_line + 1
         
         " Find the first line with proper indentation
         while end_line <= last_line
             let next_indent = indent(end_line)
             let next_content = getline(end_line)
             
             if next_content !~ '^\s*$' && next_indent >= expected_indent
                 break
             endif
             
             let end_line += 1
         endwhile
     endif
     
     " Continue finding the end of the block
     while end_line < last_line
         let next_line = end_line + 1
         let next_indent = indent(next_line)
         let next_content = getline(next_line)
         
         " Stop if we find a line with less indentation than our block
         " For block starters, compare with expected indentation
         let compare_indent = is_block_starter ? (current_indent + &shiftwidth) : current_indent
         
         if next_indent < compare_indent || next_content =~ '^\s*$'
             break
         endif
         
         let end_line = next_line
     endwhile
     
     " Apply formatting to the determined block
     execute start_line . ',' . end_line . 'call ConditionalAlign()'
 endfunction
 
 " Map == to format the current block
 "nnoremap <expr> ==  &filetype == 'python'  ? "\<plug>fff" : "=="
 nmap <plug>fff :call FormatCurrentBlock()<CR>
 
 

let i = 1
while i <= 9
    execute 'nnoremap <Leader>' . i . ' <CMD>' . i . 'tabn<CR>'
    let i = i + 1
endwhile

nmap <S-Space> <CMD>CtrlSpace<CR>w


"mouse 
":redraw<CR>
"nmap <MiddleMouse> i
"imap <MiddleMouse> <ESCi>
"
"
"speical insert
nmap <RightMouse> <F12>
imap <RightMouse> <ESC>
inoremap <S-TAB> <esc><<^i
nmap <Home> ^
nmap <c-CR> <CMD>noh<CR><CMD>silent! Noice dismiss<CR>
nmap L: :lua 

"replace vanila
nnoremap <leader>& &
"get start of (next) string
"nmap <expr> & (getline('.')[col('.')-1]=='"a' <bar><bar> getline('.')[col('.')-1]== "'") ? "%" : "viqo\<ESC>h"
"nmap <expr> z& (getline('.')[col('.')-1]=='"' <bar><bar> getline('.')[col('.')-1]== "'") ? "%" : "vilq\<ESC>l"

nmap <expr> <Plug>NextQ (getline('.')[col('.')-1]=='"' <bar><bar> getline('.')[col('.')-1]== "'") ? "viq\<ESC>llviqo\<ESC>h" : "viqo\<ESC>h"
nmap <expr> <Plug>PrevQ (getline('.')[col('.')-1]=='"' <bar><bar> getline('.')[col('.')-1]== "'") ? "viqo\<ESC>hhvilq\<ESC>l" : "vilq\<ESC>l"
nmap & <Plug>NextQ
nmap <c-7> <Plug>PrevQ
"next block 
nmap <c-5> z%
"nmap <c-7> <Plug>PrevQ

"nnoremap ! `
"nnoremap !! ``

"the most command marks are in 
nnoremap <leader>. `.
nnoremap <leader>' ``



"recall command
nmap m/ <CMD>set noignorecase<CR><CMD>set noincsearch<CR>/
noremap m? <CMD>set incsearch<CR><CMD>set hlsearch<CR>?
function! ToggleSearch()
if &incsearch
    set noincsearch
    set nohlsearch
else
    set incsearch
    set hlsearch
endif
endfunction

nnoremap mS <CMD>call ToggleSearch()<CR>
":nmap q :exec "normal i".nr2char(getchar())."\e"<CR>
:nmap ( <CMD>exec "normal i".nr2char(getchar())."\e"<CR>
:nmap ) <CMD>exec "normal a".nr2char(getchar())."\e"<CR>
:nnoremap [( (<CR>
:nnoremap [9 (<CR>
:nnoremap [) (<CR>
:nnoremap [0 )<CR>
"qw inserts char after
nmap <Plug>(arpeggio-default:s) <CMD>call InsertBefore(v:count1)<CR>
nmap s :<C-U>call InsertBefore(v:count1)<CR>
"nnoremap F f
nmap S <CMD>call InsertAfter(v:count1)<CR>
"nnoremap q t

"The <M-t> provides omni tl-search 

nmap <M-f> <Plug>(easymotion-s2)

"replaacing default
"nnoremap zq q
"Alt - q is the new macro recording ....
"nnoremap <M-q> q

"nmap s <Plug>(easymotion-s)
"nmap S <Plug>(easymotion-s2)
"endif
"meaning u would be like search everywhere
"vmap s <Plug>(easymotion-sl)
"omap U <Plug>(easymotion-bd-tl)
vmap u <Plug>(easymotion-bd-fl)
"vmap U <Plug>(easymotion-bd-tl)
vmap U <Plug>(easymotion-bd-tl)

vnoremap <leader>U U
"vnoremap <leader>U U
"we use t for saving
nmap <nowait> t <CMD>let g:init=1<CR><CMD>w<CR>

" insert a single char
nnoremap <leader>` `
nnoremap m` `
"nnoremap <leader>t t
"we use m for multiple things as seconds leader
noremap <leader>Z m

nnoremap <leader>F F
"
"end only until the end and not one more
vnoremap <end> $h


nmap <nowait> , <CMD>Leaderf line --popup<CR>
nmap <m-,> <CMD>Telescope lsp_document_symbols<CR>
"nmap <nowait> , <CMD>Telescope current_buffer_fuzzy_find<CR>
"nmap <nowait> , <CMD>call Lff()<CR>
"function! Lff()
"py3 << EOF
"import cProfile
"import pstats
"profiler = cProfile.Profile()
"profiler.enable()
"anyHub.start('line')
"profiler.disable()
"stats = pstats.Stats(profiler).sort_stats('cumulative')
"stats.dump_stats('output.pstats')
"EOF
"endfunction

nmap m, <CMD>LeaderfEnablePreview<CR><CMD>Leaderf line --popup<CR>
"nnoremap <leader><c-t> <c-t>

"wroks with all letters but N
"nmap T <Plug>(easymotion-sl)

"
" _ mappings 
nmap _g <CMD>diffget<CR>
nmap _p <CMD>diffput<CR>
vmap _g :'<,'>diffget<CR>
vmap _p :'<,'>diffput<CR>

nmap _u <CMD>LastWindow<CR>

if g:on_ek_computer
nmap _U <CMD>Telescope my_last_windows<CR>
endif
nmap _. <CMD>cd ..<CR>
nmap _- <CMD>cd -<CR>
"previous window
nmap _P <CMD>wprevious<CR>
nmap _N <CMD>wnext<CR>
nmap _wo <CMD>WorkspacesOpen<CR>
nmap _f <CMD>lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>

"do comment out
map __ <leader>Cc
"uncomment
map _+ <leader>Cu
"Alternative buffer
map _# <CMD>e #<CR>

"Previous and next visited buffer <c-o> of course
"nmap <c-[> <bar><DOWN><CR>
"nmap <M-[> <bar><UP><CR>

nmap _t <CMD>exe "tabn ".g:lasttab<CR>
noremap _b <CMD>bnext<CR>
noremap _B <CMD>bprev<CR>

"Grammerous M- mappings
"imap <M-Down> <esc>
"imap <M-Up> <esc>
"imap <M-Left> <esc>
"imap <M-Right> <esc>

"nmap <M-Down> <Plug>(grammarous-move-to-next-error)    
"nmap <M-Up> <Plug>(grammarous-move-to-previous-error)
"nmap <M-Left> <Plug>(grammarous-open-info-window)      
"nmap <M-Right> <Plug>(grammarous-fixit)        

"F keys
noremap <F1> <CMD>execute ":help " . expand('<cword>')<CR>
"execut under cursor



nnoremap <F2> <CMD>exe getline(".")<CR>
nmap <S-F2> <CMD>exec "lua ". getline(".")<CR>
vmap <S-F2> "xy<CMD>exec "lua ".@x<CR>
vmap <F6> "xy<CMD>exec "lua " . "print(" . @x . ")"<CR>
vnoremap <F2> "xy<CMD>@x<CR>

"nmap <leader><F5> q:i<esc>
noremap <S-F3> <CMD>call Goprev()<CR>
noremap <S-F4> <CMD>call Gonext()<CR>
nnoremap <S-F6> "xddkk"xp
nnoremap <S-F7> "xyy"xp
nnoremap <S-F8> "xdd"xp

vmap <F3> "xygv:TREPLSendSelection<CR>
nmap <F3> <CMD>call AddInsert(getline('.'))<CR><CMD>TREPLSendLine<CR>
nmap <F4> <CMD>exec("Texec clear\r\n")<CR><CMD>exec("Texec &" .expand("%:p") . "\r\n")<CR>
nmap <F8> <CMD>exec("Texec clear\r\n")<CR>

"nmap <F3>        <Plug>VimspectorStepOut
"nmap <F4>        :call vimspector#Launch()<CR>
"nmap <F6>         <Plug>VimspectorContinue
"nmap <F7>        <Plug>VimspectorStepInto
"nmap _<F9>         <Plug>VimspectorAddFunctionBreakpoint
"nmap _<F9>         <Plug>VimspectorAddFunctionBreakpoint
"nmap _<F9>         <Plug>VimspectorAddFunctionBreakpoint
"nmap <F8>        <Plug>VimspectorStepOver
"nmap <F9>         <Plug>VimspectorToggleBreakpoint
"nmap <leader><F9> <Plug>VimspectorToggleConditionalBreakpoint
"nmap _<F9>         <Plug>VimspectorAddFunctionBreakpoint
"nmap _<F9>         <Plug>VimspectorAddFunctionBreakpoint
"nmap _<F9>         <Plug>VimspectorAddFunctionBreakpoint
"nmap _<F9>         <Plug>VimspectorAddFunctionBreakpoint
"nmap _<F9>         <Plug>VimspectorAddFunctionBreakpoint
"nmap _<F9>         <Plug>VimspectorAddFunctionBreakpoint


map <silent> <F5>         <Plug>(IPy-Run)
nmap <S-F5> <leader>rf
" or \rf

nmap <F13> <CMD>call StartSpecialInsert()<CR>i
nmap <F12> <CMD>call StartSpecialInsert()<CR>i
imap <F12> <c-o>
imap <F13> <ESC>



"call DisableKeys()


"ctrl commands
"

"faster
"nnoremap <m-,> <CMD>Leaderf line --recall<CR>


"nmap <C--> <Plug>Sneak_,
"nmap <C-=> <Plug>Sneak_;
nmap <C-=> <Plug>(easymotion-next)
nmap <C--> <Plug>(easymotion-prev)
nmap <c-_> <CMD>let g:EasyMotion_add_search_history=1<CR><Plug>(easymotion-sn)



"Ctrlspace 
"let g:CtrlSpaceDefaultMappingKey = ''
"nmap <C-b> :CtrlSpace w<CR>
"windows on tab
"nmap <c-U> <c-b>w

"if ($TERM=="xterm-256color")
    ""only on nvim
    "nmap  <C-/> :let g:EasyMotion_add_search_history=1<CR><Plug>(easymotion-sn)
"endif
"map <C-CR> <F13>
"imap <C-CR> <F13>
"imap <S-CR> <c-o>
function! Teasy()
if EasyMotion#SL(1,0,2)==0

normal l
endif 
endfunction


"!!! insert mode   Movements !!! 
"
" in insert mode M is same line , and <c-.> . Use <c-.> 
" in normal mode M is same line
"imap <M-f> <c-o><Plug>Lightspeed_s
"imap ` <c-o><Plug>Lightspeed_s
imap <silent><script><expr> <C-j> copilot#Accept("")
imap <silent><script><expr> <M-j> copilot#Next()
let g:copilot_no_tab_map = v:true
function! FF_Forward()
call quick_scope#Wallhacks('f')
return "\<c-o>\<Plug>Lightspeed_t"
endfunction
imap <expr> <c-'> FF_Forward()

function! FF_MF()
call quick_scope#Wallhacks('t')
return "\<c-o>\<Plug>Lightspeed_F"
endfunction
imap <expr> <m-'> FF_MF()

function! FF_f()
call quick_scope#Wallhacks('f')
return "\<c-o>\<Plug>Lightspeed_f"
endfunction
imap <expr> <c-/> FF_f()

function! FF_T()
call quick_scope#Wallhacks('t')
return "\<c-o>\<Plug>Lightspeed_T"
endfunction
imap <expr> <M-/> FF_T()

"function! FF_TT3()
"call quick_scope#Wallhacks('f')
"return "\<Plug>Lightspeed_t"
"endfunction
"nmap <expr> <c-t> FF_TT3()

function! FF_MF2()
call quick_scope#Wallhacks('t')
return "\<Plug>Lightspeed_F"
endfunction
nmap <expr> <m-'> FF_MF2()

function! FF_f2()
call quick_scope#Wallhacks('f')
return "\<Plug>Lightspeed_f"
endfunction
nmap <expr> <c-/> FF_f2()

function! FF_T2()
call quick_scope#Wallhacks('t')
return "\<Plug>Lightspeed_T"
endfunction
nmap <expr> <m-/> FF_T2()




"imap <c-\> <c-o>f
"imap <c-p> <c-o>T
""imap <c-t> <c-o>t
"imap <c-,> <c-o>f

autocmd FileType * inoremap <expr> <c-]> IsRegular() ? "<c-o><Plug>Lightspeed_s" : "<c-]>"
autocmd FileType * nnoremap <expr> <c-]> IsRegular() ? "<Plug>Lightspeed_s" : "<c-]>"
autocmd FileType * nnoremap <expr>  m<c-]> <c-]>
autocmd FileType * inoremap <expr> <c-[> IsRegular() ? "<c-o><Plug>Lightspeed_S" : "<c-[>"
autocmd FileType * nnoremap <expr> <c-[> IsRegular() ? "<Plug>Lightspeed_S" : "<c-[>"

autocmd FileType * inoremap <expr> <m-]> IsRegular() ? "<esc><Plug>Lightspeed_s" : "<m-]>"
autocmd FileType * inoremap <expr> <m-[> IsRegular() ? "<esc><Plug>Lightspeed_S" : "<m-[>"


"imap <tab> <c-o><Plug>Lightspeed_s
"imap <S-tab> <c-o><Plug>L`ightspeed_S
"nmap <M-/> <Plug>(easymotion-tl)
"imap <M-t> <c-o><CMD>call Teasy()<CR> 
nmap <M-t> <Plug>(easymotion-bd-tl)
imap <M-t> <c-o><Plug>(QuickScopet)
nmap <M-t> <Plug>(QuickScopet)
xmap <M-t> <Plug>(QuickScopet)
omap <M-t> <Plug>(QuickScopet)
"this is untill"
"map <Plug>cusF <CMD>call quick_scope#Wallhacks()<CR><Plug>(easymotion-sl)
"map <Plug>cusnf <CMD>call quick_scope#Wallhacks()<CR><Plug>(Lightspeed_f)
"map <Plug>cusnF <CMD>call quick_scope#Wallhacks()<CR><Plug>(Lightspeed_F)
function! FFn()
call quick_scope#Wallhacks('t')
return "\<Plug>Lightspeed_F"
endfunction
nmap <expr> f Ffn()
nmap <expr> F FFn()
function! Ffn()
call quick_scope#Wallhacks('f')
return "\<Plug>Lightspeed_f"
endfunction
nmap <expr> <Plug>(arpeggio-default:f) Ffn()
"nmap F <Plug>cusF
"nmap s <Plug>Lightspeed_s
"nmap S <Plug>Lightspeed_S
"nmap s <plug>Sneak_s
"nmap S <plug>Sneak_S

"Logical, scall v:lua.cmp.utils.feedkeys.call.run(27)
"ince in normal we have s and S
"imap <c-d> <c-o><Plug>(easymotion-bd-W)

"nmap <c-d> <Plug>(easymotion-bd-W)
"
"beginning of words
"
imap <M-d> <c-o><Plug>(easymotion-bl)
nmap <M-d> <Plug>(easymotion-bl)

"end of word 
imap <c-h> <c-o><Plug>(easymotion-bd-E)
nmap <c-h> <Plug>(easymotion-bd-E)

imap <M-h> <c-o><Plug>(easymotion-bd-el)
nmap <M-h> <Plug>(easymotion-bd-el)

nmap mL <Plug>(easymotion-bd-jk)

"imap <M-t> <c-o><Plug>(easymotion-tl)

nmap <M-s> <Plug>(easymotion-sl)
imap <M-s> <c-o><Plug>(easymotion-sl)
nmap ? <Plug>(easymotion-sl)

"nmap <A-s> <Plug>(easymotion-bd-sl)
"notice that q is easymotion bd everywhere 
"<M-t>

"finds the best next item and complete up to it. in Vim!
":imap <c-,> <c-X><c-V>
"imap <c-,> <c-o><Plug>(easymotion-bd-t)

"imap <c-c> <c-o><Plug>(easymotion-dineanywhere) 
"nmap <c-c> <Plug>(easymotion-sineanywhere) 
"one aine down
"nnoremap <c-t> <c-e>
"nnoremap <c-y> <c-u>
"nmap <c-t> <Plug>(easymotion-sl)

nmap <c-s> <CMD>let g:EasyMotion_add_search_history=1<CR><Plug>(easymotion-sn)
nmap <m-s> <Plug>(easymotion-tn)
vmap <c-s> <Plug>(easymotion-s2)

"search help , lift saving
nmap <c-f> mH
"nmap <c-g> <CMD>call CocActionAsync("doHover")<cr>

nmap <C-e> mn-

nmap <M-E> -mn+
nmap <M-e> -mn+

"repeat the move 
imap <c-;> <c-o>;
imap <c-\> <c-o><c-\>
"to map <c-;> in normal

imap <c-a> <c-o><c-a>
"inoremap ii
"complete just one char pumvisible()? " 
"x
"

"Insert mode actions
imap <Insert> <ESC>
nmap <Insert> <CMD>call StartSpecialInsert()<CR>i

imap <c-w> <c-o>db
imap <M-Right> <c-o>W
imap <M-Left> <c-o>B
imap <M-Up> <c-h>
imap <M-Down> <c-o><Plug>(easymotion-bd-wl)
"inoremap <c-k> <Cmd>call feedkeys("\<c-L>",'n')<CR>
"completes one char or  from dict 
inoremap <expr> <C-K>  pumvisible()? "<c-k>" : "<c-o><CMD>call RecallInserts(0)<CR>"
"inoremap <expr> <C-b>  pumvisible()? "<c-b>" : "<c-o><CMD>call RecallInserts(0)<CR>"
"imap <c-b> <c-o><CMD>call RecallInserts(0)<CR>
inoremap <c-b> <c-o><CMD>call GetAllInserts()<CR>
inoremap <c-end> <c-v>
nmap <Leader>gm :lua GotoMap()<CR>
"does chars 

inoremap <m-c-k> <c-x><c-k>
inoremap <c-f> <c-x><c-n>
"imap <c-z> <c-f><up><down>
"imap <c-z> <c-r>=SuperTab('n')<CR>
"Greatness , completes the text with one type
"Greatness

"function! DoCz()
"if pumvisible() 
    "if complete_info()['mode']=='keyword'
        "return complete_info()['selected'] ==-1 ?  feedkeys("\<c-r>SuperTab('n')") :  feedkeys("\<tab>\<s-tab>\<c-f>\<tab>") 
    "else 
        "return 0
        ""return complete_info()['selected'] ==-1 ?  feedkeys("\<c-f>\<tab>",'t') :  feedkeys("\<c-f>") 
    "endif 
"else 
    "return  feedkeys("\<c-f>",'t')
"endif 
"endfunction 

"inoremap <c-f> <c-x><c-n>
""imap <c-z> <c-f><up><down>
""imap <c-z> <CMD>call feedkeys("\<c-f>\<c-r>=SuperTab('n')<c-m>",'')<CR>
""Greatness , completes the text with one typ
""Greatness , completes
"requests
"return comple
"Greatness , completes
function! DoCz()
if pumvisible() 
    if complete_info()['mode']=='keyword'
        return complete_info()['selected'] ==-1 ? "\<tab>" : "\<c-f>\<Tab>\<S-Tab>"
        "return complete_info()['selected'] ==-1 ? "\<tab>" : "\<c-f>\<tab>\<c-r>=SuperTab('p')\<CR>"
        "return complete_info()['selected'] ==-1 ? "\<c-r>=SuperTab('n')\<CR>" : "\<c-f>\<c-r>=SuperTab('n')\<CR>\<c-r>=SuperTab('p')\<CR>"
    else 
        return complete_info()['selected'] ==-1 ? "\<c-f>\<tab>" : "\<c-f>\<tab>"
        "return complete_info()['selected'] ==-1 ? "\<c-f>\<c-r>=SuperTab('n')\<CR>" : "\<c-f>\<c-r>=SuperTab('n')\<CR>"
    endif 
else 
    return "\<c-f>"
endif 
endfunction 

imap <expr> <c-z> DoCz() 
imap <M-Space> <c-o>
imap <S-CR> <c-o>
" M-mappings

"nmap <silent> <M-J> <Plug>(ale_previous_wrap)
"nmap <silent> <M-j> <Plug>(ale_previous_wrap)
"nmap <silent> <M-K> <Plug>(ale_next_wrap)
"nmap <silent> <M-k> <Plug>(ale_next_wrap) a\n/

imap <M-g> <Plug>(IPy-Complete)
nmap <M-k> <Plug>(IPy-WordObjInfo) 
nmap <M-r> <CMD>call IPyRun(input('enter python: ','','custom,IPyCompleteForInput'))<CR>
command PyRun -complete=custom,IPyCompleteForInput <CMD>call IPyRun(<f-args>)
"nmap <M-r> <CMD>call IPyRun(input('enter python: '))<CR>
"nmap <M-I> <CMD>let @z=input('enter text: ') <bar> norm "zp<CR>
"nmap <M-i> <CMD>let @z=input('enter text: ') <bar> norm "zp<CR>
nmap <M-i> <leader>of

let g:neoterm_automap_keys="<plug>(aaaa)"

"imappings!!
"c-t c-d c-h <Plug>(easymotion-hlsearch)<Plug>(easymotion-hlsearch)same as bef

"imap <c-.> <c-o>.

"loofor 2 chars already S 
"imap <expr> <c-s> "<c-o><Plug>(easymotion-sn)"
" to <Plug>(easymotion-hlsearch)handle bug of sear

"needed to be in onload
"imap <M-a> <c-x><c-o>

"imap <M-A> <c-x><c-o>
"inoremap ^] ^X^]
"inoremap ^L ^X^L
"go forward and back
"imap jk <ESC>l" : " 
"
" 
"nmap Ãƒâ€šÃ‚Â§ <CMD>call StartSpecialInsert()<CR>i
"imap Ãƒâ€šÃ‚Â§ <c-o>
"inoremap Ãƒâ€šÃ‚Â§ <c-l>

"imap <c-z> <c-f><c-r>=SuperTab('n')<CR> 
"

vmap <c-t> <CMD>Trans<CR>
"imap <c-i> <c-f><S-Tab>

function! CompleteInf()
    let pre= '\(\\ref{\zs\k*$\|\\cite{\zs\k*$\|\k*$\)'
    let nl=[]
    let l=complete_info()
    for k in l['items']
            call add(nl, k['word']. ' <CMD> ' .k['info'] . ' '. k['menu'] )
    endfor 
    call fzf#vim#complete(fzf#wrap({ 'source': nl,'prefix':pre, 'reducer': { lines -> split(lines[0], '\zs <CMD>')[0] },'sink':function('PInsert2')}))
endfunction 
"get documention of current symbol
noremap <m-k> <CMD>let x=printf("Leaderf help --input %s", expand("<cword>"))<CR><CMD>exec x<CR>
vmap <m-k> "xy<CMD>let x=printf("Leaderf help --input \"%s\"", getreg("x"))<CR><CMD>exec x<CR>
"com
"completion by fuzzing of anything
imap <c-.> <CMD>call CompleteInf()<CR>
cmap <c-.> <CMD>call CompleteInf()<CR>
imap <M-K> <plug>(fzf-complete-word)
imap <M-k> <plug>(fzf-complete-word)
"imap <M-F> <plug>(fzf-complete-path)
"imap <M-f> <plug>(fzf-complete-path)
"imap <M-J> <plug>(fzf-complete-file-ag)
"imap <M-j> <plug>(fzf-complete-file-ag)
imap <M-L> <plug>(fzf-complete-line)
imap <M-l> <plug>(fzf-complete-line)



"let g:targets_pairs = '() {} [] <>'
"let g:textobj#anyblock#blocks = ['(', '{', '[', '<']

"this very dangerous and also quit diff<M-x>






" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
"map <leader>l <Plug>(easymotion-bd-jk)
"nmap <leader>L <Plug>(easymotion-overwin-line)
"nmap <leader>w <Plug>(easymotion-overwin-w)
"nmap <leader>f <Plug>(easymotion-bd-fl)
"if has('nvim')


"let g:EasyMotion_use_upper = 1
" type `l` and match `l`&`L`
"cmd shortcuts
"m shokjknaaartcuts
"nnoremap <m-s> :w<CR>
"inoremap <m-s> <esc>:w<CR>

"nmap [a <CMD>ALEPrevious<CR>
"nmap ]a <CMD>ALENext<CR>
"nmap ]E <Plug>(coc-diagnostic-next)
"nmap [E <Plug>(coc-diagnostic-prev)
"nmap ]e <Plug>(coc-diagnostic-next-error)
"nmap [e <Plug>(coc-diagnostic-prev-error)
nmap [h <Plug>(GitGutterPrevHunk)
nmap ]h <Plug>(GitGutterNextHunk)
""" g mapping 
"makesure we are powershell
nmap gp <CMD>exec ":e ". system("TranslatePath ".expand('<cfile>'))<CR>
""" m mappings


nnoremap <leader>mb iimport ipdb;ipdb.set_trace()<ESC>
nmap mb <leader><C-O>
nmap mB <leader><C-I>
nmap mv <leader><C-I>
" jump to current path
nmap mC <CMD>call CopyPath()<CR>
noremap mc <CMD>cd %:p:h<CR>
nnoremap md <CMD>diffupdate<CR>
nnoremap mf <CMD>!start %:p:h<CR>
nnoremap <leader>mF <CMD>exec '!open '.getcwd()<CR>
nmap mF vaf<F2>


"go to the current selection in rg"xy<CMD>call feedkeys("\<C-a>g" . @x)<CR>

"vmap mg <C-Y>

"exact 
vnoremap mge "xy<CMD>exe ":FzfRg -e" . @x<CR>
"current folder lookup word
"nmap mg viWmg
"current file lookup word
nmap MG viWY
nnoremap MH <CMD>Help 
nnoremap Mh <CMD>help 
nnoremap mH <CMD>LeaderfHelp<CR>
noremap mm <CMD>LeaderfMru<CR>
"this is by order and not fuzzy
noremap mM <CMD>Mru<CR>

"newline

nnoremap mn o<ESC>D
"noremap H ~
noremap \H H
noremap \L L
"nnoremap <leader>H H
"H is available
"great!
nnoremap <leader>M M

function! MPf()
    let @+ =substitute(@+,"\\<NL>$","","")
    let @+ =substitute(@+,"^[ \t]*","","")
    exec "norm \"+]P"
endfunction

"paste new line
"remove indent
"
nnoremap mp o<esc><CMD>s/[^ \t]//ge<CR><CMD>call MPf()<CR>
imap <C-i> <c-o><cmd>norm mP<CR>





function! PasteFormat(x)
    let l=@+
    let l=len(split(l,"\n"))-1
    return a:x."V".string(l).'j='
endfunction

nnoremap <expr> ]p @+ =~ ".*\n$" ?  PasteFormat("p") : ((@+ =~ ".*\n.*$") ? PasteFormat("o<ESC>p"): "o<C-R>+<ESC>")
nnoremap <expr> ]P @+ =~ ".*\n$" ?  PasteFormat("P") : ((@+ =~ ".*\n.*$") ? PasteFormat("O<ESC>p"): "O<C-R>+<ESC>")
"nnoremap <silent>]p <cmd>call Putline("]p")<CR>

function! Putline(how)
let l:type = getregtype(v:register)
call setreg(getreg(v:register), "V")
execute 'normal! "' . v:register . a:how
call setreg(getreg(v:register), l:type)


endfunction


"nnoremap <silent> mp <CMD>call Putline("]p")<CR>
function! Domp()
    let @z=substitute(@+,"\<NL>","","g")
endfunction

vnoremap mP <CMD>call Domp()<CR>"zp
nnoremap mP <CMD>call Domp()<CR>"zp
nnoremap MP <CMD>call Domp()<CR>"zP
"convert from WINDOWS style <CR> 
nmap mwin :s/\<lf>CR>/


"remove empty spaces and lines
nnoremap msA :%s/^[\t ]*//<CR>:%s/\s\+$//e<CR>:%g/^[\t ]*$/d<CR>:%s/[  ]* / /g<CR>
nnoremap msa :s/^[\t ]*//<CR>:s/\s\+$//e<CR>:.g/^[\t ]*$/d<CR>:s/[  ]* / /g<CR>

nnoremap msb :%s/\s\+$//e<CR>:g/^$/d<CR>:%s/[  ]* / /g<CR>
"remove multi space in current line
nnoremap mss <CMD>s/\s\+/ /g<CR>
"remove empty lines
nnoremap msl <CMD>%s/\s\+$//e<CR>
"remove trailing spaces
nnoremap msc <CMD>%s/^\(.\{-\}\)[ ]*$/\1<CR>
"open cur folder 
"nmap mt <CMD>NvimTreeClose<CR>:<CMD>echom ":NvimTreeOpen ".getcwd() <CR>:<CMD>exec ":NvimTreeOpen ".escape(getcwd(),'\')<CR> 
"noremap mt <CMD>call CloseAllNR()<CR>:<CMD>sleep 200m<CR>:<CMD>exec ":vert topleft split " . getcwd()<CR>
"noremap mT <CMD>call CloseAllNR()<CR>:<CMD>sleep 200m<CR>:<CMD>exe ":tabnew ".expand("%:p:h")<CR>
"open cur file's folder
"mt is defined in lua
noremap MT <CMD>exec "NvimTreeOpen ".expand("%:p:h")<CR>
"noremap mt <CMD>NERDTreeFind<CR>

nnoremap mu <CMD>UndotreeToggle<CR>
"nnoremap mu <CMD>MundoShow<CR>

nnoremap mws <CMD>CtrlSpaceSaveWorkspace<CR>
nnoremap mwd <CMD>let g:overrideCWD=0<CR>:<CMD>CtrlSpaceSaveWorkspace default<CR>let g:overrideCWD=1<CR>

nmap TT <CMD>LeaderfLineCword<CR>
vnoremap T "xy:<CMD>call feedkeys( ":LeaderfLine\<lt>CR>". @x ,'t')<CR>
function! SpecialFindLeader(type)
let &selection = "inclusive"
exec 'normal! `[v`]"xy'
:call feedkeys( ":LeaderfLine\<CR>". @x ,'t')
"call Matches(@x)
endfunction


"vmap T 
nmap Mm Miw
nmap MM MiW

function! SpecialFindRg(type)
let &selection = "inclusive"
exec 'normal! `[v`]"xy'
:call feedkeys( ":LeaderfRgInteractive\<CR>". @x . "\<CR>\<CR>") 
endfunction

nnoremap L <CMD>set opfunc=SpecialFindRg<CR>g@
vmap L <C-Y>
nmap Ll Liw
nmap LL LiW
"make it seach the current zone
vnoremap RR "xy/=escape(@x,'\/')<CR><CR>
"look in the current file for all matches
vnoremap Y "xy:<CMD>call Matches(@x)<CR>
vmap M Y
"to find small word
"coc#config
"copy entire line no new line



nnoremap mY yy<CMD>let @+=@+[:len(@+)-2]<CR>
"nnoremap <C-P> <CMD>CtrlPCurWD<CR>
nmap m' ysiW'
nmap m{ ysiW{
nmap m[ ysiW[
nmap m( ysiW(

nnoremap M, <CMD>CtrlP<CR>
nnoremap m. <CMD>CtrlPClearCache<CR><CMD>CtrlP<CR>
nnoremap mj <CMD>set nohlsearch<CR>
nnoremap <leader>rn <CMD>if &relativenumber <bar> <CMD>set norelativenumber <bar> else <bar> <CMD>set relativenumber <bar> endif<CR>
" \y is copy to another register
"don't use it to cut
noremap x "_x
"open command and search
nmap m~ <c-a>c
"use <c-o> to edit cmd in place
nmap M~ <CMD>Leaderf cmdHistory<CR>
nnoremap mQ q:k
nnoremap <leader>~ ~
nnoremap <M-Space> q:i

"nmap m~ q:i<esc><c-s>
"just opens
nnoremap mq q:i<esc>


"nmap <leader>bh <CMD>split <bar> <CMD>e ~/.bash_history<CR>,
"nmap <leader>bh <CMD>call fzf#run({'source':"cat ~/.bash_history \<bar> sort \<bar> uniq",'sink': function('BH')})<CR>
function! CompleteCommand(arg)
    call fzf#run({'source': GetCommands(),'sink': function('HandleCommand'),'options': '-m --query "'.a:arg.'"'} ) 
endfunction 

nnoremap <leader>R R

"this function maps all registers so that we know what we have in each
"c-q for insert mode%. R for other modes.
func! MapR()
    let lst=['+','*','.','=','%']
imap <M--> <CMD>:echo getreg("+")<CR>
imap <M-=> <CMD>:echo getreg("=")<CR>
    for i in range(10)
            call add(lst,string(i))
            exec 'map <M-'. string(i) .'> <CMD>:echo getreg("'.string(i) .'")<CR>'
            exec 'imap <M-'. string(i) .'> <CMD>:echo getreg("'.string(i) .'")<CR>'
            "exec 'vmap <M-'. string(i) .'> <CMD>:echo getreg("'.string(i) .'")<CR>'
    endfor
    let k=char2nr('a')
    for j in range(26)
            call add(lst,nr2char(k+j))
    endfor 
for i in lst 
            exec 'nmap R'. i .' <CMD>echo getreg("'.i .'")<CR>'
            exec 'vmap R'. i .' <CMD>echo getreg("'.i .'")<CR>'
            "exec 'imap <M-'. i .'> <CMD>echo getreg("'.(i) .'")<CR>'
endfor 
endf

call MapR()

"complete the command using recent commands 
:cmap <expr> <c-a> &cedit.'^"xy$'."<esc><esc><CMD>call CompleteCommand(@x)<CR>"
"edit command in command window
:cmap <expr> <c-b> &cedit."i"


nnoremap <silent> <C-a>c <CMD>call fzf#run({'source': GetCommands(),'sink': function('HandleCommand'),'options': '-m'} )<CR>
"search only for the mapping key
noremap <silent> <C-a>m <CMD>Maps<CR>
"search in mapping description as well
nnoremap <silent> <C-a>M <CMD>call fzf#run({'source': GetMappings(),'options': '-m'} )<CR>
nnoremap <leader><bar> <bar>
"nnoremap <silent> <bar> <CMD>call FZFOpen(':Buffers')<CR>
"<M-Bslash>
"<M-Bslash>
nmap <bar> <CMD>LeaderfDisablePreview<CR><CMD>Leaderf --popup buffer --all<CR>
nmap <M-Bslash> <CMD>let g:Lf_JumpToExistingWindow = 0<CR><CMD>Leaderf --popup buffer --all<CR>
"nnoremap <silent> <M-Bslash> <CMD>call FZFOpen(':Windows')<CR>



nnoremap <silent> m<bar> <CMD>LeaderfEnablePreview<CR><CMD>let g:Lf_JumpToExistingWindow = 1<CR><CMD>Leaderf --popup buffer<CR>
"nmap <bar> <CMD>Telescope buffers<CR>
"nnoremap <silent> <C-a>b <CMD>Leaderf buffers<CR>
"
"nnoremap <silent> <C-z> <CMD>call FZFOpen('Buffers')<CR>

nnoremap <silent> <C-a>g <CMD>LeaderfRgInteractive<CR>
nnoremap <silent> <C-a>G <CMD>FzfLua live_grep<CR>
"nnoremap <silent> <C-a>g <CMD>Telescope live_grep<CR>
"nnoremap <silent> <C-a>G <CMD>lua require('git_grep').live_grep( {additional_args = { "--","*.py"}} )<CR>
"nnoremap <silent> <C-a>g <CMD>call FZFOpen('FzfRg!')<CR>
"nnoremap <silent> <C-a>G <CMD>Leaderf rg -tpy<CR>

"for exact
"nnoremap <silent> <C-a>G <CMD>call FZFOpen('FzfRg! -e')<CR>
nnoremap <silent> <C-a>C <CMD>FzfLua commands<CR>
"nnoremap <silent> <C-a>l <CMD>call FZFOpen('BLines')<CR>
"c-l is lines in insert mode aaa
nnoremap <silent> <C-a>l <CMD>call GetAllInsertsForCurrentBufs()<CR>
nnoremap <silent> <C-a>L m'<CMD>LeaderfLineAll<CR>
nnoremap <silent> <C-a>r <CMD>Leaderf --recall<CR>
nmap <c-u> <c-a>r
nnoremap <silent> <C-a>R <CMD>LeaderfRgRecall<CR>
"files current dir
nnoremap <silent> <C-a>f <CMD>FzfLua files<CR>
"nnoremap <c-a>f <CMD>CtrlPCurWD<CR>
"nnoremap <silent> <C-a>f <CMD>exe ":LeaderfFile ".getcwd()<CR>
nnoremap <c-a>F <CMD>Telescope find_files<CR>
nnoremap <c-a>j <CMD>lua require('telescope.builtin').jumplist({fname_width=80 , layout_config = {      preview_width = 0.6,       width = 0.9     }})<CR>
"files current file
"66444
nnoremap <silent> <C-a>F <CMD>exe ":LeaderfFile " . expand('%:p:h')<CR>
nnoremap <silent> <C-a>h <CMD>call FZFOpen(':History')<CR>
nmap <silent> <C-a>H <CMD>call fzf#run({'source':"cat ~/.bash_history \<bar> sort \<bar> uniq",'sink': function('BH')})<CR>
nnoremap <silent> <C-a>a <CMD>call FZFOpen(':Ag')<CR>
nnoremap <silent> <C-a>d <CMD>call fzf#run({'source': uniq(sort(g:dirs)),'sink':function('CdDirPlug'),'options': '-m'})<CR>
nnoremap <silent> <C-a>D <CMD>call fzf#run({'source': uniq(sort(g:dirs)),'sink':function('CdDir'),'options': '-m'})<CR>
"nnoremap <silent> <C-a>w <CMD>call FZFOpen(':Windows')<CR>
nnoremap <silent> <C-a>w <CMD>FzfLua tabs<CR>
nnoremap <silent> <C-a>b <CMD>Leaderf window<CR>
nnoremap <silent> <C-a>s <CMD>call FZFOpen(':Snippets')<CR>
"use it to increase
nnoremap <silent> <C-a><C-a> <C-a>

" open FZF in
" current file's2 directory
"
nmap <leader>W <CMD>set wrap<CR>

function! GitDir()
let top = systemlist("git rev-parse --show-toplevel")[0]
return top . "/.git"
endfunction

"does diff of all files (could be vs version) 
function! GCWDComplete(A, L, P) abort
return fugitive#Complete(a:A, a:L, a:P, {'git_dir': GitDir()})
endfunction

command! -bang -nargs=? -range=-1 -complete=customlist,GCWDComplete GCWD exe fugitive#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>,   { 'git_dir': GitDir() })

nmap mg <CMD>GCWD<CR>
nmap mG <CMD>unlet b:git_dir<CR><CMD>G<CR>


map <leader>g2 :diffget \\2<CR>
map <leader>g3 :diffget \\3<CR>
nnoremap <leader>Gs <CMD>Gdiff --staged<CR>
nnoremap <leader>Gc <CMD>Git commit -v -q<CR>
nnoremap <leader>GC <CMD>Git commit --amend --no-verify<CR>
nnoremap <leader>Ga <CMD>sil Git add %<CR>
nnoremap <leader>Gt <CMD>Git commit -v -q %<CR>
nnoremap <leader>Gd <CMD>Gvdiffsplit<CR>
nnoremap <leader>GDh <CMD>Gvdiffsplit HEAD^<CR>

nnoremap <leader>GD <CMD>Gvdiffsplit!<CR>
"nmap <leader>GD <CMD>Gvdiffsplit diff<CR>
nnoremap <leader>Ge <CMD>Gedit<CR>
nnoremap <leader>Gr <CMD>Gread<CR>
nnoremap <leader>Gmo Git merge --strategy-option ours origin/master<CR>
nnoremap <leader>Gmt Git merge --strategy-option theirs origin/master<CR>
"Git log all commits
nnoremap <leader>Gl <CMD>silent! Glog<CR>
"Git log current



nnoremap <leader>GL <CMD>0GcLog<CR>
nnoremap <leader>Gg <CMD>Git grep<Space>
nnoremap <leader>Gp <CMD>Git push<CR>
nnoremap <leader>Gu <CMD>Git push upstream<CR>
nnoremap <leader>GU <CMD>Git push -f upstream<CR>
nnoremap <leader>GP <CMD>Git push --force<CR>
nnoremap <leader>Gb <CMD>Git branch<Space>
nnoremap <leader>Go <CMD>Git checkout<Space>
"nnoremap <leader>Grc <CMD>Git rebase --continue<CR>
"nnoremap <leader>Gra <CMD>Git rebase --abort<CR>


map <silent> <leader>? <Plug>(IPy-WordObjInfo)
" opens terminal in new window
"
noremap  <leader>od <CMD>exec ":vs " . getcwd()<CR>
"nnoremap <leader>em <CMD>call Exec("messages")<CR>
"nnoremap <leader>em <CMD>NoiceHistory<CR>
nnoremap <expr> <leader>em exists(":NoiceHistory") ? "<CMD>NoiceHistory<CR>" : "<CMD>call VspIfNeed()<CR><CMD>enew<CR><CMD>let @x=MinExec('messages')<CR><CMD>norm \"xp<CR>"
nnoremap <leader>EM <CMD>NoiceTelescope<CR>
nnoremap <leader>EM <CMD>call VspIfNeed()<CR><CMD>enew<CR><CMD>let @x=MinExec('messages')<CR><CMD>norm "xp<CR>

"enable save
nnoremap <leader>as :if exists('b:auto_save') <bar> :let b:auto_save = !b:auto_save <bar> else <bar> let b:auto_save=1 <bar> endif<CR>:echo "it is now locally". b:auto_save<CR>
nnoremap <leader>SI :let b:save_inserts= !b:save_inserts<CR>:echo "save inserts is now ". b:save_inserts<CR>
nmap     <leader>AS <CMD>:AutoSaveToggle<CR>






nnoremap <leader>do <CMD>diffoff<CR>
nnoremap <leader>du <CMD>diffupdate<CR>
nnoremap <leader>dt <CMD>diffthis<CR>


function! DoRf()
    let @+=expand("%:p")

    norm \tt
    call feedkeys("\<C-e>")
    call feedkeys("\<C-v>\<CR>")
    "exe "norm \<C-v>"

endfunction



au filetype python nmap <leader>rf  <CMD>exec ":call IPyRun(\"%run ".escape( expand('%:p'),'\') . "\")"<CR>
au filetype ps1 nmap <leader>rf  <CMD>call DoRf()<CR>
map <silent> <leader>rb <Plug>(IPy-Interrupt)
nmap <leader>rt <Plug>(IPy-Terminate)
map <leader>rc <Plug>(IPy-RunCell)
"redraw
nnoremap <leader>rd <c-L>

"todo FZF
nnoremap <leader>oc <CMD>copen<CR>
function! CloseVisibleNvimTreeBuffers()
    " Get the list of all windows
    let winlist = getwininfo()
    " Iterate through each window
    for win in winlist
        " Get the buffer number for this window
        let bufnr = win['bufnr']
        " Check if the buffer has the filetype 'NvimTree'
        if getbufvar(bufnr, '&ft') ==# 'NvimTree'
            " Close the buffer
            execute 'bd' bufnr
        endif
    endfor
endfunction
 function! CloseVspIfNeed()
     let max_wincol = -1
     let argmax_win_id = -1
     let ll=0 
     let nvim=0
     "counts real buffers
 
     let tabs = gettabinfo(tabpagenr())
     "echo tabs[0]['windows']
     for k in tabs[0]['windows']
         let win_id=k
         let k= getwininfo(k)[0]
 
         let winnr=win_id2win(win_id)
         let ft= getbufvar(winbufnr(winnr), '&filetype')
         if k['winrow']<=2 && k['wincol']>max_wincol
             let ll=ll+1
             let max_wincol=k['wincol']
             let argmax_win_id=win_id
         endif
         if (ft=~'NvimTree')
             let ll=ll-1
             let nvim=win_id 
             "let argmax_win_id=win_id
             "break
         endif
 
     endfor
     if ll==1 && nvim!=0 
 
         let ll=2 
         let argmax_win_id=nvim
     endif 
 
     if argmax_win_id != -1 && ll>1
         "if OnRight()
             "call GoOther()
         "endif
         call win_gotoid(argmax_win_id)
         :close
         call CloseVspIfNeed()
     endif
 endfunction


 function! CompareRightLeft(se)
     let g=GetBuffRightNu() 
     echo "%s/" .a:se . "/\\=submatch(0) . Comp(submatch(1),".g.")" 
     exec "%s/" .a:se . "/\\=submatch(0) . Comp(submatch(1),".g.")" 
 endfunction 
 
 function! GetBuffRightNu()
     for k in getwininfo()
         if k['winrow']<=2 && k['wincol']>1
             "look no further
             let id=k['winid']
             let winnr=win_id2win(id)
             return winbufnr(winnr)
         endif
     endfor
 endfunction 
 function! FormatJson()
 %!wsl jq
 endfunction 
 function! GetVersionForGithub()
     let @* =  MinExec('version') . "\nWindows 10"
 endfunction 
 
function! VspIfNeed()
    "let x = tabpagebuflist()
    "if len(x)==1
        "vsp
    "endif
    for k in getwininfo()
        if k['winrow']<=2 && k['wincol']>1
            "look no further
            let id=k['winid']
            call win_gotoid(id)
            return
        endif
    endfor
    vsp
endfunction
function! OnRight()
    let k=getwininfo(win_getid())[0]
    return (k['wincol']!=1)
endfunction 
function! GoRight(a)
    for k in getwininfo()
        if k['winrow']<=2 && k['wincol']>1
            "look no further
            let id=k['winid']
            call win_gotoid(id)
            return
        endif
    endfor
endfunction 
function! SwitchKeepRight()

    if OnRight() 
        call GoOther() 
    endif
    ":close
    :call feedkeys('mo')
endfunction 
function! LfFil(a)
    :echom " :LeaderfFile ". a:a


    :exec " :LeaderfFile ". a:a

endfunction
"opens file
nmap <m-p> mc<leader>vn<CMD>cd `=systemlist("git rev-parse --show-toplevel")[0]`<CR><c-a>f
nmap <m-o> mc<leader>vn<c-a>f

nmap <leader>mg <CMD>call CloseVspIfNeed()<CR><CMD>vnew<CR><leader>gf
nmap <leader>of <CMD>call CloseVspIfNeed()<CR><CMD>vnew<CR>ml<M-Bslash>
nmap mo <CMD>call CloseVisibleNvimTreeBuffers()<CR><CMD>call CloseVspIfNeed()<CR><CMD>vnew<CR>ml<CMD>LeaderfBuffer<CR>
nmap mO <CMD>call CloseVisibleNvimTreeBuffers()<CR><CMD>call CloseVspIfNeed()<CR><CMD>vnew<CR>ml<M-Bslash>
function! JJJ()
call feedkeys("mo\<C-b>")
endfunction 
nmap <plug>ttt <CMD>call JJJ()<CR>
nmap <expr> <c-b> "<plug>ttt"
"<c-b> the same with tab
"swaps right and left window
nmap mO <c-w><c-r>
nmap <leader>og <CMD>call CloseVspIfNeed()<CR><CMD>vnew<CR><CMD>let g:Lf_JumpToExistingWindow = 0<CR><CMD>LeaderfFile<CR>
nmap <leader>OF <CMD>call CloseVspIfNeed()<CR><CMD>vnew<CR><CMD>let g:Lf_JumpToExistingWindow = 0<CR>mm
nmap <leader>of <CMD>call CloseVspIfNeed()<CR><CMD>vnew<CR><CMD>call fzf#run({'source': uniq(sort(g:dirs)),'sink':function('LfFil'),'options': '-m'})<CR>
"open python
"function! findbufjup
"o
"endfunction
nmap <leader>op :sp <bar> :exec ':'. bufnr("\[jupyter\]") .'buffer'<CR><c-w>k
nmap <leader>upd \ttupama


nnoremap <leader>oi <CMD>call RecallInserts(0)<CR>
nnoremap <leader>OI <CMD>call GetAllInserts()<CR>
nnoremap <leader>ol <CMD>lopen<CR>
nnoremap <leader>ov <CMD>TN ~/.vim/newplug.vim<CR>
nmap <leader>om <CMD>TN ~/.vim/mappings.vim<CR>
nmap <leader>OM <CMD>call CloseVspIfNeed()<CR><CMD>vnew<CR><CMD>e ~/.vim/mappings.vim<CR>
nmap <leader>on <CMD>TN ~/.vim/myinit.lua<CR>
nmap <leader>ON <CMD>call CloseVspIfNeed()<CR><CMD>vnew<CR><CMD>e ~/.vim/myinit.lua<CR>

"nnoremap <leader>oE <CMD>!

function! TermLOV()
    set splitright
    let t=&shell
    set shell=cmd.exe
    let g:neoterm_shell = "wsl" 
    vertical Tnew "~/"
    let &shell=t
endfunction

function! TermOV(use_file_dir)
    call CloseVspIfNeed()
    let t=&shell
    let g:neoterm_shell = executable('pwsh') ? 'pwsh' : 'powershell'
    set shell=cmd.exe
	set splitright
	let k=g:neoterm.last_id+1
	vertical Tnew "~/"
	"exe k."T . /etc/bashrc"
	"exe k."T . ~/.bash_profile"
	if a:use_file_dir
		exe k."T cd " . expand('%:p:h')
	"else
		"exe k."T hookvim" 
	endif  
		"exe k."T set -o emacs"
	"if g:on_ek_computer
		"exe k."T bind '\"\\C-r\": \"\\C-ahstr -- \\C-j\"'"
	"endif
	exe k."Tclear"
    let &shell=t
endfunction

function! TermO()
	let k=g:neoterm.last_id+1
	Tnew

	exe k."T . /etc/bashrc"
	exe k."T . ~/.bash_profile"
	exe k."T set -o emacs"
	if g:on_ek_computer
	exe k."T bind '\"\\C-r\": \"\\C-ahstr -- \\C-j\"'"
	endif
	exe k."Tclear"
endfunction

"open terminal in new tab
nnoremap <leader>ot <CMD>tabnew <bar> :call TermO()<CR>:startinsert<CR>
"open terminal in new window
nmap <leader>tt <CMD>call TermOV(0)<CR><CMD>call GoRight(0)<CR>:startinsert<CR>


nmap <leader>Tt <CMD>call TermOV(1)<CR><CMD>call GoRight(0)<CR>:startinsert<CR>
nmap <leader>gt <CMD>call TermLOV()<CR><CMD>call GoRight(0)<CR>:startinsert<CR>
nmap <leader>ge <CMD>VimscriptLastError<CR>

nnoremap <leader>vL :TN ~/.vim/vimlog.log<CR>
nmap <leader>vs         <Plug>VimspectorStop
nmap <leader>vR         <Plug>VimspectorRestart
nmap <leader>vp         <Plug>VimspectorPause
nmap <leader>vl        :call vimspector#Launch()<CR>
nmap <leader>vr        :call vimspector#Reset()<CR>
"sets python 2/3
"nmap <leader>S2 :let $PYTHONPATH='/Users/eyalkarni/utils/jmpacket:/Users/eyalkarni/utils:/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages'<CR>
"nmap <leader>S3 :let $PYTHONPATH='/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/'<CR>
"TODO:: to add site-packages
"nmap <leader>s3  :call coc#config('python', {'jediEnabled': v:true, 'pythonPath': '/Users/eyalkarni/.pyenv/shims/python'})<CR>:CocRestart<CR>
"nmap <leader>s2  :call coc#config('python', {'jediEnabled': v:true, 'pythonPath': '/Library/Frameworks/Python.framework/Versions/2.7/bin/python'})<CR>:CocRestart<CR>
"

"start TeX
"nmap <leader>st :set filetype=tex<CR>:w<CR>itemplate<TAB>a<esc>:VimtexToggleMain<CR>
"nmap <leader>so :let tt=expand('%:t')<CR>:VimtexCompileOutput<CR>:exe ":MC ". tt . ":"<CR>

"nnoremap <leader>c :only<CR>
""closes other tabs
"noremap Q :call SaveLastWindow()<CR> :close<CR>
noremap Q <CMD>close<CR>
nnoremap <leader>q <CMD>tabo!<CR><CMD>call CloseAllBuffersButCurrent()<CR>
nnoremap <leader>Q <CMD>q!<CR>
"closes other buffer same tab
nnoremap <nowait> <leader>c <CMD>call CloseAllWindowsButCurrent()<CR>
nnoremap <nowait> <leader>C <CMD>call CloseAllNR()<CR>
 

nnoremap ZB <CMD>call CloseAllBuffersButCurrent()<CR>

nnoremap <silent> <Leader>= <CMD>exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <Leader>- <CMD>exe "vertical resize " . (winwidth(0) * 2)/3<CR>

"to use ml mj mk 
nnoremap <leader>k <CMD>wincmd k<CR>



nnoremap <leader>j <CMD>wincmd j<CR>
nnoremap <leader>l <CMD>wincmd l<CR>
nnoremap <leader>mt <CMD>tabnext<CR>
nnoremap <leader>nt <CMD>tabprevious<CR>

nmap ml <leader>l
nmap mj <leader>j
nmap mk <leader>k
nmap mh <CMD>wincmd h<CR>

"autocmd  FileType * nnoremap <nowait> <buffer> <leader>h <CMD>wincmd h<CR>

"avabnnoremap2 <leader>s <CMD>exec "normal i".nr2chaar(getchar())."\e"<CR>
function! InsertBefore(count) range
        if a:count==0
                let l=1
        else
                let l=a:count
        endif
        for j in range(l)
                let t=getchar()
                if t==27
                        break
                endif
        let @z= t
        ":normal "zp
        if l>1
                exec "normal a"."\<c-r>=nr2char(".t.")\<ESC>"
    else
                exec "normal i"."\<c-r>=nr2char(".t.")\<ESC>"
                "exec ":normal i"."\<c-r>='".nr2char(t)."'"."\<ESC>"
    endif
                "redraw
        endfor 
endfunction

function! MJoin()
    let t=input('enter st start with " or '' to surround :')
    let so= ''
    if (t[0] =='"' || t[0]=="'")
        echo 'aaa'
        let so=t[0] 
        let t=t[1:]
    endif
        
    let tex= getreg('x')
    let res = map (split(tex,'\n'), 'so . v:val . so')
    let res = join(res,t)
    return res
endfunction 

"vmap mjoin "xdi<C-r>=MJoin()<CR>

function! InsertAfter(count) range
        if a:count==0
                let l=1
        else
                let l=a:count
        endif
        for j in range(l)
                let t=getchar()
                if t==27
                        break
                endif
        let @z= t
        ":normal "zp
                exec "normal a"."\<c-r>=nr2char(".t.")\<ESC>"
                "redraw
        endfor 
endfunction

"nmap ` i
"imap ` <ESC>
"inoremap <c-]> `
imap <c-`> <c-O>
nmap <c-`> <esc>
"duplicate in onload because of mapping
"
"nnoremap m= =
"nmap ` <CMD>exec "normal i".nr2char(getchar())."\e"<CR>



"appends one char
"nthis isnoremap <leader>S <CMD>exec "normal a".nr2char(getchar())."\e"<CR>
nmap <leader>i -o

noremap <leader>dd "zdd
noremap <leader>d "zd

noremap D di
nnoremap X "zdi

noremap <leader>D D
"delete without effect of clipboard
command! -range D <line1>,<line2>d z
cabbrev FW silent! w!
"delete without leaving trace
vnoremap D "zd
nnoremap DD "zdd

"C to ci
nnoremap C <CMD>call StartSpecialInsert()<CR>ci
nnoremap cc C
nnoremap <leader>C cc 

nnoremap c "zc
"vnoremap cc "zcc
vnoremap c "zc

"We want to keep the pasted text, while z is the presented text in the visual
"...
vnoremap p :<C-U>let a=@*<CR>gvp:<CMD>let @z=@"<CR>:let @*=a<CR>:let @"=a<CR>
vnoremap c "zdi

"cnnoremap <leader>. @:
nnoremap <C-.> @:


"vnoremap <leader>p "zp
"nnoremap <leader>p "zp
"nnoremap <leader>P "zpi

" \y is copy to another register
noremap <leader>yy "zyy
noremap <leader>y "zy
noremap <leader>Y "zyi
"let g:jedi#completions_command='<leader>a'
"let g:jedi#usagescmand='<leader>gn'

"Bare mappings
"changes current argument
"omap i, ?[\,(]?e+1<CR>cv/[\,)]/s-1<CR>
"nmap ci, dv?[\,(]?e+1<CR>cv/[\,)]/s-1<CR>
"nmap di, dv?[\,(]?e+1<CR>dv/[\,)]/s-1<CR>


" for ansi keyboard
"nnoremap Ãƒâ€šÃ‚Â± :set incsearch<CR>/
"nnoremap Y <CMD>set incsearch<CR>/\c
"nnoremap , :set incsearch<CR>/\c
"nnoremap <C-[> :set incsearch<CR>/\c
vnoremap <nowait> af <Plug>(textobj-function-a) 

"execute a function based on the current visual selection but replace content of selection
vnoremap H "xy:<CMD>call HandleH()<CR>
vnoremap <C-H> "xy:<CMD>call HandleCH()<CR>
vnoremap <C-J> "xy:<CMD>call HandleCJ()<CR>
"look in files for a match
"vnoremap <C-Y> "xy:exe ":FzfRg " . @x<CR>

"xy:call feedkeys("\<C-a>g" . @x)<CR> 

"nnoremap <C-K> :call RegsToggle()<CR>
"vnoremap <C-K> <CMD>:call RegsToggle()<CR>

"translates
nmap <leader><c-t> vaw:<CMD>Trans<CR>

nmap <leader>pc <CMD>ChatGPT<CR>
nmap <leader>pC <CMD>ChatGPT<CR>:Voice<CR>
inoremap <c-u> <c-v>
vmap <c-k> "xy<CMD>:ChatGPT<CR><Cmd>if &insertmode<Bar>stopinsert<Bar>endif<CR><CMD>%d _<CR>"xpgg^i
vmap <m-k> "xy<CMD>:ChatGPT<CR><Cmd>if &insertmode<Bar>stopinsert<Bar>endif<CR>"xpgg^i
nnoremap <c-k> <CMD>:ChatGPT<CR>i
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf


"translates
nmap <leader><c-t> vaw:<CMD>Trans<CR>



vmap <leader>t <CMD>Trans<CR>

function! IfTerm()
    if &bt=="terminal"
       call feedkeys('i') 
    endif
endfunction

function! GetOther()
    if OnRight()
        return "\<c-w>h"
    else
        return "\<c-w>l"
    endif
endfunction

function! GoOther()
:exec "norm ".GetOther()
endfunction
"Move line to terminal
nmap mz my<CMD>exec ":T ".  @" ."\r\n" <cr>
vmap mz <CMD>:'<,'>g/./norm mz<CR>
nmap <c-F5> mz
"Get-Content -Path "C:\Users\ekarni\.vim\mappings.vim" |
"Set-Content -Path "C:\Users\ekarni\.vim\mmmm.vim" -Encoding ASCII
"nmap mz <CMD>TREPLSendLine<CR>
"vmap mz <CMD>TREPLSendSelection<CR>
"move between two panels (left and right) 
"copy to other split
nmap my "xyy<CMD>call GoOther()<CR>"xp
vmap my "xy<CMD>call GoOther()<CR>"xp

nnoremap <C-'> <CMD>call GoOther()<CR><CMD>call IfTerm()<CR>
tnoremap <C-'> <C-\><C-n><CMD>call GoOther()<CR>

" terminal mappings !

if has('vim')
        :tnoremap <C-V> <C-W>"+
        :tnoremap <C-l> <C-W>N
        :tnoremap <C-Y> <C-W>Nyyi
        :tnoremap <C-X> <C-W>NT$ly$i " copy line from $
        :tnoremap <C-Z> <C-W>Nyi
else
        :tnoremap <C-v> <C-\><c-N>pi
        :tnoremap <C-y> <C-\><c-N>yyi
        :tnoremap <C-X> <C-\><c-N>T$ly$i
        :tnoremap <C-l> <C-\><c-N>
        :tnoremap <C-d> cd <C-\><c-N>"=getcwd()<CR>pi<CR>
        :tnoremap <C-e> cd <C-\><c-N>"=expand("#:p:h")<CR>pi<CR>
    "set path of terminal to current cwd
    :tnoremap <C-t> <c-\><c-N>^w<CMD>exec 'cd '. expand('<cfile>')<CR>i
        "quits
        :tmap <C-q> <C-l>Q
        " copy line from $
endif
"esc only in neoterm
"au filetype neoterm <CMD>tnoremap <buffer> <Esc> <C-\><C-n>
"au filetype neoterm <CMD>tnoremap <buffer> <C-BS> <ESC>
"make Y act like M



"map NT <CMD>NERDTree
"nnoremap TN <nowait> <CMD>tabnew<CR>
nmap \tn <CMD>tabnew<CR>

runtime ftplugin/man.vim " adds Man command



"let cmd=['export PYTHONPATH="$PYTHONPATH;/Users/eyalkarni/utils/jmpacket"']
":CtrlSpaceLoadWorkspace default
"call ctrlspace#workspaces#LoadWorkspace(0,'default')


"COC
:if 0

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gY <Plug>(coc-type-definition)
nnoremap <silent> gy  :<C-u>CocList -A yank<cr>



nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gR <Plug>(coc-refactor)
nmap gC  <Plug>(coc-fix-current)
nmap gA  <Plug>(coc-codeaction)
nmap gR <Plug>(coc-rename)

function! Show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    :ALEDetail<CR>
  endif
endfunction

nmap <BS> call Show_documentation()<CR>
"Coc _ mappings 
"nnoremap <silent> _a  <CMD><C-u>CocList actions<cr>
"" Manage extensions
"nnoremap <silent> _e  <CMD><C-u>CocList extensions<cr>
"" Show commands
"nnoremap <silent> _c  <CMD><C-u>CocList commands<cr>
"nnoremap <silent> _d  <CMD><C-u>CocList diagnostics<cr>
"" Find symbol of current document
"nnoremap <silent> _o  <CMD><C-u>CocList outline<cr>
" Search workspace symbols

" Do default action for next item.
"nnoremap <silent> _j  <CMD><C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent> _k  <CMD><C-u>CocPrev<CR>
" Resume latest coc list
"nnoremap <silent> _p  :<C-u>CocListResume<CR>
:endif

"nnoremap _d <CMD>Telescope diagnostics<CR>
"nmap _d <CMD>TroubleToggle<CR>
nnoremap _o <CMD>Telescope lsp_document_symbols<CR>
nnoremap _O <CMD>Telescope lsp_workspace_symbols<CR>
nnoremap _r <CMD>Telescope lsp_references<CR>
nnoremap _a <CMD>Telescope lsp_code_actions<CR>
nmap <nowait> <leader>s <CMD>Navbuddy<CR>

"nnoremap <silent> _s  <CMD>Telescope lsp_workspace_symbols<CR>

"map <silent> <C-c> <Plug>(coc-cursors-position)
"nmap <silent> <C-d> <Plug>(coc-cursors-word)*

"nmap <silent> <C-d> <Plug>(coc-cursors-word)
"xmap <silent> <C-d> <Plug>(coc-cursors-range)

"silent! call repeat#set("H", -1)


":call UltiSnips#ExpandSnippet()<CR>
"strange that I have to change this
"function! ChangeOrder()
"envdebug_keymap
"endfunction
" }}}
"



""Ycm
"let g:jedi#goto_definitions_command = "<leader>gd"
"let g:jedi#goto_command = "<leader>gg"
"let g:jedi#usages_command = "<leader>gn"
"let g:jedi#completions_command = "<C-b>"

"nnoremap <leader>gg <CMD>YcmCompleter GoTo<CR>
"nnoremap <leader>gd <CMD>YcmCompleter GoToDefinition<CR>
"nnoremap <leader>gD <CMD>YcmCompleter GoToDeclaration<CR>
"nnoremap <leader>gI <CMD>YcmCompleter GoToInclude<CR>
"nnoremap <leader>gr <CMD>YcmCompleter GoToReferences<CR>
"nnoremap <leader>gT <CMD>YcmCompleter GetType<CR>
"
"au filetype c nnoremap K <CMD>YcmCompleter GetDoc<CR>



noremap <leader>gl <CMD>YcmCompleter GoToDeclaration<CR>
"let g:ycm_key_invoke_completion="<C-b>" "ctrl i ?
"let g:ycm_key_detailed_diagnostics='<leader>wd'
" let g:ycm_server_python_interpreter="PY
" ""
"
" " Called once right before you start selecting multiple cursors
" "
" "function! Multiple_cursors_before()
" "    call youcompleteme#DisableCursorMovedAutocommands()
" "endfunction
"
" "" Called once only when the multiple selection is canceled (default <Esc>)
" "function! Multiple_cursors_after()
" "    call youcompleteme#EnableCursorMovedAutocommands()
" "endfunction
"
"set runtimepath^=~/vimpy3/plugged

"function! SetupPython()
        ":CocCommand python.setInterpreter
        ":sleep 5
        ":call feedkeys('5')
"endfunction

nmap <M-C-Q> <CMD>qa!

"nnoremap , <CMD>BLines<CR>
"nmap <c-,> <CMD>BLines<CR><C-P>
"
"let g:Lf_CommandMp = {'<C-K>': ['<Up>'], '<C-J>': ['<Down>']}
" I did the switch in code manager.py
"
":inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
":inoremap <S-b> <C-R>=STab_Or_Complete()<CR>



"motion sickness
"
"let g:sickness#expression#preferred_shortcut_map = 'opendelim'  " uses {i,a}{(,{,[,<} for expression text objects
"let g:sickness#expression#preferred_shortcut_map = 'closedelim' " uses {i,a}{),},],>} for expression text objects
let g:sickness#expression#preferred_shortcut_map = 'char'       " uses {i,a}{b,B,r,a} for expression text objects

" or if you want to set your own mappings
"let g:sickness#expression#use_default_maps = 0
xmap iit <cmd>call sickness#textobj#indentation#motion(v:false, 't')<CR>
omap iit <cmd>call sickness#textobj#indentation#motion(v:false, 't')<CR>
""letvmap iit <plug>(textobj-sickness-indentation-top-i)
"omap ait <plug>(textobj-sickness-indentation-top-a)
"vmap ait <plug>(textobj-sickness-indentation-top-a)
"omap ieb <plug>(textobj-sickness-expression-parenthesis-i)
"xmap ieb <plug>(textobj-sickness-expression-parenthesis-i)
"omap aeb <plug>(textobj-sickness-expression-parenthesis-a)
"xmap aeb <plug>(textobj-sickness-expression-parenthesis-a)

"omap ieB <plug>(textobj-sickness-expression-brace-i)
"xmap ieB <plug>(textobj-sickness-expression-brace-i)
"omap aeB <plug>(textobj-sickness-expression-brace-a)
"xmap aeB <plug>(textobj-sickness-expression-brace-a)

"omap ier <plug>(textobj-sickness-expression-bracket-i)
"xmap ier <plug>(textobj-sickness-expression-bracket-i)
"omap aer <plug>(textobj-sickness-expression-bracket-a)
"xmap aer <plug>(textobj-sickness-expression-bracket-a)

"omap iea <plug>(textobj-sickness-expression-chevron-i)
"xmap iea <plug>(textobj-sickness-expression-chevron-i)
"omap aea <plug>(textobj-sickness-expression-chevron-a)
"xmap aea <plug>(textobj-sickness-expression-chevron-a)
let g:sickness#line#use_default_maps = 0

 omap iL <plug>(textobj-sickness-line-i)
 xmap iL <plug>(textobj-sickness-line-i)
 omap aL <plug>(textobj-sickness-line-a)
 xmap aL <plug>(textobj-sickness-line-a) 

let g:sickness#field#use_default_maps = 1
"omap iFb <plug>(textobj-sickness-field-parenthesis-i)
"vmap iFb <plug>(textobj-sickness-field-parenthesis-i)
"omap aFb <plug>(textobj-sickness-field-parenthesis-a)
"vmap aFb <plug>(textobj-sickness-field-parenthesis-a)

"omap iFB <plug>(textobj-sickness-field-brace-i)
"vmap iFB <plug>(textobj-sickness-field-brace-i)
"omap aFB <plug>(textobj-sickness-field-brace-a)
"vmap aFB <plug>(textobj-sickness-field-brace-a)

"omap iFr <plug>(textobj-sickness-field-bracket-i)
"vmap iFr <plug>(textobj-sickness-field-bracket-i)
"omap aFr <plug>(textobj-sickness-field-bracket-a)
"vmap aFr <plug>(textobj-sickness-field-bracket-a)

"omap iFa <plug>(textobj-sickness-field-chevron-i)
"vmap iFa <plug>(textobj-sickness-field-chevron-i)
"omap aFa <plug>(textobj-sickness-field-chevron-a)
"vmap aFa <plug>(textobj-sickness-field-chevron-a)
let g:sick_symbol_default_mappings =0

nmap [; <Plug>Argumentative_Prev
nmap ]; <Plug>Argumentative_Next
xmap [; <Plug>Argumentative_XPrev
xmap ]; <Plug>Argumentative_XNext
nmap <; <Plug>Argumentative_MoveLeft
nmap >; <Plug>Argumentative_MoveRight
xmap i; <Plug>Argumentative_InnerTextObject
xmap a; <Plug>Argumentative_OuterTextObject
omap i; <Plug>Argumentative_OpPendingInnerTextObject
omap a; <Plug>Argumentative_OpPendingOuterTextObject
"Goto next and prev arguments!!
vmap [; <ESC>2[;vi,
vmap ]; <ESC>];vi,
vmap [, <ESC>[,hvi,
vmap ], <ESC>],vi,

"textobj-function
autocmd  FileType * omap <nowait> <buffer> aF <Plug>(textobj-function-a)

"select func
omap aF <Plug>(textobj-function-a)
omap iF <Plug>(textobj-function-i)
"call popsikey#register('<leader>g', [
        "\ #{key: 'g', info: 'status', action: ":Gstatus\<CR>", flags: 'n'},
        "\ #{key: 'c', info: 'commit', action: ":Gcommit\<CR>", flags: 'n'},
"n
"
"v
        "\ ],
        "\ {})
"call popsikey#register('mZ', [ 
"            \ {'key': 'g', 'info': 'status', 'action': ":Gstatus\<CR>", 'flags': 'n'},
"    \ {'key': 'c', 'info': 'commit', 'action': ":Gcommit\<CR>", 'flags': 'n'}], {})

"to call at the end
function! DefineMapping()



nmap <c-;> ;
"map  <expr> ; repmo#LastKey(';')|sunmap ;
"map  <expr> <C-\> repmo#LastRevKey(',')

"map  <expr> <tab> repmo#ZapKey('<Plug>Lightspeed_s')
"|ounmap s|sunmap s
"map  <expr> <S-tab> repmo#ZapKey('<Plug>Lightspeed_S')
"|ounmap S|sunmap S
""omap <expr> z repmo#ZapKey('<Plug>Sneak_s')
""omap <expr> Z repmo#ZapKey('<Plug>Sneak_S')
""map  <expr> f repmo#ZapKey('<Plug>cusnf')|sunmap f
""map  <expr> F repmo#ZapKey('<Plug>cusnF')

"nmap  } <Plug>Lightspeed_t
"nmap  { <Plug>Lightspeed_T
nnoremap m] ]
nnoremap m} }
nnoremap m{ {
nnoremap g] ]
nnoremap m] ]
nnoremap g] ]
"nmap  t  let g:init=1<CR>:w<CR>
nmap  T  <Plug>spleader
"nmap t :echo exists('g:lightspeed_active')<CR>

nnoremap <Plug>spleader :set opfunc=SpecialFindLeader<CR>g@

nnoremap M <CMD>set opfunc=SpecialFind<CR>g@

function! SpecialFind(type)
let &selection = "inclusive"
exec 'normal! `[v`]"xy'
call Matches(@x)
endfunction

nnoremap H <CMD>set opfunc=SpecialFindMR<CR>g@

function! SpecialFindMR(type)
    let &selection = "inclusive"
    exec 'normal! `[v`]"xy'
    call GitFPat(GetExtPat(),1,@x)
endfunction 
"nmap <esc> :call clever_f#_reset_all()<CR> 
""map  <expr> t repmo#ZapKey('<Plug>Sneak_t')|sunmap t
""map  <expr> T repmo#ZapKey('<Plug>Sneak_T')|sunmap T

"nmap f <Plug>(QuickScopef)
"omap f <Plug>(QuickScopef)
"xmap f <Plug>(QuickScopef)

"xmap F :call quick_scope#Wallhacks()<CR><Plug>(easymotion-sl)
"omap F :call quick_scope#Wallhacks()<CR><Plug>(easymotion-sl)
nmap ]d <CMD>lua vim.diagnostic.goto_next()<CR>
nmap [d <CMD>lua vim.diagnostic.goto_prev()<CR>

for keys in [[']E','[E'],[']a','[a'],[']d','[d'],[']e','[e'],[']h','[h'],['&','z&'], ["\<F4>","\<F3>"], [']=','[='], [']+','[+'], [']-','[-'],  [']c', '[c'], ['~','!'],['%','g%']]
    "call RepRemap(keys[0],keys[1])
endfor
" Now following can also be repeated with `,` and `;`:
" ,['<M-K>','<A-J>']
"
"for keys in [['l','h'],['k','j'], ['[[', ']]'], ['[]', ']['], [']m', '[m'], [']M', '[M'], [']c', '[c'] ,  [ 'w','b' ] ,[ 'W','B' ] ,[ 'e','ge' ] ,[ 'E','gE' ], ['<F4>','<F3>'],['<M-K>','<A-J>'],['{','}'],['(',')']]
"Not to mess with vim-tex [']]','[[']
for keys in [['[]', ']['], [']m', '[m'], [']M', '[M'],['l','h'],['k','j'],  [ 'w','b' ] ,[ 'W','B' ] ,[ 'e','ge' ] ,[ 'E','gE' ],['(',')']]
    "execute 'silent noremap <expr> '.keys[0]." repmo#SelfKey('".keys[0]."', '".keys[1]."') |sunmap ".keys[0]
    "execute 'silent noremap <expr> '.keys[1]." repmo#SelfKey('".keys[1]."', '".keys[0]."') |sunmap ".keys[1] 
    ""execute 'noremap <expr> '.keys[0]." repmo#Key('".keys[0]."', '".keys[1]."')|sunmap ".keys[0]
    ""execute 'noremap <expr> '.keys[1]." repmo#Key('".keys[1]."', '".keys[0]."')|sunmap ".keys[1]
endfor
endfunction

:autocmd CmdwinEnter * noremap <buffer> <F2> <CR>q:
:au BufWritePost * :let g:init=1

"evals a function based on the current visual selection
vnoremap F "xd"=HandleF()<CR>P
"execute a function based on the current visual selection
vnoremap <C-F> "xy<CMD>call HandleCF()<CR>p

"function! GetRegs()
    "call fzf#run({'source':":reg",'sink': function('PInsert')})<CR>
"endendfunction
"nnoremap <silent> <leader> <CMD>WhichKey '\<CR>
"nnoremap <silent> m <CMD>WhichKey 'm'<CR>
let g:which_key_vertical=1

function! Ff()
    let x=getline(".")
    let c=split(x,'\s')
PY << EOF
t= vim.eval('c')
for x in t:
    if 'map' in x:
        continue
    if x.startswith('<') and x.endswith('>'):
        continue
    break
vim.command('let x = pyxeval("x")')
EOF

     "substitute(getline("."),'\w*map\w*.\{-}\(\<[a-z0-9M-Z<>]\{-}\>\)\s*',"\\1","")
    norm - 
    let com=substitute(getline("."),'^\s*"\(.\{-}\)$','\1','')
    echo printf("'%s','%s'", x,com)
endfunction

nnoremap <Leader>pp <CMD>lua require'telescope.builtin'.lsp_workspace_symbols{}<CR>
"Telescope
nmap <leader>gf <CMD>Telescope git_files<CR>
"nnoremap <leader>gr <cmd>lua require('telescope.builtin').live_grep{ cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1] ,glob='*.py'}<cr>


function! DoTag()
    let tmp=getcwd()
    <CMD>exe ":cd ". expand("%:p:h")

    let top = systemlist("git rev-parse --show-toplevel")[0]
    <CMD>exe ':lcd '. top
    if filereadable('.\tagsloc')
        let t=readfile('tagsloc')[0]
        :exe ':lcd ' . t
    endif
    :LeaderfTag
    :exe ':lcd '.tmp
endfunction

function! RunFiles(torun,onlypy)
"be at the top of git
        let top = systemlist("git rev-parse --show-toplevel")[0]
        let a=systemlist("git ls-files ". top . " --full-name" )

        let a = (a:onlypy ? filter(a,{idx,val -> val =~ ".*py$"}): a)
        echo a
        %argd
        for item in a
            echo item
            exec ":argadd ".item
        endfor
        :exec argdo "source ".a:torun
endfunction
 function! FillQFGitF(regfilter,curfile) 
     " Store original directory if needed
     let tmp = getcwd()
     if (a:curfile)
         exe "cd " . expand("%:p:h")
     endif
 
     " Get git root directory
     let git_cmd = systemlist("git rev-parse --show-toplevel")
     if v:shell_error
         echo "Not in a git repository"
         return -1
     endif
     let top = git_cmd[0]
     exe 'cd ' . top
 
     " Get git files
     let files = systemlist("git ls-files --full-name 2>NUL")
     if v:shell_error
         echo "Failed to get git files"
         return -1
     endif
 
     " Filter files if regex provided
     if len(a:regfilter)>0
         let files = filter(files, {idx,val -> (val =~ a:regfilter && val !~# ".*warning.*")})
     endif
 
     " Convert to full paths
     let files = map(files, {idx,fname -> fnamemodify(fname, ':p')})
 
     " Build quickfix entries
     let qf_list = []
     for file in files
         " Only add if file exists
         if filereadable(file)
             call add(qf_list, {
                         \ 'filename': file,
                         \ 'lnum': 1,
                         \ 'col': 1,
                         \ 'text': 'Git tracked file',
                         \ 'type': ' ',
                         \ 'valid': 1
                         \ })
         endif
     endfor
 
     " Set quickfix list with title
     call setqflist([], 'r', {
                 \ 'title': 'Git Files' . (len(a:regfilter) > 0 ? ' (' . a:regfilter . ')' : ''),
                 \ 'items': qf_list
                 \ })
 
     " Restore original directory
     exe 'cd ' . tmp
 
     " Open quickfix window if we have entries
     if !empty(qf_list)
         copen
     else
         echo "No matching files found"
     endif
 
     return 0
 endfunction
 function! GitF(regfilter,curfile) 
     if (a:curfile)
 
     let tmp=getcwd()
     :exe ":cd ". expand("%:p:h")
 endif 
     let top = systemlist("git rev-parse --show-toplevel")[0]
     "echo top
     :exe ':cd '. top
     let a=systemlist("git ls-files --full-name  2>NUL" )
     :if len(a:regfilter)>0
     let a = filter(a,{idx,val -> (val =~ a:regfilter)})
     let a = filter(a,{idx,val -> (val !~# ".*warning.*")})
     let a= map(a, {idx,fname -> fnamemodify(fname, ':p')})
     :endif 
     ":echo a
     :call writefile(a,'c:\temp\filelist.txt')
     try
         echohl Question
         let pattern = input("Search pattern: ")
         let pattern = escape(pattern,'"')
     finally
         echohl None
     endtry
     exec printf("Leaderf rg --filelist c:\\temp\\filelist.txt %s\"%s\"", pattern =~ '^\s*$' ? '' : '-e ', pattern )
     if (a:curfile)
 
         :exe ':cd '.tmp
     endif 
 
 endfunction
 function GitFLast(curfile)
     if (a:curfile)
 
     let tmp=getcwd()
     :exe ":cd ". expand("%:p:h")
 endif 
     let top = systemlist("git rev-parse --show-toplevel")[0]
     "echo top
     :exe ':cd '. top
     try
         echohl Question
         let pattern = input("Search pattern: ")
         let pattern = escape(pattern,'"')
     finally
         echohl None
     endtry
     exec printf("Leaderf rg --filelist c:\\temp\\filelist.txt %s\"%s\"", pattern =~ '^\s*$' ? '' : '-e ', pattern )
     if (a:curfile)
 
         :exe ':cd '.tmp
     endif 
 endfunction 
 function! ReplaceInFiles(path, pattern)
     let f=readfile('c:\temp\filelist.txt')
     " Validate pattern format /search/replace/
     if a:pattern !~ '^/.*/.*/\?$'
         echoerr "Invalid pattern format. Use /search/replace/"
         return
     endif
 
     " Extract search and replace terms
     let parts = split(a:pattern[1:-1], '/')
     if len(parts) < 2
         echoerr "Invalid pattern format. Use /search/replace/"
         return
     endif
     
     let search = parts[0]
     let replace = parts[1]
     
     " Build command
     let cmd = "args " . a:path . "/**/*"
     execute cmd
     
     " Perform replacement
     execute 'argdo %s/' . search . '/' . replace . '/ge | update'
     echo "Replacement complete"
 endfunction
 
 function! GitFPat(regfilter,curfile,pattern) 
     let pattern= a:pattern
     if (a:curfile)
 
     let tmp=getcwd()
     :exe ":cd ". expand("%:p:h")
 endif 
     let top = systemlist("git rev-parse --show-toplevel")[0]
     "echo top
     :exe ':cd '. top
     let a=systemlist("git ls-files --full-name 2>NUL" )
     :if len(a:regfilter)>0
     let a = filter(a,{idx,val -> (val =~ a:regfilter)})
     let a = filter(a,{idx,val -> (val !~# ".*warning.*")})
     ":echo a
     let a= map(a, {idx,fname -> fnamemodify(fname, ':p')})
     :endif 
     ":echo a
     :call writefile(a,'c:\temp\filelist.txt')
     exec printf("Leaderf rg --filelist c:\\temp\\filelist.txt %s\"%s\"", pattern =~ '^\s*$' ? '' : '-e ', pattern )
     if (a:curfile)
 
         :exe ':cd '.tmp
     endif 
 
 endfunction
nmap <leader>vv <CMD>call Exec('version')<CR>

"nmap <m-p> :Telescope lsp_document_symbols<CR>
nmap <c-i> <CMD>call JJH()<CR>
nnoremap <m-i> <c-i>

function! JJH()
call feedkeys("|\<C-B>")
endfunction

"function! Gut(bb) 
"exec 'cd '.expand('%:p:h')
":GutentagsUpdate
"endfunction 
"au filetype * command! -buffer GutenTagRun <CMD>call gutentags#setup_gutentags() <bar> <CMD>call timer_start(15,'Gut')<CR>
command! -nargs=1 LfExt <CMD>Leaderf rg --live --glob <q-args><CR>
command! -nargs=1 LfGitExt <CMD>call GitF(".*\\.". <f-args> ."$",0 )<CR>
command! -nargs=1 LfGitGen <CMD>call GitF(<f-args>,0)<CR>
"Edit file in the same folder
":com! -nargs=1 -bang -complete=customlist,EditFileComplete
        "\ EditFile edit<bang> <args>
":fun! EditFileComplete(A,L,P)
":    return split(glob(expand("%:p:h").'\*'.(len(a:A)>1 ? a:A . "*" : '')), "\n")
":endfun
"```vim
 :com! -nargs=1 -bang -complete=customlist,EditFileComplete
             \ Vf call CloseVspIfNeed() <bar> exec "vsplit ". expand("%:p:h")."/<args>"
 :com! -nargs=1 -bang -complete=customlist,EditFileComplete
             \ Ef exec "edit<bang> ". expand("%:p:h")."/<args>"
:fun! EditFileComplete(A,L,P)
:    return map(filter(split(glob(expand("%:p:h").'/*'.(len(a:A)>1 ? a:A . "*" : '')), "\n"),'filewritable(v:val) != 2' ),'fnamemodify(v:val, ":t")' )
:endfun

func! GetExtPat()
    return "." . split(expand('%:t'),'\.')[1]. "$"
endfunction 

"Use current workspace git py  
nmap <leader>gr <CMD>call GitF(GetExtPat() ,0)<CR>
"Use current workspace git all 
nmap <leader>gR <CMD>call GitF("",0)<CR>
"Use current file  git py  
nmap <leader>Gr <CMD>call GitF(GetExtPat() ,1)<CR>
"Use current file  git all  
nmap <leader>GR <CMD>call GitF("",1)<CR>

vmap <leader>Gr "xy<CMD>call GitFPat(GetExtPat() ,1,@x)<CR>
vmap <leader>GR "xy<CMD>call GitFPat("",1,@x)<CR>
vmap <leader>gR "xy<CMD>call GitFPat("",0,@x)<CR>
vmap <leader>gr "xy<CMD>call GitFPat(GetExtPat(),0,@x)<CR>

vnoremap <c-a>g "xy<CMD>call feedkeys( ":LeaderfRgInteractive\<lt>CR>". @x . "\<lt>CR>\<lt>CR>")<CR>
vmap <c-y> <leader>GR
"vnoremap <leader>gr "xy<CMD>call feedkeys( ":LfGitGen .*\\.py$\<lt>CR>". @x . "\<lt>CR>")<CR>

map mr <leader>gr
map mR <leader>gR
map MR <leader>GR
map Mr <leader>Gr

nmap ML <CMD>call GitFLast(1)<CR>
nmap <leader>mr "xy<CMD>call FillQFGitF(GetExtPat(),0)<CR>
nmap <leader>mR "xy<CMD>call FillQFGitF("",0)<CR>
nmap <leader>Mr "xy<CMD>call FillQFGitF(GetExtPat(),1)<CR>
nmap <leader>MR "xy<CMD>call FillQFGitF("",1)<CR>

"nmap mr <CMD>call nvim_set_current_dir(expand('%:p:h'))<CR><leader>gr 
"nmap mR <CMD>call nvim_set_current_dir(expand('%:p:h'))<CR><leader>gr 

"nmap <leader>gs <CMD>call DoTag()<CR>
"nmap gs <CMD>luafile c:\Users\ekarni\.vim\aa.v<CR>
""~\compare-my-stocks\src\come_my_stocks\input\inputprocessorinterface.py:2" 15L, 350B
"new
"C:\users\ekarni\.vim\plugged/avante.nvim/lua/avante/sidebar.lua:3167:

 function! DoGF()
     let file=expand('<cfile>')
     let sec =expand('<cWORD>')
     let st='^.\{-}\([[:alnum:]-_\\\.~\/]*\):\(\d\+\).\{-}$'
     if filereadable(expand(expandcmd(file)))!=0
     else 
         let file= substitute(sec,st,'\1','')
     endif 
     let ff = getline('.')
     let prevfile=""
     if filereadable(expand(expandcmd(file)))==0
         let prevfile=file
         let file= substitute(ff,st,'\1','')
         let line= substitute(ff,st,'\2','')
     else 
         let line= substitute(sec,st,'\2','')
     endif 
 
     let arr=[expand(expandcmd(file)),line]
 
 
     if ff=~?'^.File "\([^"]\+\)", line \(\d\+\).'
         let arr = [matchstr(ff, '"\zs[^"]\+\ze"'),matchstr(ff, 'line \zs\d\+') ]
     endif
 
     if len(arr)>1
         if  filereadable(expand(expandcmd(arr[0])))==0
             if prevfile 
                 echoerr  prevfile . " / " . arr[0] . " -  File doesn't exists"
             else 
                 echoerr arr[0] . " - File doesn't exists"
 
             endif 
             return
         endif
         :exe ':e '.arr[0]
  
         if arr[1] =~# '^\d\+$'
             :exe ':'.arr[1]
         endif
     else
        norm! gf
        if line =~# '^\d\+$'
             :exe ':'.line
         endif 
     endif
endfunction
 

nmap gf <CMD>call DoGF()<CR>

nmap \] mC<CMD>bd<CR>:e <C-R>=@*<CR><CR>
nmap <leader>gv <CMD>cd c:\users\ekarni\.vim<CR><CMD>Leaderf rg --glob "*.vim" --glob "*.lua" --max-depth=1<CR>
"nmap {          <Plug>EnhancedJumpsOlder
"nmap }          <Plug>EnhancedJumpsNewer
"nmap g{         <Plug>EnhancedJumpsLocalOlder
"nmap g}         <Plug>EnhancedJumpsLocalNewer
"nmap <Leader>{  <Plug>EnhancedJumpsRemoteOlder
"nmap <Leader>}  <Plug>EnhancedJumpsRemoteNewer
nmap z; <Plug>EnhancedJumpsFarChangeOlder
nmap z, <Plug>EnhancedJumpsFarChangeNewer

command! -nargs=1 ReloadPackage <CMD>exe "cd c:/users/ekarni/.vim" <bar> lua require('funcs').reload_package(<f-args>)

"function! GetVoice()
    "return py3eval('recognize_voice()')
"endfunction 
nmap <c-L> <CMD>Voice<CR>

imap <C-L> <C-R>=GetVoice()<CR>

nmap <leader>rch <cmd>:%s#\(\.\.\.\)\?\(.*\)\(plugged\)#C:\\users\\ekarni\\.vim\\plugged#g<CR>:%s#\c\(\.\.\.\)\?\(.*\)\(chatgpt.nvim\)#C:\\Users\\ekarni\\.vim\\plugged\\ChatGPT.nvim#g<cr>
function! MapCC()
    if &buftype == ""
        nmap <buffer> <c-x> <leader>pc<C-L> 
    endif
endfunction 
autocmd FileType * call MapCC()
vmap \\v <Plug>(VM-Visual-Add)
"%s/^.\{-}",".\{-}",".\{-}","\(.\{-}\)".*/\1


nmap \\. <CMD>call Exec(expand('@:'))<CR>
"call nvim_input('ea<BS><tab>')<CR><CMD>call timerstart(1,"call nvim_input('<tab><c-y>')")<CR>
"
"
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>xr <cmd>TroubleToggle lsp_references<cr>

nmap _i <CMD>NayvyImports<CR>
nmap _I <CMD>NayvyImportFZF<CR>


nnoremap <expr><silent> <LocalLeader>ro  nvim_exec('MagmaEvaluateOperator', v:true)
nnoremap <silent>       <LocalLeader>rr <CMD>MagmaEvaluateLine<CR>
xnoremap <silent>       <LocalLeader>r  :<C-u>MagmaEvaluateVisual<CR>
nnoremap <silent>       <LocalLeader>rc <CMD>MagmaReevaluateCell<CR>
nmap gw <CMD>Wtf<CR>
nmap <leader>hs <Plug>(GitGutterStageHunk)
nmap <leader>hu <Plug>(GitGutterUndoHunk)

function! StashME()
 let stash = input('Enter name: ')
 exec "!git stash push -m \"". stash . '" --keep-index '. expand('%') 
endfunction
function! StashAll() 
    let stash = input('Enter name: ')
    exec "!pwsh -command \"StashAll ". stash . "\""
endfunction 



nmap <leader>GS <CMD>call StashME()<CR>
nmap <leader>Gs <CMD>call StashAll()<CR>
nmap <leader>gp <CMD>exec '!python c:/users/ekarni/.vim/pycharmst.py "'. expand('%') . '" ' .line('.')<CR>
nmap <leader>gc <CMD>cd ~/compare-my-stocks<CR>
function! LfFil(a)
exec " :LeaderfFile ". a:a
endfunction
function! DoMGf(a)
    exec "cd " .a:a
    norm \gf
endfunction 
nmap <leader>mo <CMD>call fzf#run({'source': uniq(sort(g:dirs)),'sink':function('LfFil')})<CR>
nmap <leader>MO <CMD>call fzf#run({'source': uniq(sort(g:dirs)),'sink':function('DoMGf')})<CR>

command! -nargs=0 -bang AmendCur  :Gw | :Git commit --amend -v -q --no-edit | :exec ("<bang>"=="!" ? "Git push --force" : "echo")
command! -nargs=0 -bang  AmendAll   :Git commit --amend -a -v -q --no-edit | :exec ("<bang>"=="!" ? "Git push --force" : "echo")

nmap <leader>GWP mc:Gw<CR>:!git commit --amend --no-edit<CR>:!git push --force<CR>
nmap <leader>Gw mc:Gw<CR>\Gc
nnoremap <leader>w <CMD>Gwrite<CR>
nmap <leader>gC <CMD>call GitF("",0)<CR>
"#save and push  
nmap Zp ZZ<CMD>redraw<CR><CMD>Git push<CR>
nmap ZP ZZ<CMD>redraw<CR><CMD>Git push --force<CR>
" Get the directory of a file
" - On Ex command lines, returns the directory of the file ('./' for new files)
" - On other command lines (/,?) returns the keymap used to trigger it
function! Command_dir(keymap) abort
  let l:command_type = getcmdtype()
  if l:command_type isnot# ':'
    return a:keymap
  endif
  let l:dir = expand('%:h')
  if empty(l:dir)
    let l:dir = '.'
  endif
  if has("win64") || has("win32") || has("win16")
      return l:dir . '\'
  else 
      return l:dir . '/'
  endif
endfunction
cnoremap <expr> %% Command_dir('%%')
"delete same file
nmap <leader>ds <CMD>let current_bufname = expand('%:t') <bar> let current_bufnr = bufnr('%') <bar> for i in range(1, bufnr('$')) <bar> if bufexists(i) && i != current_bufnr && bufname(i) =~ current_bufname <bar> execute 'bdelete' i <bar> endif <bar> endfor<CR>

function! OpenSameFileInVSplit()
    let current_bufname = expand('%:t')
    let current_bufnr = bufnr('%')
    for i in range(1, bufnr('$'))
        if bufexists(i) && i != current_bufnr && bufname(i) =~ current_bufname
            execute 'vertical sb' i
            break
        endif
    endfor
endfunction


nmap <leader>dsp <CMD>call OpenSameFileInVSplit()<CR>
nmap <leader>dD <CMD>call OpenSameFileInVSplit()<CR><CMD>diffthis<CR><CMD>call GoOther()<CR><CMD>diffthis<CR>
"nmap _A <CMD>lua require("actions-preview").code_actions()<CR>

"function! SE()
    "echom "xxx"
    ""call feedkeys("\<CR>",'t')
    "norm <CR>
"endfunction 


function! SE()
    call feedkeys("\<CR>")
endfunction 
nmap <leader>gg <CMD>BookmarkGo<CR><CMD>call EasyMotion#SolEnter(0,2,'call SE()')<CR>
nmap <leader>GG <CMD>BookmarkGo<CR>
nmap <leader>ga <CMD>BookmarkAdd<CR>
nmap ? <c-a>j

function! DDa()
           <CMD>lua vim.lsp.buf.code_action()
           <CMD>sleep 5
           <CMD>call feedkeys('4','t')
       endfunction



nnoremap <leader>XD <CMD>lua vim.diagnostic.setloclist()<CR>

"check file
 "nnoremap <leader>xf <CMD>lua vim.diagnostic.setloclist()<CR><CMD>Lfilter /\cundefined \\|expected \\|syntax\\|not defined\\|Arguments missing\\|No Parameter/<CR>

"restore cfilter
nnoremap <leader>XR <CMD>lolder<CR>



"to paste with formatting

imap <c-i> <c-o><CMD>norm mP<CR>

nmap <leader>dx <CMD>diffthis<CR><CMD>call GoOther()<CR><CMD>diffthis<CR>



nnoremap <leader>Grc <CMD>Git rebase --continue<CR>

nnoremap <leader>Gra <CMD>Git rebase --abort<CR>

nnoremap <leader>Gw <CMD>Gwrite<CR>

nnoremap <leader>GA <CMD>Gwrite<CR><CMD>Git commit  -a --amend --no-verify --no-edit<CR>

nnoremap <leader>Gcv <CMD>Git commit -v -q<CR>

nmap <leader>GH :DiffviewFileHistory %<CR>
nmap <leader>Gh :DiffviewFileHistory --base=LOCAL %<CR>
nmap <leader>gh :DiffviewFileHistory --base=LOCALÃƒâ€šÃ‚Â %<CR>



nnoremap msS <CMD>%s/\s//g<CR>



"remove dumplicate lines

nnoremap msd <CMD>silent! %s/\r\r/\r/g<CR><CMD>silent! %s/\n\n/\r/g<CR><CMD>silent! %s/^M/^M/g<CR>



nmap mst <CMD>s/ //g<CR>


"nmap I <CMD>call StartSpecialInsert()<CR>i

"nnoremap <leader>I I

"nmap A <CMD>call StartSpecialInsert()<CR>i

"nnoremap <leader>A A

nmap % <Plug>(MatchMetaN)

inoremap <m-b> <c-v>
cnoremap <m-b> <c-v>
nnoremap R q
cabbr %G Gvdiffsplit
nmap <leader>AC <CMD>AvanteAsk /clear<CR>
nmap <leader>ae <CMD>AvanteEdit<CR>
nmap <leader>rF <CMD>source %<CR>


nnoremap <leader>ti A  # pyright: ignore<Esc>
nmap <m-.> <CMD>norm @a<CR>
" Define mapping as @a . you can also repeat it with <c-.>
nmap <leader>tm <CMD>call DoTM()<CR>
function! DoTM() abort
    let comman = input("enter mapping ")
    let @a= ":norm ". comman . "\<CR>"
    let x=":norm @a\<CR>"
    call feedkeys(x,'t')
endfunction

function! CreateList() range
execute a:firstline . ',' . a:lastline . 's/^\(.*\)$/"\1",/'
execute a:firstline . ',' . a:lastline . 'join'
norm $x
endfunction
nmap <leader>vn <cmd>call CloseVspIfNeed()<CR><CMD>:vnew<CR>
nmap <leader>ps <CMD>call TogglePS()<CR>
nmap <c-,> mc<leader>ac
