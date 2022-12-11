"Last windows names

let g:lastWindows= []
let g:lastWinName = ""

function! SaveLastWindow()

if &bt == '' || &bt == 'help' || &ft == 'netranger' "|| &bt == 'nofile'
    let cur= expand( '<afile>' )
    "let cur = expand('%:p')

    if cur == g:lastWinName || cur ==""
        return
    endif 

    call add(g:lastWindows,cur) 

    let g:lastWinName=cur
endif

endfunction 

augroup bufclosetrack
  au!
  autocmd BufWinLeave * call SaveLastWindow()
"  autocmd BufHidden * call SaveLastWindow()
augroup END

function! LastWindow()
  exe "vsplit " . g:lastWinName
endfunction

command! -nargs=0 LastWindow call LastWindow()

"insert tracking aaaa
function! LoadInsertsForBuf()
    "echo 'loading inserts'
if exists('b:inserts')
    if len(b:inserts)>0
        "echo('exit')
        return 
    endif 
endif 
py3 << EOF
import vim
import pickle
try:
    assert len(inserts)>0
except:
    try:
        input = open(vim.eval('g:vimloc')+'\\inserts.cache', 'rb')
        inserts=pickle.load(input)
        baseinserts=(inserts if type(inserts)==dict else {})
        input.close()
    except:
        vim.command('echom "failed loading"')
        inserts={}
        baseinserts={}
dic={}
bufn=vim.eval('expand("%:p")')
if bufn in inserts:
    dic=inserts[bufn]
    if type(dic)==dict:
        if '' in dic:
            dic.pop('')
        else:
            pass
    else:
        pass
        #vim.command('echom "strange"')
EOF
"echo 'loading inserts2'
"echom py3eval("dic") 
let b:inserts = py3eval("dic")

if type(b:inserts)!=4
    let b:inserts={}
endif
endfunction

function! SaveLastInsert()
    if !exists("b:save_inserts")
        let b:save_inserts=1
    endif 
    if !(b:save_inserts==1)
        return 
    endif 
    if mode()=='c'
        return
    endif

    call AddInsert(@.)
    "endif
endfunction

function! SaveLastCopy()
    let reg= v:event['regname']
    "echo v:event['regcontents']
    if !exists("b:save_inserts")
        let b:save_inserts=1
    endif 
     if (b:save_inserts==0)
         return 
     endif 
    call AddInsert(getreg(reg))
endfunction

function! AddInsert(str)
    if len(a:str)>1000
        return
    endif
    if !exists('b:inserts')
        let b:inserts={}
        let b:lastinsert=''
    endif

    for k in split(a:str,'\n')
        call AddInsertInternal(k)
    endfor 

endfunction

function! AddInsertInternal(str)
    "for now
    if len(b:inserts)>1000
        "enters the start and removes from end
        let n=keys(b:inserts) 
        call remove(b:inserts,n[1000])
    endif 

    let ok=0
    let stills=1  
    let stindex=0
    let str=""
    let strt = substitute(a:str,"\<BS>",'\n','g')
    for i in range(len(strt))
        if match(strt[i],'\s')!=0
            let stills=0
        else 
            if stills
                "let stindex+=1 
                continue
            endif 
        endif 

        if match(strt[i],'\n')==0
            if len(str)>0
                let str=str[:-2]
                continue
            endif 
        endif 
        if match(strt[i],'\w')==0
            let ok+=1
        endif
        if match(strt[i],'\p')==0
            let str.=strt[i]
        endif 
    endfor
    if ok<3
        return
    endif
    let b:inserts[str]=localtime()
endf    

function! RecallInserts2()
    if !exists('b:inserts')
        return
    endif 
    let ls=sort((keys(b:inserts)), {arg2, arg1 -> b:inserts[arg1] - b:inserts[arg2]})
    :call fzf#run({'source': ls ,'sink':function('PInsert'),'options': '-m'})
endfunction

function! RecallInserts()
    if !exists('b:inserts')
        return
    endif 
    let ls=sort((keys(b:inserts)), {arg2, arg1 -> b:inserts[arg1] - b:inserts[arg2]})
    :call fzf#run({'source': ls,'sink':function('PInsert2'),'options': '-m'})
endfunction

function! GetAllInserts()
    let ls={}
    let lastbuf=bufnr('$')
    for i in range(lastbuf)
        let bufn=bufname(i)
        if bufn!=''
            let t=getbufvar(i,'inserts')
            if type(t)==4
                let ls=extend(ls,t)
            endif
        endif
    endfor
    let ls=sort(keys(ls), {arg2, arg1 -> ls[arg1] - ls[arg2]})
    :call fzf#run({'source': ls,'sink':function('PInsert2'),'options': '-m'})
endfunction
"dirs tracking
function! LoadDir()
py3 << EOF
import vim
import pickle
try:
    input = open(vim.eval('g:vimloc')+'\\dirs.cache', 'rb')
    dirs=pickle.load(input)
    input.close()
except:
    dirs=[]
vim.command("let g:dirs = " + str(dirs).replace('\\\\','\\'))
EOF
endfunction

function! SaveLastDir()
    if !exists('g:dirs')
        call LoadDir()
        let g:lastdir=''
    endif

    let reg=getcwd()
    if reg==g:lastdir
        return
    endif
    call add(g:dirs,reg)
py3 << EOF
import vim
import pickle
output = open(vim.eval('g:vimloc')+'\\dirs.cache', 'wb')
dirs=vim.eval('g:dirs')
dirs=list(set(dirs))
pickle.dump(dirs ,output)
output.close()
EOF
    let g:lastdir=reg
endfunction


function! SaveInsertsFunc(a)
    "we start with the original pickle. We then add the opened buffers.
    py3 inserts=baseinserts
    let lastbuf=bufnr('$')
    for i in range(lastbuf)
        let bufn=bufname(i)
        let bufpath= expand("#".i.":p")

        if bufn!=''
            let t=getbufvar(i,'inserts')
            py3 key=vim.eval('bufpath')
            py3 inserts[key]=vim.eval('t')
        endif
endfor
py3 << EOF
import vim
import pickle
output = open(vim.eval('g:vimloc')+'\\inserts.cache', 'wb')
pickle.dump(inserts ,output)
output.close()
EOF
endfunction

if has('nvim')
:autocmd InsertLeave * call SaveLastInsert()
":autocmd TextYankPost * call SaveLastCopy()
:autocmd TextYankPost * call SaveLastReg()
:autocmd BufRead * call LoadInsertsForBuf()
":autocmd BufNewFile if !exists('b:inserts') <bar> let b:inserts=[]  dsfsdf

:autocmd DirChanged * call SaveLastDir()
endif


"GL 
"

function! RunPython2(match,run)
PY << EOF
import vim
try:
    match=vim.eval("a:match")
    retval=eval(vim.eval("a:run"),globals())
except Exception as e:
    import traceback
    exp=traceback.format_exc()
    retval=None
    try:
        vim.command("echom pyxeval(\"exp\")")
    except:
        pass

if retval==None: retval=match
#vim.command("let retInVim=\"" + str(retval).replace("\"","\\\"") + "\"")
vim.command('let retInVim=pyxeval("retval")')
EOF
return retInVim
endfunction

function! RunPython(match,run)
PY << EOF
import vim
try:
    match=vim.eval("a:match")
    exec(vim.eval("a:run"))
except Exception as e:
    import traceback
    exp=traceback.format_exc()
    try:
        vim.command("echom \"" + str(exp).replace("\"","\\\"") + "\"")
    except:
        pass
EOF
return ""
endfunction

function! GL(arg) range
    let arg= substitute(a:arg,'\\/','REALSLASH','g')
    let lst=matchlist(arg,'/\(.\{-\}\)/\(.\{-}\) \(.*\)$')
    let lst[1]= substitute(lst[1],'REALSLASH','/','g')
    let lst[3]= substitute(lst[3],'REALSLASH','/','g')
"   echo lst
    if lst[2]==#"rpy"
        exec a:firstline. "," . a:lastline . ":s\/" . lst[1] . "/\\=RunPython2(submatch(1),\"". escape(lst[3],"\"//") . "\")"
    elseif lst[2]==#"py"
        exec a:firstline. "," . a:lastline . ":s\/" . lst[1] . "/\\=submatch(0) . RunPython(submatch(1),\"". escape(lst[3],"\"//") . "\")"
    endif
endfunction

command! -nargs=1 -range GL <line1>,<line2>call GL(<f-args>)

command! -nargs=1 P call RunPS(<f-args>) 
command! -nargs=1 TP call TogglePS()

"Matches
"
command! -nargs=* VG call Matches2(<q-args>)

command! -nargs=1 MESC call MatchesF(<q-args>)
command! -nargs=1 MC call Matches(<q-args>)
command! -nargs=1 MW call Matches('\<'.<q-args>.'\>')
command! -nargs=1 M call InMatches(<q-args>)
ca Y M

function! InMatches(pat)
    let buffer=bufnr("") "current buffer number
    let b:lines=[]
    "the right way to escape!!
    execute ":%g/\\V\\c" . escape(a:pat,'/\?') . "/let b:lines+=[{'bufnr':" . 'buffer' . ", 'lnum':" . "line('.')" . ", 'text': escape(getline('.'),'\"')}]"
    "call setloclist(0, [], ' ', {'items': b:lines})
    "call setloclist(0,b:lines)
    call setqflist(b:lines)
    copen
endfunction
function! Matches(pat)
    let buffer=bufnr("") "current buffer number
    let b:lines=[]
    "the right way to escape!!
    execute ":%g/\\V" . escape(a:pat,'/\?') . "/let b:lines+=[{'bufnr':" . 'buffer' . ", 'lnum':" . "line('.')" . ", 'text': escape(getline('.'),'\"')}]"
    "call setloclist(0, [], ' ', {'items': b:lines})
    "call setloclist(0,b:lines)
    call setqflist(b:lines)
    copen
endfunction
function! MatchesF(pat)
    let buffer=bufnr("") "current buffer number
    let b:lines=[]
    "no escape!!
    execute ":%g/" . a:pat . "/let b:lines+=[{'bufnr':" . 'buffer' . ", 'lnum':" . "line('.')" . ", 'text': escape(getline('.'),'\"')}]"
    "call setloclist(0, [], ' ', {'items': b:lines})
  "  call setloclist(0,b:lines)
    "lopen
    call setqflist(b:lines)
    copen
endfunction
function! Matches2(a,...)
    let where=get(a:,1,'**/*')
    :set eventignore=all
    execute ":vimgrep " . '/\V'.escape(a:a,'/\?') . "/j ". where
    :set eventignore=
    copen
endfunction

"special insert
"
let g:inactivity_limit = 1  " max Insert mode inactivity before fail, in seconds
let g:check_frequency = 200   "seconds between checks
let g:special_insert = 0


function! CheckSpecialInsert()
    if g:special_insert
        au monitor CursorHoldI * call feedkeys(':echo "Insert timed out"')
    endif
endfunction

function! StartSpecialInsert()
    let g:special_insert=1
endfunction

function! EndSpecialInsert()
    if g:special_insert
        au! monitor CursorHoldI
    endif
    let g:special_insert=0
endfunction


augroup monitor
    au!
    " when vim starts kick off the infinitely repeating calls to the monitor function
    au InsertEnter * call CheckSpecialInsert()
    au InsertLeave * call EndSpecialInsert()    " when cursor moves in Insert mode update the last activity time
augroup END


"""INSERT MODE SAVE
let g:detect_mod_reg_state = -1
function! DetectRegChangeAndUpdateMark()
    let current_small_register = getreg('"-')
    let current_mod_register = getreg('""')
    if g:detect_mod_reg_state != current_small_register || 
                \ g:detect_mod_reg_state != current_mod_register
        normal! mM
        let g:detect_mod_reg_state = current_small_register
    endif
endfunction

autocmd CursorMoved * call DetectRegChangeAndUpdateMark()
"last tab
"
if !exists('g:lasttab')
 let g:lasttab = 1
endif

au TabLeave * let g:lasttab = tabpagenr() 

"Marks
"
" Mark I at the position where the last Insert mode occured across the buffer
autocmd InsertLeave * execute 'normal! mI'

" Mark M at the position when any modification happened in the Normal or Insert mode
autocmd InsertLeave * execute 'normal! mM'

"timer func
"
"
au ExitPre call StopTimerFunc() 
function! StopTimerFunc()
    call timer_stop(g:autosaveWS)
endfunction

let g:last_copied=""
let g:init=0
function! TimerFunc(a)
    "updates shada files to keep current commands
    wshada
    let minbu=MinExec(':buffers')
    "echom minbu
    "echo "called"
    "multiple instances of neovim cause trouble when tried to save. I verify
    "that only in the neovim-qt (and make sure only 1 is opened), it will save
    ""exists('g:GuiLoaded') ||
    "if g:init==0
        "!cp /Users/eyalkarni/vimpy3/.git/cs_workspaces /tmp/befrep 
        "echom "replacing"
        "call ctrlspace#workspaces#DeleteWorkspaceEx('defaultOld')
        "!cp /Users/eyalkarni/vimpy3/.git/cs_workspaces /tmp/afterdel 
        "call ctrlspace#workspaces#RenameWorkspaceEx('default','defaultOld')
        "!cp /Users/eyalkarni/vimpy3/.git/cs_workspaces /tmp/afterrep 
    "endif 
"call ctrlspace#workspaces#SetActiveWorkspaceName('default')
    "Remember not to run in parallel
    if g:init==1
        if exists(':GonvimWorkspaceNew')==2 || exists('g:GuiLoaded')
            :silent :CtrlSpaceSaveWorkspace default
        endif
        "if g:init==0
        "let g:init=1
        "call ToggleVerbose() 
    endif

        ":profile stop
    "keep track of external clipboard using registers.
    if g:last_copied!=@+ && @+!=@"
        "from o to w
        for i in range(char2nr('v'),char2nr('o'),-1)
            exe "let @".nr2char(i+1)." = @". nr2char(i) 
        endfor
        let @o=@+
        let g:last_copied=@+
    endif

endfunction

function! SaveLastReg()
    if (b:save_inserts==0)
        return
    endif
    if v:event['regname']==""
        if v:event['operator']=='y'
            for i in range(8,1,-1)
                exe "let @".string(i+1)." = @". string(i) 
            endfor
            if exists("g:last_yank")
                let @2=g:last_yank
            endif
            let g:last_yank=@*
        endif 
    endif
endfunction 
"
function! Tailf()
    while 1
        e
        normal G
        redraw
        sleep 1
    endwhile
endfunction
command! Tailf call Tailf()<CR>
"TN
"

function! HandleTN(...)
if a:000==['']
        tabnew 
        return 0
endif 
return 1
endfunction
function! WhichTab(filename)
    " Try to determine whether file is open in any tab.  
    " Return number of tab it's open in
    let buffername = bufname(a:filename)
    if buffername == ""
        return 0
    endif
    let buffernumber = bufnr(buffername)

    " tabdo will loop through pages and leave you on the last one;
    " this is to make sure we don't leave the current page
    let currenttab = tabpagenr()
    let tab_arr = []
    tabdo let tab_arr += tabpagebuflist()

    " return to current page
    exec "tabnext ".currenttab

    " Start checking tab numbers for matches
    let i = 0
    for tnum in tab_arr
        let i += 1
        if tnum == buffernumber
            return i
        endif
    endfor

endfunction
command! -nargs=* -complete=file TN if HandleTN(<q-args>) <bar>  :let tab=WhichTab(<f-args>) <bar> if tab==0 <bar> :tabnew <args> <bar> :else <bar> :exe  'norm '.tab.'gt' <bar> endif <bar> endif


"" change window local working directory
"function! Tapi_lcd(cwd)
  "let winid = bufwinid('%')
  "if winid == -1 || empty(a:cwd)
    "return
  "endif
  "exe ':'.winid.'windo lcd '. a:cwd
"endfunction



function! s:register_list()
  " capture register output
  redir => registers_out
  silent registers
  redir END

  " put into List
  let register_lines = split(registers_out, '\n')

  " remove header: '--- Registers ---'
  call remove(register_lines, 0)
  return register_lines 
endfunction

function! s:register_value(lines)
  return eval("@".matchstr(join(a:lines), '.', 1))
endfunction

function! s:register_insert(e)
  execute 'normal '.matchstr(a:e, '^".').'p '
endfunction

nnoremap <silent> "<c-r> :call fzf#run({
      \   'source':  <sid>register_list(),
      \   'sink':    function('<sid>register_insert'),
      \   'options': "+m",
      \   'down':    len(<sid>register_list()) + 2,
      \ })<CR>
