
"tabs
let i = 1
while i <= 9
    execute 'nnoremap <Leader>' . i . ' :' . i . 'tabn<CR>'
    let i = i + 1
endwhile


"mouse 
"nmap <MiddleMouse> :redraw<CR>
"nmap <MiddleMouse> i
"imap <MiddleMouse> <ESC>
"
"
"speical insert
nmap <RightMouse> <F12>
imap <RightMouse> <ESC>

nmap <Home> ^


"replace vanila
nnoremap <leader>& &
"get start of (next) string
"nmap <expr> & (getline('.')[col('.')-1]=='"' <bar><bar> getline('.')[col('.')-1]== "'") ? "%" : "viqo\<ESC>h"
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
noremap m? ?


:nmap q :exec "normal i".nr2char(getchar())."\e"<CR>
":nmap ! :exec "normal a".nr2char(getchar())."\e"<CR>
"qw inserts char after

"nmap s :<C-U>call InsertBefore(v:count1)<CR>
"nnoremap F f
"nmap S :<C-U>call InsertAfter(v:count1)<CR>
"nnoremap q t

"The <M-t> provides omni tl-search 

nmap <M-f> <Plug>(easymotion-s2)

"replaacing default
nnoremap zq q
"Alt - q is the new macro recording ....
nnoremap <M-q> q
"nmap s <Plug>(easymotion-s)
"nmap S <Plug>(easymotion-s2)
"endif
"meaning u would be like search everywhere
vmap s <Plug>(easymotion-sl)
"omap U <Plug>(easymotion-bd-tl)
vmap u <Plug>(easymotion-bd-fl)
"vmap U <Plug>(easymotion-bd-tl)
vmap U <Plug>(easymotion-bd-tl)

vnoremap <leader>U U
"vnoremap <leader>U U
"we use t for saving
nmap <nowait> t :let g:init=1<CR>:w<CR>

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

nnoremap , :LeaderfDisablePreview<CR>:Leaderf line --popup<CR>
nmap m, :LeaderfEnablePreview<CR>:Leaderf line --popup<CR>
"nnoremap <leader><c-t> <c-t>

"wroks with all letters but N
"nmap T <Plug>(easymotion-sl)

"
" _ mappings 
noremap _g :diffget<CR>
noremap _p :diffput<CR>
nmap _u :LastWindow<CR>

if g:on_ek_computer
    nmap _U :Telescope my_last_windows<CR>
endif
nmap _. :cd ..<CR>
nmap _- :cd -<CR>
"previous window
nmap _P :wprevious<CR>
nmap _N :wnext<CR>

"do comment out
map __ <leader>Cc
"uncomment
map _+ <leader>Cu
"Alternative buffer
map _# :e #<CR>

"Previous and next visited buffer \<c-o> of course
"nmap <c-[> <bar><DOWN><CR>
"nmap <M-[> <bar><UP><CR>

nmap _t :exe "tabn ".g:lasttab<CR>
noremap _b :bnext<CR>
noremap _B :bprev<CR>

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
noremap <F1> :execute ":help " . expand('<cword>')<CR>
"execut under cursor
nnoremap <F2> :exe getline(".")<CR>
vnoremap <F2> "xy:@x<CR>

"nmap <leader><F5> q:i<esc>
noremap <S-F3> :call Goprev()<CR>
noremap <S-F4> :call Gonext()<CR>
nnoremap <S-F6> "xddkk"xp
nnoremap <S-F7> "xyy"xp
nnoremap <S-F8> "xdd"xp

vmap <F3> "xygv:TREPLSendSelection<CR>
nmap <F3> :call AddInsert(getline('.'))<CR>:TREPLSendLine<CR>
nmap <F4> :exec("Texec clear\r\n")<CR>:exec("Texec &" .expand("%:p") . "\r\n")<CR>
nmap <F8> :exec("Texec clear\r\n")<CR>

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

nmap <F13> :call StartSpecialInsert()<CR>i
nmap <F12> :call StartSpecialInsert()<CR>i
imap <F12> <c-o>
imap <F13> <ESC>



"call DisableKeys()


"ctrl commands
"

"faster
nnoremap <c-,> :Leaderf line --recall<CR>


"nmap <C--> <Plug>Sneak_,
"nmap <C-=> <Plug>Sneak_;
nmap <C-=> <Plug>(easymotion-next)
nmap <C--> <Plug>(easymotion-prev)
nmap <c-_> :let g:EasyMotion_add_search_history=1<CR><Plug>(easymotion-sn)



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


"!!!   Movements !!! 
"
" in insert mode M is same line , and <c-.> . Use <c-.> 
" in normal mode M is same line
"imap <M-f> <c-o><Plug>Lightspeed_s
"imap ` <c-o><Plug>Lightspeed_s
imap <silent><script><expr> <C-j> copilot#Accept("")
imap <silent><script><expr> <M-j> copilot#Next()
let g:copilot_no_tab_map = v:true

function! FF()
    :call quick_scope#Wallhacks()
    return "\<c-o>\<Plug>(easymotion-sl)"
endfunction
imap <expr> <c-.> FF()
imap <expr> <c-'> FF()
imap <c-/> <c-o><Plug>Lightspeed_s
imap <M-/> <c-o><Plug>Lightspeed_S
autocmd FileType * inoremap <expr> <c-]> IsRegular() ? "<c-o><Plug>Lightspeed_s" : "<c-]>"
autocmd FileType * nnoremap <expr> <c-]> IsRegular() ? "<Plug>Lightspeed_s" : "<c-]>"
autocmd FileType * nnoremap <expr>  m<c-]> <c-]>
autocmd FileType * inoremap <expr> <c-[> IsRegular() ? "<c-o><Plug>Lightspeed_S" : "<c-[>"
autocmd FileType * nnoremap <expr> <c-[> IsRegular() ? "<Plug>Lightspeed_S" : "<c-[>"


"imap <tab> <c-o><Plug>Lightspeed_s
"imap <S-tab> <c-o><Plug>L`ightspeed_S
"nmap <M-/> <Plug>(easymotion-tl)
"imap <M-t> <c-o>:call Teasy()<CR> 
nmap <M-t> <Plug>(easymotion-bd-tl)
imap <M-t> <c-o><Plug>(QuickScopet)
nmap <M-t> <Plug>(QuickScopet)
xmap <M-t> <Plug>(QuickScopet)
omap <M-t> <Plug>(QuickScopet)
"this is untill"
"map <Plug>cusF :call quick_scope#Wallhacks()<CR><Plug>(easymotion-sl)
"map <Plug>cusnf :call quick_scope#Wallhacks()<CR><Plug>(Lightspeed_f)
"map <Plug>cusnF :call quick_scope#Wallhacks()<CR><Plug>(Lightspeed_F)
function! FFn()
    :call quick_scope#Wallhacks('t')
    return "\<Plug>Lightspeed_F"
endfunction
nmap <expr> f Ffn()
nmap <expr> F FFn()
function! Ffn()
    :call quick_scope#Wallhacks('f')
    return "\<Plug>Lightspeed_f"
endfunction
"nmap F <Plug>cusF
nmap s <Plug>Lightspeed_s
nmap S <Plug>Lightspeed_S
"nmap s <plug>Sneak_s
"nmap S <plug>Sneak_S
imap <c-t> <c-o>F

"Logical, since in normal we have s and S
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


nmap <c-s> :let g:EasyMotion_add_search_history=1<CR><Plug>(easymotion-sn)
nmap <m-s> <Plug>(easymotion-tn)
vmap <c-s> <Plug>(easymotion-s2)

"search help , lift saving
nmap <c-f> mH
"nmap <c-g> :call CocActionAsync("doHover")<cr>

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

imap <c-w> <c-o>db
imap <M-Right> <c-o>W
imap <M-Left> <c-o>B
imap <M-Up> <c-h>
imap <M-Down> <c-o><Plug>(easymotion-bd-wl)
"inoremap <c-k> <Cmd>call feedkeys("\<c-L>",'n')<CR>
"completes one char or  from dict 
inoremap <expr> <C-K>  pumvisible()? "<c-k>" : "<c-o>:call RecallInserts(0)<CR>"
"inoremap <expr> <C-b>  pumvisible()? "<c-b>" : "<c-o>:call RecallInserts(0)<CR>"
imap <c-b> <c-o>:call RecallInserts(0)<CR>


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

imap <c-z> <CMD>call DoCz()<CR> 
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
    nmap <M-r> :call IPyRun(input('enter python: ','','custom,IPyCompleteForInput'))<CR>
    command PyRun -complete=custom,IPyCompleteForInput call IPyRun(<f-args>)
"nmap <M-r> :call IPyRun(input('enter python: '))<CR>
"nmap <M-I> :let @z=input('enter text: ') <bar> norm "zp<CR>
"nmap <M-i> :let @z=input('enter text: ') <bar> norm "zp<CR>
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
"nmap § :call StartSpecialInsert()<CR>i
"imap § <c-o>
inoremap § <c-l>

"imap <c-z> <c-f><c-r>=SuperTab('n')<CR> 
"

vmap <c-t> :Trans<CR>
"imap <c-i> <c-f><S-Tab>

function! CompleteInf()
	let pre= '\(\\ref{\zs\k*$\|\\cite{\zs\k*$\|\k*$\)'
	let nl=[]
	let l=complete_info()
	for k in l['items']
		call add(nl, k['word']. ' : ' .k['info'] . ' '. k['menu'] )
	endfor 
	call fzf#vim#complete(fzf#wrap({ 'source': nl,'prefix':pre, 'reducer': { lines -> split(lines[0], '\zs :')[0] },'sink':function('PInsert2')}))
endfunction 
"get documention of current symbol
noremap <m-k> :let x=printf("Leaderf help --input %s", expand("<cword>"))<CR>:exec x<CR>
vmap <m-k> "xy:let x=printf("Leaderf help --input \"%s\"", getreg("x"))<CR>:exec x<CR>
"com
"completion by fuzzing of anything
imap <c-.> <CMD>:call CompleteInf()<CR>
cmap <c-.> <CMD>:call CompleteInf()<CR>
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

nmap [a :ALEPrevious<CR>
nmap ]a :ALENext<CR>
nmap ]E <Plug>(coc-diagnostic-next)
nmap [E <Plug>(coc-diagnostic-prev)
nmap ]e <Plug>(coc-diagnostic-next-error)
nmap [e <Plug>(coc-diagnostic-prev-error)
nmap [h <Plug>(GitGutterPrevHunk)
nmap ]h <Plug>(GitGutterNextHunk)
"map <expr><buffer> ]M repmo#Key('<plug>(PythonsenseEndOfPythonFunction)', '<plug>(PythonsenseEndOfPreviousPythonFunction)')|sunmap <buffer> ]M
"map <expr><buffer> [M repmo#Key('<plug>(PythonsenseEndOfPreviousPythonFunction)', '<plug>(PythonsenseEndOfPythonFunction)')|sunmap <buffer> [M
""" g mapping 
"makesure we are powershell
nmap gp :exec ":e ". system("TranslatePath ".expand('<cfile>'))<CR>
""" m mappings


nnoremap mb iimport ipdb;ipdb.set_trace()<ESC>
" jump to current path
nmap mC :call CopyPath()<CR>
noremap mc :cd %:p:h<CR>
nnoremap md :diffupdate<CR>
nnoremap mf :!start %:p:h<CR>
nnoremap mF :exec '!open '.getcwd()<CR>
nmap mF vaF<F2>


"go to the current selection in rg"xy:call feedkeys("\<C-a>g" . @x)<CR>

"vmap mg <C-Y>

"exact 
vnoremap mge "xy:exe ":FzfRg -e" . @x<CR>
"current folder lookup word
"nmap mg viWmg
"current file lookup word
nmap MG viWY
nnoremap MH :Help 
nnoremap Mh :help 
nnoremap mH :LeaderfHelp<CR>
noremap mm :LeaderfMru<CR>
"this is by order and not fuzzy
noremap mM :Mru<CR>

"newline

nnoremap mn o<ESC>D
noremap H ~
noremap \H H
noremap \L L
"nnoremap <leader>H H
"H is available
"great!
nnoremap <leader>M M

function! MPf()
	let @+ =substitute(@+,"\<NL>$","",'')
	let @+ =substitute(@+,"^[ \t]*","",'')
	exec "norm \"+]P"
endfunction

"paste new line
"remove indent
"
nnoremap mp o<esc>:s/[^ \t]//ge<CR>:call MPf()<CR>
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


"nnoremap <silent> mp :call Putline("]p")<CR>
function! Domp()
	let @z=substitute(@+,"\<NL>","","g")
endfunction

vnoremap mP :call Domp()<CR>"zp
nnoremap mP :call Domp()<CR>"zp
nnoremap MP :call Domp()<CR>"zP
"convert from WINDOWS style <CR> 
nmap mwin :s/\<lf>CR>//g<CR>

"remove empty spaces and lines
nnoremap msA :%s/^[\t ]*//<CR>:%s/\s\+$//e<CR>:%g/^[\t ]*$/d<CR>:%s/[  ]* / /g<CR>
nnoremap msa :s/^[\t ]*//<CR>:s/\s\+$//e<CR>:.g/^[\t ]*$/d<CR>:s/[  ]* / /g<CR>

nnoremap msb :%s/\s\+$//e<CR>:g/^$/d<CR>:%s/[  ]* / /g<CR>
"remove multi space in current line
nnoremap mss :s/\s\+/ /g<CR>
"remove empty lines
nnoremap msl :%s/\s\+$//e<CR>
nnoremap msl :%g/^\s*$/norm dd<CR>
"remove trailing spaces
nnoremap msc :%s/^\(.\{-\}\)[ ]*$/\1<CR>
"open cur folder 
"nmap mt :NvimTreeClose<CR>:echom ":NvimTreeOpen ".getcwd() <CR>:exec ":NvimTreeOpen ".escape(getcwd(),'\')<CR> 
"noremap mt :call CloseAllNR()<CR>:sleep 200m<CR>:exec ":vert topleft split " . getcwd()<CR>
"noremap mT :call CloseAllNR()<CR>:sleep 200m<CR>:exe ":tabnew ".expand("%:p:h")<CR>
"open cur file's folder
"mt is defined in lua
noremap MT :exec "NvimTreeOpen ".expand("%:p:h")<CR>
"noremap mt :NERDTreeFind<CR>

nnoremap mu :UndotreeToggle<CR>
"nnoremap mu :MundoShow<CR>

nnoremap mws :CtrlSpaceSaveWorkspace<CR>
nnoremap mwd :let g:overrideCWD=0<CR>:CtrlSpaceSaveWorkspace default<CR>let g:overrideCWD=1<CR>

nmap TT :LeaderfLineCword<CR>
vnoremap T "xy:call feedkeys( ":LeaderfLine\<lt>CR>". @x ,'t')<CR>
function! SpecialFindLeader(type)
  let &selection = "inclusive"
	exec 'normal! `[v`]"xy'
    :call feedkeys( ":LeaderfLine\<CR>". @x ,'t')
	"call Matches(@x)
endfunction

function! SpecialFind(type)
  let &selection = "inclusive"
	exec 'normal! `[v`]"xy'
	call Matches(@x)
endfunction

nnoremap M :set opfunc=SpecialFind<CR>g@
"vmap T 
nmap Mm Miw
nmap MM MiW

function! SpecialFindRg(type)
  let &selection = "inclusive"
	exec 'normal! `[v`]"xy'
    :call feedkeys( ":LeaderfRgInteractive\<CR>". @x . "\<CR>\<CR>") 
endfunction

nnoremap L :set opfunc=SpecialFindRg<CR>g@
vmap L <C-Y>
nmap Ll Liw
nmap LL LiW
"make it seach the current zone
vnoremap RR "xy/=escape(@x,'\/')<CR><CR>
"look in the current file for all matches
vnoremap Y "xy:call Matches(@x)<CR>
vmap M Y
"to find small word
"coc#config
"copy entire line no new line
nnoremap my yy:let @+=@+[:len(@+)-2]<CR>
"nnoremap <C-P> :CtrlPCurWD<CR>
nmap m' ysiW'
nmap m{ ysiW{
nmap m[ ysiW[
nmap m( ysiW(

nnoremap M, :CtrlP<CR>
nnoremap m. :CtrlPClearCache<CR>:CtrlP<CR>
nnoremap mj :set nohlsearch<CR>
nnoremap mrn :if &relativenumber <bar> :set norelativenumber <bar> else <bar> :set relativenumber <bar> endif<CR>
" \y is copy to another register
"don't use it to cut
noremap x "_x
"open command and search
nmap m~ <c-a>c
nnoremap mQ q:k
nnoremap <leader>~ ~
nnoremap <M-Space> q:i

"nmap m~ q:i<esc><c-s>
"just opens
nnoremap mq q:i<esc>


"nmap <leader>bh :split <bar> :e ~/.bash_history<CR>,
"nmap <leader>bh :call fzf#run({'source':"cat ~/.bash_history \<bar> sort \<bar> uniq",'sink': function('BH')})<CR>
function! CompleteCommand(arg)
	call fzf#run({'source': GetCommands(),'sink': function('HandleCommand'),'options': '-m --query "'.a:arg.'"'} ) 
endfunction 

nnoremap <leader>R R

"this function maps all registers so that we know what we have in each
"c-q for insert mode%. R for other modes.
func! MapR()
	let lst=['+','*','.','=','%']
    imap <M--> <CMD>:echo getreg("+")<CR>
    imap <M--> <CMD>:echo getreg("+")<CR>
    imap <M-=> <CMD>:echo getreg("=")<CR>
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
		exec 'nmap R'. i .' :echo getreg("'.i .'")<CR>'
		exec 'vmap R'. i .' <CMD>:echo getreg("'.i .'")<CR>'
		"exec 'imap <M-'. i .'> <CMD>:echo getreg("'.(i) .'")<CR>'
endfor 
endf

call MapR()

"complete the command using recent commands 
:cmap <expr> <c-a> &cedit.'^"xy$'."<esc><esc>:call CompleteCommand(@x)<CR>"
"edit command in command window
:cmap <expr> <c-b> &cedit."i"


nnoremap <silent> <C-a>c :call fzf#run({'source': GetCommands(),'sink': function('HandleCommand'),'options': '-m'} )<CR>
"search only for the mapping key
noremap <silent> <C-a>m :Maps<CR>
"search in mapping description as well
nnoremap <silent> <C-a>M :call fzf#run({'source': GetMappings(),'options': '-m'} )<CR>
nnoremap <leader><bar> <bar>
"nnoremap <silent> <bar> :call FZFOpen(':Buffers')<CR>
"<M-Bslash>
"<M-Bslash>
nmap m<bar> :LeaderfDisablePreview<CR><bar>
nmap <M-Bslash> :let g:Lf_JumpToExistingWindow = 0<CR>:Leaderf --popup buffer<CR>
"nnoremap <silent> <M-Bslash> :call FZFOpen(':Windows')<CR>
nnoremap <silent> <bar> :LeaderfEnablePreview<CR>:let g:Lf_JumpToExistingWindow = 1<CR>:Leaderf --popup buffer<CR>
nnoremap <silent> <C-a>b :call FZFOpen(':Buffers')<CR>
"nnoremap <silent> <C-z> :call FZFOpen(':Buffers')<CR>

nnoremap <silent> <C-a>g :LeaderfRgInteractive<CR>
"nnoremap <silent> <C-a>g :Telescope live_grep<CR>
nnoremap <silent> <C-a>G :lua require('git_grep').live_grep( {additional_args = { "--","*.py"}} )<CR>
"nnoremap <silent> <C-a>g :call FZFOpen(':FzfRg!')<CR>
"nnoremap <silent> <C-a>G :Leaderf rg -tpy<CR>

"for exact
"nnoremap <silent> <C-a>G :call FZFOpen(':FzfRg! -e')<CR>
nnoremap <silent> <C-a>C :call FZFOpen(':Commands')<CR>
"nnoremap <silent> <C-a>l :call FZFOpen(':BLines')<CR>
"c-l is lines in insert mode aaa
nnoremap <silent> <C-a>l :call GetAllInsertsForCurrentBufs()<CR>
nnoremap <silent> <C-a>L m':LeaderfLineAll<CR>
nnoremap <silent> <C-a>r :Leaderf --recall<CR>
nnoremap <silent> <C-a>R :LeaderfRgRecall<CR>
"files current dir
"nnoremap <silent> <C-a>f :call FZFOpen(':Files')<CR>
"nnoremap <c-a>f :CtrlPCurWD<CR>
"nnoremap <silent> <C-a>f :exe ":LeaderfFile ".getcwd()<CR>
nnoremap <c-a>f :Telescope find_files<CR>
nnoremap <c-a>j :lua require('telescope.builtin').jumplist({fname_width=80 , layout_config = {      preview_width = 0.6,       width = 0.9     }})<CR>
"files current file
"66444
nnoremap <silent> <C-a>F :exe ":LeaderfFile " . expand('%:p:h')<CR>
nnoremap <silent> <C-a>h :call FZFOpen(':History')<CR>
nmap <silent> <C-a>H :call fzf#run({'source':"cat ~/.bash_history \<bar> sort \<bar> uniq",'sink': function('BH')})<CR>
nnoremap <silent> <C-a>a :call FZFOpen(':Ag')<CR>
nnoremap <silent> <C-a>d :call fzf#run({'source': uniq(sort(g:dirs)),'sink':function('CdDirPlug'),'options': '-m'})<CR>
nnoremap <silent> <C-a>D :call fzf#run({'source': uniq(sort(g:dirs)),'sink':function('CdDir'),'options': '-m'})<CR>
nnoremap <silent> <C-a>w :call FZFOpen(':Windows')<CR>
nnoremap <silent> <C-a>s :call FZFOpen(':Snippets')<CR>
"use it to increase
nnoremap <silent> <C-a><C-a> <C-a>

  " open FZF in
  " current file's2 directory
  "
nmap <leader>W :set wrap<CR>

function! GitDir()
let top = systemlist("git rev-parse --show-toplevel")[0]
return top . "/.git"
endfunction

"does diff of all files (could be vs version) 
function! GCWDComplete(A, L, P) abort
return fugitive#Complete(a:A, a:L, a:P, {'git_dir': GitDir()})
endfunction

command! -bang -nargs=? -range=-1 -complete=customlist,GCWDComplete GCWD exe fugitive#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>,   { 'git_dir': GitDir() })

nmap mg :GCWD<CR>
nmap MG :unlet b:git_dir<CR>:G<CR>


map <leader>g2 :diffget \\2<CR>
map <leader>g3 :diffget \\3<CR>
nnoremap <leader>Gs :Gdiff --staged<CR>
nnoremap <leader>Gc :Git commit -v -q<CR>
nnoremap <leader>GC :Git commit --amend --no-verify<CR>
nnoremap <leader>Ga :sil Git add %<CR>
nnoremap <leader>Gt :Git commit -v -q %<CR>
nnoremap <leader>Gd :Gvdiffsplit<CR>

nnoremap <leader>GD :Gvdiffsplit!<CR>
nmap <leader>GD Git! diff<CR>
nnoremap <leader>Ge :Gedit<CR>
nnoremap <leader>Gr :Gread<CR>
nnoremap <leader>Gmo Git merge --strategy-option ours origin/master<CR>
nnoremap <leader>Gmt Git merge --strategy-option theirs origin/master<CR>
"Git log all commits
nnoremap <leader>Gl :silent! Glog<CR>
"Git log current
nnoremap <leader>GL :0GcLog<CR>
nnoremap <leader>Gg :Git grep<Space>
nnoremap <leader>Gp :Git push<CR>
nnoremap <leader>Gu :git push upstream<CR>
nnoremap <leader>GU :git push -f upstream<CR>
nnoremap <leader>GP :Git push --force<CR>
nnoremap <leader>Gb :Git branch<Space>
nnoremap <leader>Go :Git checkout<Space>
"nnoremap <leader>Grc :Git rebase --continue<CR>
"nnoremap <leader>Gra :Git rebase --abort<CR>


map <silent> <leader>? <Plug>(IPy-WordObjInfo)
" opens terminal in new window
"
noremap  <leader>od :exec ":vs " . getcwd()<CR>
nnoremap <leader>em :call Exec("messages")<CR>
nnoremap <leader>EM :call VspIfNeed()<CR>:enew<CR>:let @x=MinExec('messages')<CR>:norm "xp<CR>

"enable save
nnoremap <leader>as :if exists('b:auto_save') <bar> :let b:auto_save = !b:auto_save <bar> else <bar> let b:auto_save=1 <bar> endif<CR>:echo "it is now locally". b:auto_save<CR>
nnoremap <leader>SI :let b:save_inserts= !b:save_inserts<CR>:echo "save inserts is now ". b:save_inserts<CR>
nmap     <leader>AS :AutoSaveToggle<CR>

nnoremap <leader>do :diffoff<CR>
nnoremap <leader>du :diffupdate<CR>
nnoremap <leader>dt :diffthis<CR>







function! DoRf()
    let @+=expand("%:p")

    norm \tt
    call feedkeys("\<C-e>")
    call feedkeys("\<C-v>\<CR>")
    "exe "norm \<C-v>"

endfunction



au filetype python nmap <leader>rf  :exec ":call IPyRun(\"%run ".escape( expand('%:p'),'\') . "\")"<CR>
au filetype ps1 nmap <leader>rf  :call DoRf()<CR>
map <silent> <leader>rb <Plug>(IPy-Interrupt)
nmap <leader>rt <Plug>(IPy-Terminate)
map <leader>rc <Plug>(IPy-RunCell)
"redraw
nnoremap <leader>rd <c-L>

"todo FZF
nnoremap <leader>oc :copen<CR>
function! CloseVspIfNeed()
    "let x = tabpagebuflist()
    "if len(x)==1
    "vsp
    "endif
    for k in getwininfo()
        if k['winrow']<=2 && k['wincol']>1
            "look no further
            let id=k['winid']
            call win_gotoid(id)
            :close
        endif
    endfor
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

"opens file
nmap <leader>mg :call CloseVspIfNeed()<CR>:vnew<CR><leader>gf
nmap <leader>of :call CloseVspIfNeed()<CR>:vnew<CR>ml<M-Bslash>
nmap <leader>og :call VspIfNeed()<CR>:LeaderfFile<CR>
nmap <leader>OF :call VspIfNeed()<CR>mm
nmap <leader>mf :call VspIfNeed()<CR>mm
"open python
"function! findbufjup
    "o
"endfunction
nmap <leader>op :sp <bar> :exec ':'. bufnr("\[jupyter\]") .'buffer'<CR><c-w>k
nmap <leader>upd \ttupama

nnoremap <leader>oi :call RecallInserts(0)<CR>
nnoremap <leader>OI :call GetAllInserts()<CR>
nnoremap <leader>ol :lopen<CR>
nnoremap <leader>ov :TN ~/.vim/.vimrc<CR>
nmap <leader>om :TN ~/.vim/mappings.vim<CR>
nmap <leader>on :TN ~/.vim/myinit.lua<CR>

nnoremap <leader>oE :!

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
nnoremap <leader>ot :tabnew <bar> :call TermO()<CR>:call feedkeys("i")<CR>
"open terminal in new window
nmap <leader>tt :call TermOV(0)<CR>li
nmap <leader>Tt :call TermOV(1)<CR>li
nmap <leader>gt :call TermLOV()<CR>li
nmap <leader>ge :VimscriptLastError<CR>

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
noremap Q :close<CR>
nnoremap <leader>q :tabo!<CR>:call CloseAllBuffersButCurrent()<CR>
nnoremap <leader>Q :q!<CR>
"closes other buffer same tab
nnoremap <nowait> <leader>c :call CloseAllWindowsButCurrent()<CR>
nnoremap <nowait> <leader>C :call CloseAllNR()<CR>
 
nnoremap ZB :call CloseAllBuffersButCurrent()<CR>

nnoremap <silent> <Leader>= :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "vertical resize " . (winwidth(0) * 2)/3<CR>

"to use ml mj mk 
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>mt :tabnext<CR>
nnoremap <leader>nt :tabprevious<CR>

nmap ml <leader>l
nmap mj <leader>j
nmap mk <leader>k
nmap mh :wincmd h<CR>

"autocmd  FileType * nnoremap <nowait> <buffer> <leader>h :wincmd h<CR>

"avabnnoremap2 <leader>s :exec "normal i".nr2chaar(getchar())."\e"<CR>
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
		exec ":normal a"."\<c-r>=nr2char(".t.")\<ESC>"
    else
		exec ":normal i"."\<c-r>=nr2char(".t.")\<ESC>"
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

vmap mjoin "xdi<C-r>=MJoin()<CR>

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
		exec ":normal a"."\<c-r>=nr2char(".t.")\<ESC>"
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
"nmap ` :exec "normal i".nr2char(getchar())."\e"<CR>
"appends one char
"nthis isnoremap <leader>S :exec "normal a".nr2char(getchar())."\e"<CR>
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
nnoremap C :call StartSpecialInsert()<CR>ci
nnoremap cc C
nnoremap <leader>C cc 

nnoremap c "zc
"vnoremap cc "zcc
vnoremap c "zc

"We want to keep the pasted text, while z is the presented text in the visual
"...
vnoremap p :<C-U>let a=@*<CR>gvp:let @z=@"<CR>:let @*=a<CR>:let @"=a<CR>
vnoremap c "zdi

"cnnoremap <leader>. @:
nnoremap <C-.> @:


vnoremap <leader>p "zp
nnoremap <leader>p "zp
nnoremap <leader>P "zpi

" \y is copy to another register
noremap <leader>yy "zyy
noremap <leader>y "zy
noremap <leader>Y "zyi
"let g:jedi#completions_command='<leader>a'
"let g:jedi#usages_command='<leader>gn'

"Bare mappings
"changes current argument
"omap i, ?[\,(]?e+1<CR>cv/[\,)]/s-1<CR>
"nmap ci, dv?[\,(]?e+1<CR>cv/[\,)]/s-1<CR>
"nmap di, dv?[\,(]?e+1<CR>dv/[\,)]/s-1<CR>


" for ansi keyboard
"nnoremap ± :set incsearch<CR>/
nnoremap Y :set incsearch<CR>/\c
"nnoremap , :set incsearch<CR>/\c
"nnoremap <C-[> :set incsearch<CR>/\c
"vnoremap <nowait> af <Plug>(textobj-function-a) 

"execute a function based on the current visual selection but replace content of selection
vnoremap H "xy:call HandleH()<CR>
vnoremap <C-H> "xy:call HandleCH()<CR>
vnoremap <C-J> "xy:call HandleCJ()<CR>
"look in files for a match
"vnoremap <C-Y> "xy:exe ":FzfRg " . @x<CR>

"xy:call feedkeys("\<C-a>g" . @x)<CR> 

"nnoremap <C-K> :call RegsToggle()<CR>
"vnoremap <C-K> <CMD>:call RegsToggle()<CR>
nnoremap <c-k> <CMD>:ChatGPT<CR>
nmap <leader>pC :ChatGPT<CR>:Voice<CR>
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf


"translates
nmap <leader><c-t> vaw:Trans<CR>
vmap <leader>t :Trans<CR>

function! IfTerm()
    if &bt=="terminal"
       call feedkeys('i') 
    endif
endfunc 

function! GoOther()
    if OnRight()
        call feedkeys("\<c-w>h")
    else
        call feedkeys("\<c-w>l")
    endif
endfunction
"Move line to terminal
nmap mz my<CMD>:exec ":T ".  @" ."\r\n" <cr>
vmap mz <CMD>:'<,'>g/./norm mz<CR>
nmap <c-F5> mz

"nmap mz <CMD>:TREPLSendLine<CR>
"vmap mz <CMD>:TREPLSendSelection<CR>
"move between two panels (left and right) 
nnoremap <C-'> :call GoOther()<CR>:call IfTerm()<CR>
tnoremap <C-'> <C-\><C-n>:call GoOther()<CR>

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
    :tnoremap <C-t> <c-\><c-N>^w:exec 'cd '. expand('<cfile>')<CR>i
	"quits
	:tmap <C-q> <C-l>Q
	" copy line from $
endif
"esc only in neoterm
au filetype neoterm :tnoremap <buffer> <Esc> <C-\><C-n>
au filetype neoterm :tnoremap <buffer> <C-BS> <ESC>
"make Y act like M



"map NT :NERDTree
nnoremap TN :tabnew<CR>

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
"nnoremap <silent> _a  :<C-u>CocList actions<cr>
"" Manage extensions
"nnoremap <silent> _e  :<C-u>CocList extensions<cr>
"" Show commands
"nnoremap <silent> _c  :<C-u>CocList commands<cr>
"nnoremap <silent> _d  :<C-u>CocList diagnostics<cr>
"" Find symbol of current document
"nnoremap <silent> _o  :<C-u>CocList outline<cr>
" Search workspace symbols

" Do default action for next item.
"nnoremap <silent> _j  :<C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent> _k  :<C-u>CocPrev<CR>
" Resume latest coc list
"nnoremap <silent> _p  :<C-u>CocListResume<CR>
:endif

nnoremap _d :Telescope diagnostics<CR>
nmap _d :TroubleToggle<CR>
nnoremap _o :Telescope lsp_document_symbols<CR>
nnoremap _O :Telescope lsp_workspace_symbols<CR>
nnoremap _r :Telescope lsp_references<CR>
nnoremap _a :Telescope lsp_code_actions<CR>
nmap <nowait> <leader>s :Navbuddy<CR>

nnoremap <silent> _s  :Telescope lsp_workspace_symbols<CR>

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

"nnoremap <leader>gg :YcmCompleter GoTo<CR>
"nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>
"nnoremap <leader>gD :YcmCompleter GoToDeclaration<CR>
"nnoremap <leader>gI :YcmCompleter GoToInclude<CR>
"nnoremap <leader>gr :YcmCompleter GoToReferences<CR>
"nnoremap <leader>gT :YcmCompleter GetType<CR>
"
"au filetype c nnoremap K :YcmCompleter GetDoc<CR>
noremap <leader>gl :YcmCompleter GoToDeclaration<CR>
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
"set runtimepath^=~/vimpy3/plugged/coc-pythom

"function! SetupPython()
	":CocCommand python.setInterpreter
	":sleep 5
	":call feedkeys('5')
"endfunction

nmap <M-C-Q> :qa!

"nnoremap , :BLines<CR>
"nmap <c-,> :BLines<CR><C-P>
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
autocmd  FileType * vmap <nowait> <buffer> aF <Plug>(textobj-function-A)
"select func
vmap	aF	<Plug>(textobj-function-a)
vmap	iF	<Plug>(textobj-function-i)
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
map  <expr> ; repmo#LastKey(';')|sunmap ;
map  <expr> <C-\> repmo#LastRevKey(',')

map  <expr> <tab> repmo#ZapKey('<Plug>Lightspeed_s')
"|ounmap s|sunmap s
map  <expr> <S-tab> repmo#ZapKey('<Plug>Lightspeed_S')
"|ounmap S|sunmap S
"omap <expr> z repmo#ZapKey('<Plug>Sneak_s')
"omap <expr> Z repmo#ZapKey('<Plug>Sneak_S')
"map  <expr> f repmo#ZapKey('<Plug>cusnf')|sunmap f
"map  <expr> F repmo#ZapKey('<Plug>cusnF')

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
"nmap <esc> :call clever_f#_reset_all()<CR> 
"map  <expr> t repmo#ZapKey('<Plug>Sneak_t')|sunmap t
"map  <expr> T repmo#ZapKey('<Plug>Sneak_T')|sunmap T

"nmap f <Plug>(QuickScopef)
"omap f <Plug>(QuickScopef)
"xmap f <Plug>(QuickScopef)

"xmap F :call quick_scope#Wallhacks()<CR><Plug>(easymotion-sl)
"omap F :call quick_scope#Wallhacks()<CR><Plug>(easymotion-sl)
nmap ]d :lua vim.diagnostic.goto_next()<CR>
nmap [d :lua vim.diagnostic.goto_prev()<CR>

for keys in [[']E','[E'],[']a','[a'],[']d','[d'],[']e','[e'],[']h','[h'],['&','z&'], ["\<F4>","\<F3>"], [']=','[='], [']+','[+'], [']-','[-'],  [']c', '[c'], ['~','!']]
    call RepRemap(keys[0],keys[1])
endfor
" Now following can also be repeated with `,` and `;`:
" ,['<M-K>','<A-J>']
"
"for keys in [['l','h'],['k','j'], ['[[', ']]'], ['[]', ']['], [']m', '[m'], [']M', '[M'], [']c', '[c'] ,  [ 'w','b' ] ,[ 'W','B' ] ,[ 'e','ge' ] ,[ 'E','gE' ], ['<F4>','<F3>'],['<M-K>','<A-J>'],['{','}'],['(',')']]
"Not to mess with vim-tex [']]','[[']
for keys in [['[]', ']['], [']m', '[m'], [']M', '[M'],['l','h'],['k','j'],  [ 'w','b' ] ,[ 'W','B' ] ,[ 'e','ge' ] ,[ 'E','gE' ],['(',')']]
    execute 'silent noremap <expr> '.keys[0]." repmo#SelfKey('".keys[0]."', '".keys[1]."') |sunmap ".keys[0]
    execute 'silent noremap <expr> '.keys[1]." repmo#SelfKey('".keys[1]."', '".keys[0]."') |sunmap ".keys[1] 
    "execute 'noremap <expr> '.keys[0]." repmo#Key('".keys[0]."', '".keys[1]."')|sunmap ".keys[0]
    "execute 'noremap <expr> '.keys[1]." repmo#Key('".keys[1]."', '".keys[0]."')|sunmap ".keys[1]
endfor
endfunction

:autocmd CmdwinEnter * noremap <buffer> <F2> <CR>q:
:au BufWritePost * :let g:init=1

"evals a function based on the current visual selection
vnoremap F "xd"=HandleF()<CR>P
"execute a function based on the current visual selection
vnoremap <C-F> "xy:call HandleCF()<CR>p

"function! GetRegs()
    "call fzf#run({'source':":reg",'sink': function('PInsert')})<CR>
"endendfunction
"nnoremap <silent> <leader> :WhichKey '\'<CR>
"nnoremap <silent> m :WhichKey 'm'<CR>
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

:nnoremap <Leader>pp :lua require'telescope.builtin'.lsp_workspace_symbols{}<CR>
"Telescope
nmap <leader>gf :Telescope git_files<CR>
"nnoremap <leader>gr <cmd>lua require('telescope.builtin').live_grep{ cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1] ,glob='*.py'}<cr>


function! DoTag()
    let tmp=getcwd()
    :exe ":cd ". expand("%:p:h")

    let top = systemlist("git rev-parse --show-toplevel")[0]
    :exe ':lcd '. top
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
function! GitF(regfilter,curfile) 
    if (a:curfile)

    let tmp=getcwd()
    :exe ":cd ". expand("%:p:h")
endif 
    let top = systemlist("git rev-parse --show-toplevel")[0]
    "echo top
    :exe ':cd '. top
    let a=systemlist("git ls-files --full-name" )
    :if len(a:regfilter)>0
    let a = filter(a,{idx,val -> (val =~ a:regfilter)})
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

function! Gut(bb) 
exec 'cd '.expand('%:p:h')
:GutentagsUpdate
endfunction 
au filetype * command! -buffer GutenTagRun :call gutentags#setup_gutentags() <bar> :call timer_start(15,'Gut')<CR>
command! -nargs=1 LfExt :Leaderf rg --live --glob <q-args><CR>
command! -nargs=1 LfGitExt :call GitF(".*\\.". <f-args> ."$",0 )<CR>
command! -nargs=1 LfGitGen :call GitF(<f-args>,0)<CR>
"Edit file in the same folder
":com! -nargs=1 -bang -complete=customlist,EditFileComplete
        "\ EditFile edit<bang> <args>
":fun! EditFileComplete(A,L,P)
":    return split(glob(expand("%:p:h").'\*'.(len(a:A)>1 ? a:A . "*" : '')), "\n")
":endfun
"```vim
:com! -nargs=1 -bang -complete=customlist,EditFileComplete
        \ EditFile exec "edit<bang> ". expand("%:p:h")."/<args>"
:fun! EditFileComplete(A,L,P)
:    return map(filter(split(glob(expand("%:p:h").'/*'.(len(a:A)>1 ? a:A . "*" : '')), "\n"),'filewritable(v:val) != 2' ),'fnamemodify(v:val, ":t")' )
:endfun

vnoremap <leader>GR "xy:call feedkeys( ":LeaderfRgInteractive\<lt>CR>". @x . "\<lt>CR>\<lt>CR>")<CR>
vmap <c-y> <leader>GR
vnoremap <leader>gr "xy:call feedkeys( ":LfGitGen .*\\.py$\<lt>CR>". @x . "\<lt>CR>")<CR>

nmap <leader>gr :call GitF(".*py$",0)<CR>
nmap <leader>gR :call GitF("",0)<CR>
nmap <leader>Gr :call GitF(".*py$",1)<CR>
nmap <leader>GR :call GitF("",1)<CR>
nmap mr <leader>Gr
nmap mR <leader>GR
"nmap mr :call nvim_set_current_dir(expand('%:p:h'))<CR><leader>gr 
"nmap mR :call nvim_set_current_dir(expand('%:p:h'))<CR><leader>gr 

"nmap <leader>gs :call DoTag()<CR>
nmap <leader>gs :Telescope lsp_workspace_symbols<CR>

"~\compare-my-stocks\src\come_my_stocks\input\inputprocessorinterface.py:2" 15L, 350B

function! DoGF()
    let f=expand('<cfile>')
    let sec =expand('<cWORD>')
    let line= substitute(sec,'^.*(\(.*\),.*):.*$','\1','')
    let arr=split(f,':')
    if len(arr[0])==1
        let arr=[arr[0].':'.arr[1]]+arr[2:]
    endif
    if len(arr)>1
        if  filereadable(expandcmd(arr[0]))==0
            echoerr arr[0] . " File not exists"
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
 

nmap gf :call DoGF()<CR>

nmap \] mC:bd<CR>:e <C-R>=@*<CR><CR>
nmap <leader>gv :cd c:\users\ekarni\.vim<CR>:Leaderf rg --glob "*.vim" --glob "*.lua" --max-depth=1<CR>
"nmap {          <Plug>EnhancedJumpsOlder
"nmap }          <Plug>EnhancedJumpsNewer
"nmap g{         <Plug>EnhancedJumpsLocalOlder
"nmap g}         <Plug>EnhancedJumpsLocalNewer
"nmap <Leader>{  <Plug>EnhancedJumpsRemoteOlder
"nmap <Leader>}  <Plug>EnhancedJumpsRemoteNewer
nmap z; <Plug>EnhancedJumpsFarChangeOlder
nmap z, <Plug>EnhancedJumpsFarChangeNewer

command! -nargs=1 ReloadPackage :exe "cd c:/users/ekarni/.vim" <bar> lua require('funcs').reload_package(<f-args>)
nmap <leader>pc :ChatGPT<CR>

"function! GetVoice()
    "return py3eval('recognize_voice()')
"endfunction 
nmap <c-L> :Voice<CR>

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
nmap \\. :call Exec(expand('@:'))<CR>
"call nvim_input('ea<BS><tab>')<CR>:call timerstart(1,"call nvim_input('<tab><c-y>')")<CR>
"
"
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>xr <cmd>TroubleToggle lsp_references<cr>

nmap _i :NayvyImports<CR>
nmap _I :NayvyImportFZF<CR>


nnoremap <expr><silent> <LocalLeader>ro  nvim_exec('MagmaEvaluateOperator', v:true)
nnoremap <silent>       <LocalLeader>rr :MagmaEvaluateLine<CR>
xnoremap <silent>       <LocalLeader>r  :<C-u>MagmaEvaluateVisual<CR>
nnoremap <silent>       <LocalLeader>rc :MagmaReevaluateCell<CR>
nmap gw :Wtf<CR>
nmap <leader>ms <Plug>(GitGutterStageHunk)
nmap <leader>mu <Plug>(GitGutterUndoHunk)

function! StashME()
 let stash = input('Enter name: ')
exec "!git stash push -m \"". stash . '" --keep-index '. expand('%') 
endfunction 
nmap <leader>GS :call StashME()<CR>
nmap <leader>gp :exec '!python c:/users/ekarni/.vim/pycharmst.py "'. expand('%') . '" ' .line('.')<CR>
nmap <leader>gc :cd ~/compare-my-stocks<CR>
function! LfFil(a)
:exec " :LeaderfFile ". a:a
endfunction
function! DoMGf(a)
    exec "cd " .a:a
    norm \gf
endfunction 
nmap mo :call fzf#run({'source': uniq(sort(g:dirs)),'sink':function('LfFil')})<CR>
nmap MO :call fzf#run({'source': uniq(sort(g:dirs)),'sink':function('DoMGf')})<CR>

command! -nargs=0 -bang AmendCur  :Gw | :Git commit --amend -v -q --no-edit | :exec ("<bang>"=="!" ? "Git push --force" : "echo")

nmap <leader>GWP mc:Gw<CR>:!git commit --amend --no-edit<CR>:!git push --force<CR>
nmap <leader>Gw mc:Gw<CR>\Gc
nnoremap <leader>w :Gwrite<CR>
nmap <leader>gC :call GitF("",0)<CR>
"#save and push  
nmap Zp ZZ:Git push<CR>
nmap ZP ZZ:Git push --force<CR>
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
nmap <leader>ds :let current_bufname = expand('%:t') <bar> let current_bufnr = bufnr('%') <bar> for i in range(1, bufnr('$')) <bar> if bufexists(i) && i != current_bufnr && bufname(i) =~ current_bufname <bar> execute 'bdelete' i <bar> endif <bar> endfor<CR>
nmap <leader>ds :let current_bufname = expand('%:t') <bar> let current_bufnr = bufnr('%') <bar> for i in range(1, bufnr('$')) <bar> if bufexists(i) && i != current_bufnr && bufname(i) =~ current_bufname <bar> execute 'bdelete' i <bar> endif <bar> endfor<CR>

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
nmap <leader>dsp :call OpenSameFileInVSplit()<CR>
nmap <leader>dD :call OpenSameFileInVSplit()<CR>:diffthis<CR>:call GoOther()<CR>:diffthis<CR>

