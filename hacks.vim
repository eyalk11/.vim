"Last windows names
"
"
exec 'source ' . g:vimloc . "/inserts.vim"
call EnableTrackInserts(0)
let g:lastWindows= []
let g:lastWinName = ""
let g:last_yank="mechu"
let g:max_inserts_for_file = []
function! GetLastWind()
    return g:lastWindows
endfunction
function! SaveLastWindow()

if &bt == '' || &bt == 'help' || &ft == 'netranger' "|| &bt == 'nofile'
    let cur= fnamemodify(bufname('%'),":p")
    "let cur = expand('%:p')

    if cur == g:lastWinName || cur ==""
        return
    endif 
    if cur =~ 'term.*'
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
py3 << EOF
import vim
import pickle
output = open(vim.eval('g:vimloc')+'\\inserts.cache', 'wb')
pickle.dump(inserts ,output)
output.close()
EOF
endfunction



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
command! -nargs=1 M call Matches(<q-args>)
command! -nargs=1 MW call Matches('\<'.<q-args>.'\>')
command! -nargs=1 MC call InMatches(<q-args>)
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

function! StartSpecialLines()
    nmap my <Plug>(easymotion-sol-bd-jk)
    au User EasyMotionPromptEnd <buffer> echo "aaa"
endfunction 

function! CheckSpecialInsert()
    if g:special_insert
        au monitor CursorHoldI * echom "Insert timed out" | call feedkeys("\<esc>") | call EndSpecialInsert()
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


autocmd User visual_multi_start call MyVmStart()
autocmd User visual_multi_end call MyVmEnd() 
function! MyVmStart()
    let b:old_save_inserts=get(b:,'save_inserts',0) 
    let b:save_inserts=0 
endfunction
function! MyVmEnd()
    let b:save_inserts=get(b:,'old_save_inserts',1) 
    unlet b:old_save_inserts
endfunction
"timer func
"
"
au ExitPre call StopTimerFunc() 
function! StopTimerFunc()
    call timer_stop(g:autosaveWS)
    call timer_stop(g:timerb)

endfunction

let g:last_copied=""
let g:init=0
norm <plug>timech <CMD>checktime<CR>
function! TimerFunc(a)
 if mode() != 'n' ||  getcmdwintype() != ''
     return
endif

    try
    norm! mM
    "norm <plug>timech
    ":profile dump 
    "updates shada files to keep current commands
    wshada
    "let minbu=MinExec(':buffers')
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
        ":silent :CtrlSpaceSaveWorkspace default
        endif
        "if g:init==0
        "let g:init=1
        "call ToggleVerbose() 
    endif
catch
endtry 

        ":profile stop

endfunction

function! TimerFuncB(a)
    "echo "gg"
    "keep track of external clipboard using registers.
    py3 import pyperclip
    
try 
    let tm=getreg('*') 
    if len(tm) > 80000
        return 
    end 

    if g:last_copied!=tm && tm!=getreg('"')
        "from o to w contextmanager&& tm!=getreg('"') 
        "external copy
        "echo "xx"
        for i in range(char2nr('v'),char2nr('o'),-1)
            exe "let @".nr2char(i+1)." = @". nr2char(i) 
        endfor
        "call AddInsert(getreg("@+"))

        let @o=@+
        let g:last_copied=@+
    endif
catch
endtry
endfunction 

function! SaveLastReg()
        if (exists("b:save_inserts")==0)
            return
        endif
    if (b:save_inserts==0)
        return
    endif
    if v:event['regname']==""
        if v:event['operator']=='y'
            if @1 == g:last_yank
                return
            endif
            for i in range(8,2,-1)
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
    exec ':'.buffernumber . 'bufdo norm \<nop>'


endfunction
command! -nargs=* -complete=file TN if HandleTN(<q-args>) <bar>  :let tab=WhichTab(<f-args>) <bar> if tab==0 <bar> :tabnew <args> <bar>  endif <bar> endif


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
      \ })<CR>s:



func! GrepPy()
    call AddFiles("find . -iname '*.py' | grep -v __init__")
endfunc
func! AddFiles(grep)
redir => tmp
   call RunPS('RunBash "' . a:grep . '"')
   redir END
   for l in split(tmp,'\n')
       if filereadable(l) 
           exec ':e '.l
        endif
    endfor

   "echo x
endfunc
func! RunPS(var)
    if g:pwmod==0
        call TogglePS()
        exec 'silent! !Import-Module C:\Users\ekarni\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1;' . a:var
        call TogglePS()
    else
        exec 'silent! !Import-Module C:\Users\ekarni\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1;' . a:var
    endif
endfunction 

func! TogglePS()
        if g:pwmod
            let &shell= g:sh  
            let &shellcmdflag=g:shf
            let &shellredir=g:shr
            let &shellpipe=g:shellpipe
            let &shellquote=g:shq
            let &shellxquote=g:shxq
        else
            let &shell = executable('pwsh') ? 'powershell' : 'pwsh'
            let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
            let &shellredir = ' | Out-File -Encoding UTF8 %s; exit $LastExitCode'
            let &shellpipe = ' | Out-File -Encoding UTF8 %s; exit $LastExitCode'
            set shellquote= shellxquote=
        endif
        let g:pwmod= ! g:pwmod
endfunction

function! FilterAll(str,del)
    if a:del
        exec ":%d"
    endif
    exec ":r !cat % | " . a:str
endfunction

command! -nargs=* Filter call FilterAll(<f-args>) 

function! FilterJson(del)
    call FilterAll("python -m json.tool", a:del)
endfunction


function! ConvHex()
    let x=input('enter num:')
    exe "py3  print(hex(".x ."))"
endfunction 

function! ToggleVerbose()
    if !&verbose
        :!rm ~/.vim/verbose.log
        :!touch ~/.vim/verbose.log
        set verbosefile=~/.vim/verbose.log
        set verbose=15
    else
        set verbose=0
        set verbosefile=
    endif
endfunction
function! DebugIt(interval)
    for i in range(1,line('$'), a:interval)
        exe ":" . i
        exe "normal! Oecho 'In ' . line('.')\<CR>"
    endfor
endfunction

function! GetVisualSelection() abort
  let [lineSelection, colSelection] = getpos('v')[1:2]
  let [lineCursor, colCursor]       = getpos('.')[1:2]

  " Swap line numbers if selection starts at cursor
  let [lineStart, lineEnd]          = (lineSelection <= lineCursor) ? [lineSelection, lineCursor] : [lineCursor, lineSelection]

  let lines = getline(lineStart, lineEnd)

  let mode = mode()
  if mode is# "\<C-v>"
    let mode = 'v'
    if lineStart < lineEnd
      echoerr 'block-wise selection unsupported, assuming character-wise selection'
    endif
  endif
  if mode is# 'v'
    " Swap column numbers if selection starts at cursor
    let [colStart, colEnd] = (colSelection <= colCursor) ? [colSelection, colCursor] : [colCursor, colSelection]
    let lines[-1] = lines[-1][:colEnd - (&selection is# 'inclusive' ? 1 : 2)]
    let lines[0]  = lines[0][colStart - 1:]
  endif
  " if mode is# 'V'

  if &l:fileformat is# 'dos'
    let ending = "\<CR>\<NL>"
  elseif &l:fileformat is# 'mac'
    let ending = "\<CR>"
  else " if is# 'unix'
    let ending = "\<NL>"
  endif

  return join(lines, ending)
endfunction

function! CloseAllBuffersButCurrent()
    %bd
    e#
endfunction
"Closes the other buffers but Nerdtree. Unless only 2 buffers left. In this
"case, closes nerdtree.
function! CloseAllWindowsButCurrent()
    let tabnr= tabpagenr()
    let tabinfo=gettabinfo(tabnr)
    let windows=tabinfo[0]['windows']
    let last2=(len(windows)==2)

    for winid in windows
        let curwin=winnr() "could change
        let winnr=win_id2win(winid)
        let ft= getbufvar(winbufnr(winnr), '&filetype')
        if and(winnr!=curwin,or((ft!~'NvimTree'),last2))
            execute ':'.winnr.'close!'
            return
        endif
    endfor
endfunction

function! CloseAllNR()
    let tabnr= tabpagenr()
    let tabinfo=gettabinfo(tabnr)
    let windows=tabinfo[0]['windows']
    let last2=(len(windows)==2)
    for winid in windows
        let curwin=winnr() "could change
        let winnr=win_id2win(winid)
        let ft= getbufvar(winbufnr(winnr), '&filetype')
        if (ft=~'netranger')
            execute ':'.winnr.'q!'
        endif
    endfor
endfunction

function! Goprev()
    exec 'redir @x | silent ls | redir END'
    if match(@x,'"\[Location List\]"') >= 0
            lprev
    elseif match(@x,'"\[Quickfix List\]"') >= 0
            cprev
    else
            exec 'echo "Neither Location or Quicklist found!"'
    endif
endfunction

function! Gonext()
    exec 'redir @x | silent ls | redir END'
    if match(@x,'"\[Location List\]"') >= 0
            lnext
    elseif match(@x,'"\[Quickfix List\]"') >= 0
            cnext
    else
            "exec 'echo "Neither Location or Quicklist found!"'
            copen
    endif
endfunction

"executes command, return lines as string
function! MinExec(cmd)
    redir => tmp
    exec printf('silent %s',a:cmd)
    redir END
    return tmp
endfunction

"Remaps repeat pairs
function! RepRemap(mapA,mapB)
let varA=maparg(a:mapA,'n')
let varB=maparg(a:mapB,'n')
execute "nmap <expr> " . a:mapA . " repmo#Key('".varA ."', '". varB. "')"
execute "nmap <expr> " . a:mapB . " repmo#Key('".varB ."', '". varA. "')"
endfunction

"executes command , opens in new tab all the lines. useful in cases of :map
function! Exec(cmd)
    redir @x
    exec printf('silent %s',a:cmd)
    redir END
    tabnew
    norm! "xp
endfunction



function! PInsert2(item)
    let @z=a:item
    norm "zp
    call feedkeys('a')
endfunction

function! PInsert(item)
    let @z=a:item
    norm "zp
endfunction
function! ExportC()
python << EOF
x=vim.eval("@x").replace('\n','').replace(" ","")
if len(x)%2!=0:
    print 'bad x'
else:
    st='unsigned char bytes[] ={'
    st+=','.join(['0x'+x[i:i+2]  for i in xrange(0,len(x),2)])
    st+='};'
    vim.command("let sInVim = '%s'"% st)
    vim.command("let @+=sInVim")
EOF
endfunction

function! Search()
    :M @x
endfunction

function! HandleCJ()
    let func=input('type cmd to execute (calls execute funct). @x is match')
    echo "\<CR>"
    execute func
endfunction

function! HandleCH()
    let func=input('type cmd to eval vim command (@x is arg)/ExportC()/Search())')
    echo "\<CR>"
    echo eval(func)
endfunction


function! HandleH()
    let func=input('Enter "cmd" to eval vim cmd(@x is arg): 	')
" echo "\<CR>"
return eval(func)
endfunction

function! HandleCF()
    let func=input('Enter python to execute(match is the input):	')
echo "\<CR>"
let retInVim=RunPython(@x,func)
return retInVim
endfunction


function! HandleF()
    let func=input("Enter python to eval(match is the input,@x is arg): ")
    " echo "\<CR>"
    let retInVim=RunPython2(@x,func)
    return retInVim
endfunction

function! CopyPath()
    let @+=expand('%:p')
endfunction

function! DisableKeys()
    noremap <Up> <Nop>
    noremap <Down> <Nop>
    noremap <Left> <Nop>
    noremap <Right> <Nop>
endfunction
"make new file
function! Ff()
exe 'norm "zy'
:echo @z
endfunction


function! GetMappings()
    let lines=MinExec('map')
    let lines=split(lines,'\n')
    return lines
endfunction

function! GetCommands()
    let lines=[]
    let nu=histnr("cmd")
    for i in range(1,nu)
        let lines+=[histget("cmd",i)]
    endfor
    return lines
endfunction

function! CdDir(item)
    :exe "cd ".a:item
endfunction
function! CdDirPlug(item)
    :exe "cd ".a:item
    norm mt
endfunction

function! HandleCommand(item)
    echo a:item
    call feedkeys(":".a:item)
    call feedkeys("\<c-b>")
    "call feedkeys("zq:")
    "call feedkeys("G?\\V".escape(a:item,'\/?$')."\<CR>",'n')
    
endfunction

function! BH(item)
    exe ":T " . a:item
endfunction

function! Wolfram()
    :g/Out\[/d
    :%s/In\[.*\]:=//g
endfunction


function! MakeItFaster(adv)
    if (a:adv)
        "GitGutterDisable
        "au! autotag
        :let g:airline_extensions = []
        au! gitgutter
        ":CocDisable
        ":ALEDisable
        :NoMatchParen
    ":autocmd! InsertLeave *
    ":autocmd! TextYankPost *
    ":syntax disable
    "augroup fugitive
        "autocmd! BufWriteCmd *
        "autocmd! FileWriteCmd *
    "augroup END
    endif
    ":autocmd! InsertLeave *
    ":autocmd! TextYankPost *
    ":GitGutterDisable
    "autocmd! BufReadPre //*
    ":Fugitive?
    ":autocmd! BufWritePre *
    ":autocmd! BufWritePost *
    ":autocmd! BufWrite *
endfunction




"to replace multiple lines in another windows copy to reg first 
 function! Dorep()
     let aa=split(getreg('c'),'\n')
     for k in aa
         exe "g/".k."/norm I\/\/U"
     endfor 
 endfunction 
if g:on_ek_computer 
"     source ~/vimpy3/secfunc.vim
endif

function! ReplaceRPC()
%s/\[.\{-}in.\{-}\]//g
%s/\[.\{-}out.\{-}\]//g
endfunction 

function! MakeJson(...)
    if a:0 > 0
     let override = a:1
   else
     let override = 0
   end 
PY << EOF
import os
import json
uu=(not os.path.exists('.vimspector.json')) or vim.eval('override')
if uu==1:
    print('making')
    dir=vim.eval('expand("%:h")')
    prog= vim.eval('expand("%:p")')
    name= vim.eval('expand("%:t")').replace('.py','')
    data={
      "configurations": {
        "genhash: Launch": {
          "adapter": "debugpy",
          "configuration": {
            "name": name+": Launch",
            "type": "python",
            "request": "launch",
            "python": "/Users/ekarni/.pyenv/versions/3.8.5/bin/python3" ,
            "cwd": dir,
            "stopOnEntry": "true",
            "console": "externalTerminal",
            "debugOptions": [],
            "justMyCode":"true",
            "program": prog,
            "args":[],
            #"env" :
            #            {"PYTHONPATH":"/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/"}
          }
        }
      }
    }
    with open('.vimspector.json', 'w') as outfile:
        json.dump(data, outfile,sort_keys=True,indent=4, separators=(',', ': '))
else:
    print('already exists')
EOF
endfunction

function! MakeJson2(...)
    if a:0 > 0
     let override = a:1
   else
     let override = 0
   end 
PY << EOF
import os
import json
uu=(not os.path.exists('.vimspector.json')) or vim.eval('override')
if uu==1:
    print('making')
    dir=vim.eval('expand("%:h")')
    prog= vim.eval('expand("%:p")')
    name= vim.eval('expand("%:t")').replace('.py','')
    data={
      "configurations": {
        "genhash: Launch": {
          "adapter": "debugpy",
          "configuration": {
            "name": name+": Launch",
            "type": "python",
            "request": "launch",
            "python": "/Users/ekarni/.pyenv/versions/2.7.18/bin/python2.7" ,
            "cwd": dir,
            "stopOnEntry": "true",
            "console": "externalTerminal",
            "debugOptions": [],
            "justMyCode":"true",
            "program": prog,
            "args":[],
            #"env" :
            #            {"PYTHONPATH":"/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/"}
          }
        }
      }
    }
    with open('.vimspector.json', 'w') as outfile:
        json.dump(data, outfile,sort_keys=True,indent=4, separators=(',', ': '))
else:
    print('already exists')
EOF
endfunction

function! SSHAgent()
    :!eval "$(ssh-agent -s)"
    :!ssh-add 
endfunction 


"function! STab_Or_Complete()
  "if mode(1)=='ic'||mode(1)=='ix'
    "return "\<C-P>"
  "else
    "return "\<S-Tab>"
  "endif
"endfunction

"function! Tab_Or_Complete()
  "if mode(1)=='ic'||mode(1)=='ix'
    "return "\<C-N>"
  "else
    "return "\<Tab>"
  "endif
"endfunction
func! ToggleHebrew()
  if &rl
    set norl
    set keymap=
  else
    set rl
    set keymap=hebrew
  end
endfunc

func! FixCoc()
    let g:WorkspaceFolders=[getcwd()]
    CocRestart
endfunc

function! GetIt()
    let x = getreg('+')
    let x = substitute(x,'/mnt/c','c:','')
    exec ':e '. x
endfunction

if has('nvim')
":autocmd BufRead * call LoadInsertsForBuf()
":autocmd BufNewFile if !exists('b:inserts') <bar> let b:inserts=[]
":call StartO('')
:autocmd TextYankPost * call SaveLastReg()
:autocmd DirChanged * call SaveLastDir()
endif

function! ReloadBuf()
    :let x=expand('%:p')
    :bd
    :exe ':e '.x
endfunction
function! ReloadBufs()
    :bufdo :e
endfunction

function! OnWinEnter()
    if !&filetype
        filetype detect
    endif
endfunction

function StartProfile()
profile start ~\.vim\profile 
profile func *
endfunction 
function ProfileStop()
        profile stop
endfunction

function! ExecuteCommandOnQuickfixLines(command,pattern)
    lua vim.diagnostic.setqflist()
    let quickfix_list = getqflist()
    " Iterate over each entry in the quickfix list
    for entry in quickfix_list
        " Get the file name and line number of the entry
        let linenumber = entry['lnum']
        let message = entry['text']
        if message =~ a:pattern 
            exec a:command 
        endif 
#            then delete line 


        " Open the file and move to the specified line
        "execute 'edit ' . filename
        "execute linenumber
        " Execute the desired command on the line
        "execute 'normal! ' . a:command
    endfor
endfunction
function! IsRegular()
    return (&ma==1) && (bufname("%")!='' || (&filetype!="TelescopePrompt"))
endfunction

function! CreateList() range
'<,'>s/^\(.*\)$/"\1",
norm x
norm gvgJ
norm x
endfunction
command! -range CL <line1>,<line2>call CreateList()

function! ReplaceCasing(word,ow)
    exec ":noautocmd vimgrep /" . a:ow.'/ `git ls-files`' 
    exec ":noautocmd :cdo :s/". a:ow. "/" . a:word . "/g"
    exec ":noautocmd vimgrep /\\c" . a:word.'/ `git ls-files`' 
    exec ":noautocmd :cdo :s/\\c". a:word. "/" . a:word . "/g"
endfunction 

function! ReplaceCasing(word,ow)
     exec ":%s/\\c". a:ow. "/" . a:word . "/g"
     exec ":%s/\\c". a:word. "/" . a:word . "/g"
endfunction 
function! PathExpand(path)
    return fnameescape(expand(a:path))
endfunction
"not clear
function! SourceCustoms(...)
    for vimfile in a:000
        try
            " Converts the path properly for win or unix
            exec 'source ' . g:vimloc .  expand('/'. vimfile)
        catch
            echom "Exception from" v:throwpoint ":"
            echom v:exception
            if has('nvim')
                lua if debug.stacktrace then print(debug.stacktrace()) end
            endif
            echom ""
        endtry
    endfor
endfunction



let s:quotes = ['"', '''', '`']

function! s:matchquote()
  normal! m'

  " character_at_cursor
  let c = matchstr(getline('.'), '\%'.col('.').'c.')

  if index(s:quotes, c) >= 0

    let num = len(split(getline('.'), c, 1)) - 1
    if num % 2 == 1
      return
    endif

    " is quotation mark under cursor odd or even?
    let col = getpos('.')[2]
    let num = len(split(getline('.')[0:col-1], c, 1)) - 1

    let mvmt = num % 2 == 0 ? 'F' : 'f'
    execute 'normal!' mvmt.c
  else
    " fallback
    execute "normal \<plug>(matchup-%)"
  endif

endfunction
function! GoToWindowWithCinkeys()
" Save the current window number
let l:current_win = winnr()

" Loop over all windows
for l:win in range(1, winnr('$'))
    " Select the window
    execute l:win . 'wincmd w'

    " Check if the 'cinkeys' option equals 'chatgptp'
    if &cinkeys == 'chatgptp'
        " Found the window, return
        return
    endif
endfor

" If we didn't find the window, go back to the original window
execute l:current_win . 'wincmd w'
endfunction

" Call the function

nnoremap <silent> <Plug>(MatchMetaN) :call <SID>matchquote()<CR>
function! GenerateMappings(functions, const_prefix)
    " Generate mappings for a list of functions using const_prefix
    " Only creates mappings for functions that don't already have mappings
    "
    " Args:
    "   functions: List of function names to map
    "   const_prefix: Prefix for all key mappings (e.g., '<Leader>f')
    "
    " Example usage:
    "   :call GenerateMappings(['Diffwidg', 'MyFunc'], '<Leader>f')

    let l:mapped_keys = {}

    " Get existing mappings
    redir => l:map_output
    silent map
    redir END

    " Parse existing mappings to find what's already mapped
    for l:line in split(l:map_output, "\n")
        let l:parts = split(l:line)
        if len(l:parts) >= 2
            " Extract the key from mapping line
            let l:key = l:parts[1]
            let l:mapped_keys[l:key] = 1
        endif
    endfor

    " Generate new mappings for functions
    let l:available_keys = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let l:key_index = 0

    for l:func in a:functions
        " Find an unmapped key
        while l:key_index < len(l:available_keys)
            let l:key = l:available_keys[l:key_index]
            let l:mapping = a:const_prefix . l:key

            " Check if this key combination is already mapped
            if !has_key(l:mapped_keys, l:mapping)
                " Create the mapping
                execute "nnoremap " . l:mapping . " :call " . l:func . "()<CR>"
                echo "Mapped " . l:mapping . " to function " . l:func
                break
            endif

            let l:key_index += 1
        endwhile

        " Check if we ran out of available keys
        if l:key_index >= len(l:available_keys)
            echo "Warning: Ran out of available keys for mapping function " . l:func
        else
            let l:key_index += 1  " Move to next key for next function
        endif
    endfor

    echo "Mapping generation complete"
endfunction

" Delete current file and buffer
function! DeleteMe()
    let l:filepath = expand('%:p')
    if empty(l:filepath)
        echohl ErrorMsg
        echo "Error: No file to delete (empty buffer)"
        echohl None
        return
    endif

    if !filereadable(l:filepath)
        echohl ErrorMsg
        echo "Error: File does not exist or is not readable"
        echohl None
        return
    endif

    let l:confirm = confirm('Delete file: ' . l:filepath . '?', "&Yes\n&No", 2)
    if l:confirm != 1
        echo "Deletion cancelled"
        return
    endif

    " Delete the buffer first
    let l:bufnr = bufnr('%')
    let l:bufcount = len(getbufinfo({'buflisted':1}))

    " If this is the last buffer, create a new empty one
    if l:bufcount == 1
        enew
    else
        bprevious
    endif

    " Delete the buffer
    execute 'bdelete! ' . l:bufnr

    " Delete the file
    if has('win32') || has('win64')
        call system('del /Q "' . l:filepath . '"')
    else
        call delete(l:filepath)
    endif

    if filereadable(l:filepath)
        echohl ErrorMsg
        echo "Error: Failed to delete file"
        echohl None
    else
        echo "Deleted: " . l:filepath
    endif
endfunction

command! -nargs=0 DeleteMe call DeleteMe()

" Move current file to another location
function! MoveMe(...)
    let l:current = expand('%:p')
    if empty(l:current)
        echohl ErrorMsg
        echo "Error: No file to move (empty buffer)"
        echohl None
        return
    endif

    if !filereadable(l:current)
        echohl ErrorMsg
        echo "Error: Current file does not exist"
        echohl None
        return
    endif

    " Get destination path
    if a:0 > 0
        let l:dest = expand(a:1)
    else
        let l:dest = input('Move to: ', l:current, 'file')
        if empty(l:dest)
            echo "Move cancelled"
            return
        endif
    endif

    " If destination is a directory, append the filename
    if isdirectory(l:dest)
        let l:dest = l:dest . '/' . fnamemodify(l:current, ':t')
    endif

    " Normalize path separators for Windows
    if has('win32') || has('win64')
        let l:dest = substitute(l:dest, '/', '\', 'g')
    endif

    " Check if destination already exists
    if filereadable(l:dest)
        let l:confirm = confirm('Destination exists. Overwrite?', "&Yes\n&No", 2)
        if l:confirm != 1
            echo "Move cancelled"
            return
        endif
    endif

    " Move the file
    if has('win32') || has('win64')
        call system('move /Y "' . l:current . '" "' . l:dest . '"')
    else
        call rename(l:current, l:dest)
    endif

    " Check if move was successful
    if filereadable(l:dest) && !filereadable(l:current)
        " Update the buffer to point to the new location
        execute 'file ' . fnameescape(l:dest)
        execute 'edit! ' . fnameescape(l:dest)
        echo "Moved to: " . l:dest
    else
        echohl ErrorMsg
        echo "Error: Failed to move file"
        echohl None
    endif
endfunction

command! -nargs=? -complete=file MoveMe call MoveMe(<f-args>)
