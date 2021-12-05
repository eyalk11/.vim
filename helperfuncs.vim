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
		if and(winnr!=curwin,or((ft!~'netranger'),last2))
			execute ':'.winnr.'close!'
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
	norm "xp
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
	let func=input('Enter python to execute(match is the input):	')
	echo "\<CR>"
	let retInVim=RunPython(@x,func)
    return retInVim
endfunction

function! HandleCF()
	let func=input('Enter "cmd" to eval vim cmd(@x is arg): 	')
	" echo "\<CR>"
	return eval(func)
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

function! HandleCommand(item)
	call feedkeys("zq:")
    call feedkeys("G?\\V".escape(a:item,'\/?')."\<CR>",'n')
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
		:let g:airline_extensions = []
		:CocDisable
		:ALEDisable
		:NoMatchParen
	:autocmd! InsertLeave *
	:autocmd! TextYankPost *
    ":syntax disable
	"augroup fugitive
		"autocmd! BufWriteCmd *
		"autocmd! FileWriteCmd *
	"augroup END
	endif
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
